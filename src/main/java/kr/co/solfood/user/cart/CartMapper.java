package kr.co.solfood.user.cart;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CartMapper {
    
    // 장바구니 조회 (사용자별)
    CartVO getCartByUserId(@Param("usersId") int usersId);
    
    // 장바구니 생성
    int insertCart(CartVO cart);
    
    // 장바구니 업데이트
    int updateCart(CartVO cart);
    
    // 장바구니 삭제
    int deleteCart(@Param("cartId") int cartId);
    
    // 장바구니 아이템 목록 조회
    List<CartItemVO> getCartItems(@Param("cartId") int cartId);
    
    // 장바구니 아이템 추가
    int insertCartItem(CartItemVO cartItem);
    
    // 장바구니 아이템 수량 업데이트
    int updateCartItemQuantity(@Param("cartItemId") int cartItemId, @Param("quantity") int quantity);
    
    // 장바구니 아이템 삭제
    int deleteCartItem(@Param("cartItemId") int cartItemId);
    
    // 장바구니 아이템 중복 체크
    CartItemVO getCartItemByMenuId(@Param("cartId") int cartId, @Param("menuId") int menuId);
    
    // 장바구니 전체 비우기
    int clearCart(@Param("cartId") int cartId);
    
    // 사용자별 장바구니 아이템 개수
    int getCartItemCount(@Param("usersId") int usersId);
} 