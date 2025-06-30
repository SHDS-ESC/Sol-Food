package kr.co.solfood.user.cart;

import javax.servlet.http.HttpSession;

public interface CartService {
    
    // 세션에서 장바구니 가져오기
    CartVO getCart(HttpSession session);
    
    // 장바구니에 메뉴 추가
    boolean addToCart(HttpSession session, int menuId, int quantity);
    
    // 장바구니 아이템 수량 변경
    boolean updateQuantity(HttpSession session, int menuId, int quantity);
    
    // 장바구니 아이템 삭제
    boolean removeItem(HttpSession session, int menuId);
    
    // 장바구니 전체 비우기
    void clearCart(HttpSession session);
    
    // 장바구니 아이템 개수 조회
    int getCartItemCount(HttpSession session);
} 