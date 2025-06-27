package kr.co.solfood.user.review;

import static kr.co.solfood.user.review.ReviewConstants.*;

/**
 * 리뷰 유효성 검증 전담 클래스
 * 리뷰 데이터의 유효성을 검사하는 모든 로직을 담당
 */
public class ReviewValidator {
    
    /**
     * 리뷰 전체 유효성 검증
     * @param review 검증할 리뷰 객체
     * @throws IllegalArgumentException 유효성 검증 실패 시
     */
    public static void validateReview(ReviewVO review) {
        validateReviewNotNull(review);
        validateStoreId(review.getStoreId());
        validateUserId(review.getUsersId());
        validateStarRating(review.getReviewStar());
        validateContent(review.getReviewContent());
        validateTitle(review.getReviewTitle());
    }
    
    /**
     * 리뷰 객체 null 체크
     */
    public static void validateReviewNotNull(ReviewVO review) {
        if (review == null) {
            throw new IllegalArgumentException(ERROR_REVIEW_INFO_REQUIRED);
        }
    }
    
    /**
     * 가게 ID 유효성 검증
     */
    public static void validateStoreId(Integer storeId) {
        if (storeId == null) {
            throw new IllegalArgumentException(ERROR_STORE_ID_REQUIRED);
        }
        if (storeId <= 0) {
            throw new IllegalArgumentException(ERROR_INVALID_STORE_ID);
        }
    }
    
    /**
     * 사용자 ID 유효성 검증
     */
    public static void validateUserId(Integer userId) {
        if (userId == null) {
            throw new IllegalArgumentException(ERROR_USER_ID_REQUIRED);
        }
        if (userId <= 0) {
            throw new IllegalArgumentException(ERROR_INVALID_USER_ID);
        }
    }
    
    /**
     * 별점 유효성 검증
     */
    public static void validateStarRating(Integer star) {
        if (!isValidStarRating(star)) {
            throw new IllegalArgumentException(ERROR_INVALID_STAR_RATING);
        }
    }
    
    /**
     * 리뷰 내용 유효성 검증
     */
    public static void validateContent(String content) {
        if (content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException(ERROR_CONTENT_EMPTY);
        }
        
        if (content.length() > MAX_CONTENT_LENGTH) {
            throw new IllegalArgumentException(ERROR_CONTENT_TOO_LONG);
        }
    }
    
    /**
     * 리뷰 제목 유효성 검증 (선택사항)
     */
    public static void validateTitle(String title) {
        if (title != null && title.length() > MAX_TITLE_LENGTH) {
            throw new IllegalArgumentException(ERROR_TITLE_TOO_LONG);
        }
    }
    
    /**
     * 별점 범위 체크
     */
    public static boolean isValidStarRating(Integer star) {
        return star != null && star >= MIN_STAR_RATING && star <= MAX_STAR_RATING;
    }
    
    /**
     * 리뷰 ID 유효성 검증
     */
    public static void validateReviewId(Integer reviewId) {
        if (reviewId == null) {
            throw new IllegalArgumentException(ERROR_REVIEW_ID_REQUIRED);
        }
    }
} 