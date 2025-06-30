package kr.co.solfood.user.menu;

import kr.co.solfood.user.cart.Cart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user/menu")
public class MenuController {

    @Autowired
    private final MenuService menuService;

    public MenuController(MenuService menuService) {
        this.menuService = menuService;
    }

    // 메뉴 상세
    @GetMapping("/detail")
    public String menuDetail(@RequestParam("menuId") Integer menuId, Model model) {
        if (menuId == null || menuId <= 0) {
            model.addAttribute("errorMessage", "유효하지 않은 메뉴 ID입니다.");
            return "error/400";
        }
        MenuVO menu = menuService.getMenuById(menuId);
        if (menu == null) {
            model.addAttribute("errorMessage", "해당 메뉴를 찾을 수 없습니다.");
            return "error/404";
        }
        model.addAttribute("menu", menu);
        return "user/store/menu-detail";
    }

    // 장바구니 담기(AJAX)
    @PostMapping("/addCart")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addCart(@RequestParam("menuId") Integer menuId,
                                                       @RequestParam("quantity") Integer quantity,
                                                       HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            // 1. 파라미터 검증
            if (menuId == null || menuId <= 0 || quantity == null || quantity <= 0) {
                result.put("result", "fail");
                result.put("message", "유효하지 않은 요청입니다.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(result);
            }

            // 2. 메뉴 존재 여부 확인
            MenuVO menu = menuService.getMenuById(menuId);
            if (menu == null) {
                result.put("result", "fail");
                result.put("message", "해당 메뉴를 찾을 수 없습니다.");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(result);
            }

            // 3. 세션에서 장바구니 꺼내기
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null) {
                cart = new Cart();
            }

            // 4. 장바구니에 추가
            cart.addItem(menu, quantity);
            session.setAttribute("cart", cart);

            result.put("result", "success");
            result.put("message", "장바구니에 메뉴가 추가되었습니다.");
            result.put("menuId", menuId);
            result.put("quantity", quantity);

            return ResponseEntity.ok(result);

        } catch (Exception e) {
            result.put("result", "fail");
            result.put("message", "예상치 못한 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(result);
        }
    }
}
