package kr.co.solfood.user.menu;

import kr.co.solfood.user.cart.Cart;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/user/menu")
public class MenuController {
    @Autowired
    private MenuService menuService;

    // 메뉴 상세
    @GetMapping("/detail")
    public String menuDetail(@RequestParam("menuId") Integer menuId, Model model) {
        MenuVO menu = menuService.getMenuById(menuId);
        model.addAttribute("menu", menu);
        return "user/store/menu-detail";
    }

    // 장바구니 담기(AJAX)
    @PostMapping("/addCart")
    @ResponseBody
    public String addCart(@RequestParam("menuId") Integer menuId,
                          @RequestParam("quantity") Integer quantity,
                          HttpSession session) {
        // 장바구니 세션 가져오기
        Cart cart = (Cart) session.getAttribute("cart");
        if(cart == null){
            cart = new Cart();
        }
        // 2. 메뉴 정보는 DB에서 조회
        MenuVO menu = menuService.getMenuById(menuId);

        //3. 장바구니에 추가
        cart.addItem(menu, quantity);

        //4. 세션에 장바구니 저장
        session.setAttribute("cart", cart);

        return "장바구니에 메뉴가 추가되었습니다. 메뉴 ID: " + menuId + ", 수량: " + quantity ;
    }
}
