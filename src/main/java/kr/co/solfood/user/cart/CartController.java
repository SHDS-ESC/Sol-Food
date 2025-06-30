package kr.co.solfood.user.cart;

import kr.co.solfood.common.constants.UrlConstants;
import kr.co.solfood.user.login.UserVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/user/cart")
public class CartController {
    
    @Autowired
    private CartService cartService;
    
    /**
     * 장바구니 페이지
     */
    @GetMapping
    public String cartPage(HttpSession session, Model model) {
        UserVO user = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (user == null) {
            return UrlConstants.Redirect.TO_USER_LOGIN;
        }
        
        CartVO cart = cartService.getCart(session);
        model.addAttribute("cart", cart);
        
        return "user/cart/cart";
    }
    
    /**
     * 장바구니에 메뉴 추가 API
     */
    @PostMapping("/add")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> addToCart(
            @RequestParam int menuId,
            @RequestParam int quantity,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        UserVO user = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (user == null) {
            response.put("result", "error");
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(response);
        }
        
        boolean success = cartService.addToCart(session, menuId, quantity);
        
        if (success) {
            response.put("result", "success");
            response.put("message", "장바구니에 추가되었습니다.");
            response.put("cartCount", cartService.getCartItemCount(session));
        } else {
            response.put("result", "error");
            response.put("message", "장바구니 추가에 실패했습니다.");
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 장바구니 아이템 수량 변경 API
     */
    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateCartItemQuantity(
            @RequestParam int menuId,
            @RequestParam int quantity,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        UserVO user = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (user == null) {
            response.put("result", "error");
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(response);
        }
        
        boolean success = cartService.updateQuantity(session, menuId, quantity);
        
        if (success) {
            response.put("result", "success");
            response.put("message", "수량이 변경되었습니다.");
            CartVO cart = cartService.getCart(session);
            response.put("totalAmount", cart.getTotalAmount());
            response.put("cartCount", cartService.getCartItemCount(session));
        } else {
            response.put("result", "error");
            response.put("message", "수량 변경에 실패했습니다.");
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 장바구니 아이템 삭제 API
     */
    @PostMapping("/remove")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> removeCartItem(
            @RequestParam int menuId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        UserVO user = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (user == null) {
            response.put("result", "error");
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(response);
        }
        
        boolean success = cartService.removeItem(session, menuId);
        
        if (success) {
            response.put("result", "success");
            response.put("message", "장바구니에서 삭제되었습니다.");
            CartVO cart = cartService.getCart(session);
            response.put("totalAmount", cart.getTotalAmount());
            response.put("cartCount", cartService.getCartItemCount(session));
        } else {
            response.put("result", "error");
            response.put("message", "삭제에 실패했습니다.");
        }
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 장바구니 전체 비우기 API
     */
    @PostMapping("/clear")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> clearCart(HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        UserVO user = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (user == null) {
            response.put("result", "error");
            response.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(response);
        }
        
        cartService.clearCart(session);
        
        response.put("result", "success");
        response.put("message", "장바구니가 비워졌습니다.");
        response.put("cartCount", 0);
        
        return ResponseEntity.ok(response);
    }
    
    /**
     * 장바구니 아이템 개수 조회 API
     */
    @GetMapping("/count")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCartCount(HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        UserVO user = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (user == null) {
            response.put("count", 0);
            return ResponseEntity.ok(response);
        }
        
        int count = cartService.getCartItemCount(session);
        response.put("count", count);
        
        return ResponseEntity.ok(response);
    }
} 