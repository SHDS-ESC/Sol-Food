package kr.co.solfood.user.review;

/**
 * 리뷰 관련 상수 정의 클래스
 * 모든 리뷰 관련 상수값들을 중앙에서 관리
 */
public final class ReviewConstants {
    
    // 인스턴스 생성 방지
    private ReviewConstants() {
        throw new AssertionError("상수 클래스는 인스턴스화할 수 없습니다.");
    }
    
    // === 별점 관련 상수 ===
    public static final int MIN_STAR_RATING = 1;
    public static final int MAX_STAR_RATING = 5;
    
    // === 글자 수 제한 상수 ===
    public static final int MAX_CONTENT_LENGTH = 1000;
    public static final int MAX_TITLE_LENGTH = 100;
    
    // === 상태 상수 ===
    public static final String STATUS_ACTIVE = "Y";
    public static final String STATUS_INACTIVE = "N";
    
    // === 페이징 관련 상수 ===
    public static final int DEFAULT_PAGE_SIZE = 10;
    public static final int MAX_PAGE_SIZE = 100;
    
    // === 에러 메시지 상수 ===
    public static final String ERROR_REVIEW_ID_REQUIRED = "리뷰 ID가 필요합니다.";
    public static final String ERROR_STORE_ID_REQUIRED = "가게 ID가 필요합니다.";
    public static final String ERROR_USER_ID_REQUIRED = "사용자 ID가 필요합니다.";
    public static final String ERROR_REVIEW_INFO_REQUIRED = "리뷰 정보가 없습니다.";
    public static final String ERROR_CONTENT_EMPTY = "리뷰 내용은 비어있을 수 없습니다.";
    public static final String ERROR_CONTENT_TOO_LONG = "리뷰 내용은 " + MAX_CONTENT_LENGTH + "자를 초과할 수 없습니다.";
    public static final String ERROR_INVALID_STAR_RATING = "별점은 " + MIN_STAR_RATING + "점에서 " + MAX_STAR_RATING + "점 사이여야 합니다.";
} 