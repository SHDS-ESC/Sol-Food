package kr.co.solfood.user.cart;

/**
 * 장바구니 관련 상수 정의 클래스
 * 모든 장바구니 관련 상수값들을 중앙에서 관리
 */
public final class CartConstants {
    
    // 인스턴스 생성 방지
    private CartConstants() {
        throw new AssertionError("상수 클래스는 인스턴스화할 수 없습니다.");
    }
    
    // === API 응답 관련 상수 ===
    public static final String RESULT_SUCCESS = "success";
    public static final String RESULT_ERROR = "error";
    
    // === 메시지 상수 ===
    public static final String MSG_LOGIN_REQUIRED = "로그인이 필요합니다.";
    public static final String MSG_CART_ADD_SUCCESS = "장바구니에 추가되었습니다.";
    public static final String MSG_CART_ADD_FAILED = "장바구니 추가에 실패했습니다.";
    public static final String MSG_QUANTITY_UPDATE_SUCCESS = "수량이 변경되었습니다.";
    public static final String MSG_QUANTITY_UPDATE_FAILED = "수량 변경에 실패했습니다.";
    public static final String MSG_ITEM_REMOVE_SUCCESS = "장바구니에서 삭제되었습니다.";
    public static final String MSG_ITEM_REMOVE_FAILED = "삭제에 실패했습니다.";
    public static final String MSG_CART_CLEAR_SUCCESS = "장바구니가 비워졌습니다.";
    public static final String MSG_CART_ADD_ERROR = "장바구니 추가 중 오류가 발생했습니다.";
    public static final String MSG_QUANTITY_UPDATE_ERROR = "수량 변경 중 오류가 발생했습니다.";
    public static final String MSG_ITEM_REMOVE_ERROR = "메뉴 삭제 중 오류가 발생했습니다.";
    public static final String MSG_CART_CLEAR_ERROR = "장바구니 비우기 중 오류가 발생했습니다.";
    public static final String MSG_CART_COUNT_ERROR = "장바구니 개수 조회 중 오류가 발생했습니다.";
    public static final String MSG_USER_LIST_ERROR = "사용자 목록 조회 중 오류가 발생했습니다.";
    public static final String MSG_MINI_GAME_PREPARING = "🎮 미니게임 기능은 현재 준비 중입니다!\n곧 재미있는 게임들을 만나보실 수 있어요! 😊";
    
    // === 기본값 상수 ===
    public static final int DEFAULT_CART_COUNT = 0;
    public static final int MIN_QUANTITY = 1;
    public static final int MAX_QUANTITY = 99;
    
    // === URL 파라미터 상수 (Controller에서만 사용) ===
    public static final String PARAM_PAGE = "page";
    public static final String PARAM_SIZE = "size";
    public static final String PARAM_SEARCH = "search";
    
    // === JSON 응답 키 상수 ===
    public static final String JSON_RESULT = "result";
    public static final String JSON_MESSAGE = "message";
    public static final String JSON_CART_COUNT = "cartCount";
    public static final String JSON_TOTAL_AMOUNT = "totalAmount";
    public static final String JSON_COUNT = "count";
    public static final String JSON_USERS = "users";
} 