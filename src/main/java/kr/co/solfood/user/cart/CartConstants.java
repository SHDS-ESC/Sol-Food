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
    public static final String RESULT_ONGOING_PAYMENT = "ongoing_payment";
    
    // === 메시지 상수 ===
    public static final String MSG_LOGIN_REQUIRED = "로그인이 필요합니다.";
    public static final String MSG_CART_ADD_SUCCESS = "장바구니에 추가되었습니다.";
    public static final String MSG_CART_ADD_FAILED = "장바구니 추가에 실패했습니다.";
    public static final String MSG_CART_ADD_FAILED_ONGOING_PAYMENT = "진행 중인 결제가 존재합니다.";
    public static final String MSG_CART_ADD_SUCCESS_OTHER_CART = "다른 가게에 장바구니가 존재합니다. 이전 장바구니를 비웁니다.";
    public static final String MSG_CART_EMPTY = "장바구니가 비어있습니다.";
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
    
    // === 결제 상태 상수 ===
    public static final String PAYMENT_STATUS_PENDING = "pending";
    public static final String PAYMENT_STATUS_COMPLETED = "completed";
    public static final String PAYMENT_STATUS_FAILED = "failed";
    public static final String PAYMENT_STATUS_CANCELLED = "cancelled";
    
    // === 결제 정리 관련 메시지 ===
    public static final String MSG_PAYMENT_COMPLETE_CLEANUP = "결제 완료 후 정리가 완료되었습니다.";
    public static final String MSG_PAYMENT_CANCEL_CLEANUP = "결제 취소 후 정리가 완료되었습니다.";
    public static final String MSG_EXPIRED_PAYMENT_CLEANUP = "만료된 결제가 정리되었습니다.";
    
    // === 스케줄러 관련 상수 ===
    public static final int PAYMENT_EXPIRY_MINUTES = 30; // 30분 후 만료
    public static final int CLEANUP_SCHEDULE_INTERVAL = 600000; // 10분 (밀리초)
} 