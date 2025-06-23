package kr.co.solfood.user.store;

/**
 * Store 관련 상수 정의 클래스
 */
public final class StoreConstants {
    
    // 카테고리 관련 상수
    public static final String CATEGORY_ALL = "전체";
    
    // 에러 메시지
    public static final String ERROR_STORE_SAVE_FAILED = "가게 정보 저장에 실패했습니다.";
    
    // 기본값
    public static final String DEFAULT_SEARCH_KEYWORD = "음식점";
    
    private StoreConstants() {
        // 유틸리티 클래스이므로 인스턴스화 방지
    }
} 