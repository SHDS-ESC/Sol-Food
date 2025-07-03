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
    
    /**
     * 공통 장바구니 추가 로직 (내부 메서드)
     */
    private boolean addToCartInternal(HttpSession session, int menuId, int quantity, int customPrice, String options) {
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
            
            // 가격 결정 (customPrice가 0이면 기본 메뉴 가격 사용)
            int unitPrice = (customPrice > 0) ? customPrice : menu.getMenuPrice();
            
            // 장바구니 아이템 생성
            CartItemVO cartItem = new CartItemVO(
                menuId,
                menu.getMenuName(),
                menu.getMenuMainimage(),
                menu.getMenuPrice(), // 기본 메뉴 가격
                unitPrice, // 실제 단가 (옵션 포함)
                quantity,
                options // 옵션 정보
            );
            
            // 장바구니에 추가
            cart.addItem(cartItem);
            
            // 세션에 저장
            session.setAttribute(UrlConstants.Session.USER_CART, cart);
            
            log.info("장바구니에 메뉴 추가 완료: menuId=" + menuId + ", quantity=" + quantity + ", unitPrice=" + unitPrice);
            return true;
            
        } catch (Exception e) {
            log.error("장바구니 추가 중 오류 발생: {}", e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean addToCart(HttpSession session, int menuId, int quantity) {
        return addToCartInternal(session, menuId, quantity, 0, null);
    }
    
    @Override
    public boolean addToCart(HttpSession session, int menuId, int quantity, int customPrice) {
        return addToCartInternal(session, menuId, quantity, customPrice, null);
    }
    
    @Override
    public boolean addToCart(HttpSession session, int menuId, int quantity, int customPrice, String options) {
        return addToCartInternal(session, menuId, quantity, customPrice, options);
    }
    
    @Override
    public boolean addToCartWithOptions(HttpSession session, int menuId, int quantity, String selectedOptions) {
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
            
            // 옵션 데이터 안전성 검증 및 정제
            String safeOptions = validateAndCleanOptions(selectedOptions);
            
            // 옵션 가격 자동 계산
            int extraPrice = menu.calculateExtraPrice(safeOptions);
            int unitPrice = menu.getMenuPrice() + extraPrice;
            
            // 장바구니 아이템 생성 (옵션 자동 계산)
            CartItemVO cartItem = new CartItemVO(
                menuId,
                menu.getMenuName(),
                menu.getMenuMainimage(),
                menu.getMenuPrice(), // 기본 메뉴 가격
                unitPrice, // 옵션이 포함된 단가 (자동 계산)
                quantity,
                safeOptions // 정제된 옵션 정보 (JSON)
            );
            
            // 장바구니에 추가
            cart.addItem(cartItem);
            
            // 세션에 저장
            session.setAttribute(UrlConstants.Session.USER_CART, cart);
            
            log.info("장바구니에 메뉴 추가 완료: menuId={}, unitPrice={}", menuId, unitPrice);
            return true;
            
        } catch (Exception e) {
            log.error("장바구니 추가 중 오류 발생: {}", e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * 옵션 데이터 검증 및 정제
     */
    private String validateAndCleanOptions(String options) {
        if (options == null || options.trim().isEmpty()) {
            return "{}";
        }
        
        // 잘못된 형태의 데이터 사전 필터링
        String trimmedOptions = options.trim();
        if (trimmedOptions.contains("menuId:") || trimmedOptions.startsWith("{ menuId:") || 
            !trimmedOptions.startsWith("{") || !trimmedOptions.endsWith("}")) {
            log.warn("잘못된 옵션 데이터 형태 감지, 빈 객체로 대체: {}", options);
            return "{}";
        }
        
        try {
            // 옵션 데이터가 이미 올바른 JSON인지 확인
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            mapper.readTree(trimmedOptions); // JSON 파싱 테스트
            return trimmedOptions; // 올바른 JSON이면 그대로 반환
        } catch (Exception e) {
            log.warn("옵션 JSON 파싱 실패, 빈 객체로 대체: {}", options);
            return "{}"; // 파싱 실패시 빈 JSON 객체 반환
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