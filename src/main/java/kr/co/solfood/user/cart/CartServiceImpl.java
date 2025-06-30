package kr.co.solfood.user.cart;

import kr.co.solfood.common.constants.UrlConstants;
import kr.co.solfood.user.menu.MenuMapper;
import kr.co.solfood.user.menu.MenuVO;
import kr.co.solfood.user.store.StoreMapper;
import kr.co.solfood.user.store.StoreVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;

@Slf4j
@Service
public class CartServiceImpl implements CartService {
    
    @Autowired
    private MenuMapper menuMapper;
    
    @Autowired
    private StoreMapper storeMapper;
    
    @Override
    public CartVO getCart(HttpSession session) {
        CartVO cart = (CartVO) session.getAttribute(UrlConstants.Session.USER_CART);
        if (cart == null) {
            cart = new CartVO();
            session.setAttribute(UrlConstants.Session.USER_CART, cart);
        }
        return cart;
    }
    
    @Override
    public boolean addToCart(HttpSession session, int menuId, int quantity) {
        try {
            // 메뉴 정보 조회
            MenuVO menu = menuMapper.getMenuById(menuId);
            if (menu == null) {
                log.error("메뉴를 찾을 수 없습니다. menuId: {}", menuId);
                return false;
            }
            
            // 가게 정보 조회
            StoreVO store = storeMapper.getStoreById(menu.getStoreId());
            if (store == null) {
                log.error("가게를 찾을 수 없습니다. storeId: {}", menu.getStoreId());
                return false;
            }
            
            CartVO cart = getCart(session);
            
            // 다른 가게의 메뉴인 경우 장바구니 초기화
            if (!cart.isEmpty() && cart.getStoreId() != menu.getStoreId()) {
                cart.clear();
            }
            
            // 가게 정보 설정
            if (cart.isEmpty()) {
                cart.setStoreId(menu.getStoreId());
                cart.setStoreName(store.getStoreName());
            }
            
            // 장바구니 아이템 생성
            CartItemVO cartItem = new CartItemVO(
                menuId,
                menu.getMenuName(),
                menu.getMenuMainimage(),
                menu.getMenuPrice(),
                quantity
            );
            
            // 장바구니에 추가
            cart.addItem(cartItem);
            
            // 세션에 저장
            session.setAttribute(UrlConstants.Session.USER_CART, cart);
            
            log.info("장바구니에 메뉴 추가 완료: menuId={}, quantity={}", menuId, quantity);
            return true;
            
        } catch (Exception e) {
            log.error("장바구니 추가 중 오류 발생: {}", e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean updateQuantity(HttpSession session, int menuId, int quantity) {
        try {
            CartVO cart = getCart(session);
            boolean success = cart.updateQuantity(menuId, quantity);
            
            if (success) {
                session.setAttribute(UrlConstants.Session.USER_CART, cart);
                log.info("장바구니 수량 변경 완료: menuId={}, quantity={}", menuId, quantity);
            }
            
            return success;
        } catch (Exception e) {
            log.error("장바구니 수량 변경 중 오류 발생: {}", e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean removeItem(HttpSession session, int menuId) {
        try {
            CartVO cart = getCart(session);
            boolean success = cart.removeItem(menuId);
            
            if (success) {
                session.setAttribute(UrlConstants.Session.USER_CART, cart);
                log.info("장바구니 아이템 삭제 완료: menuId={}", menuId);
            }
            
            return success;
        } catch (Exception e) {
            log.error("장바구니 아이템 삭제 중 오류 발생: {}", e.getMessage());
            return false;
        }
    }
    
    @Override
    public void clearCart(HttpSession session) {
        try {
            CartVO cart = getCart(session);
            cart.clear();
            session.setAttribute(UrlConstants.Session.USER_CART, cart);
            log.info("장바구니 전체 비우기 완료");
        } catch (Exception e) {
            log.error("장바구니 비우기 중 오류 발생: {}", e.getMessage());
        }
    }
    
    @Override
    public int getCartItemCount(HttpSession session) {
        try {
            CartVO cart = getCart(session);
            return cart.getTotalQuantity();
        } catch (Exception e) {
            log.error("장바구니 아이템 개수 조회 중 오류 발생: {}", e.getMessage());
            return 0;
        }
    }
} 