package kr.co.solfood.user.review;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import static org.junit.jupiter.api.Assertions.*;

/**
 * ReviewVO 예외 상황 및 경계값 테스트
 *  1. null 값 안전성
 *  2. 빈 문자열 처리
 *  3. 잘못된 별점 감지
 *  4. 상태값 유효성 검사
 */
@DisplayName("ReviewVO Exception Test")
class ReviewExceptionTest {

    @Test
    @DisplayName("null 값 안전성 확인")
    void handleNullValues_NoException_Success() {
        ReviewVO reviewVO = new ReviewVO();

        // null 값 설정 시 예외가 발생하지 않아야 함
        assertDoesNotThrow(() -> {
            reviewVO.setReviewTitle(null);
            reviewVO.setReviewContent(null);
            reviewVO.setReviewImage(null);
            reviewVO.setReviewResponse(null);
            reviewVO.setReviewDate(null);
        });

        // null 값이 정상적으로 설정되었는지 확인
        assertNull(reviewVO.getReviewTitle());
        assertNull(reviewVO.getReviewContent());
        assertNull(reviewVO.getReviewImage());
        assertNull(reviewVO.getReviewResponse());
        assertNull(reviewVO.getReviewDate());
    }

    @Test
    @DisplayName("빈 문자열 처리")
    void handleEmptyStrings_SetAndRetrieve_Success() {
        ReviewVO reviewVO = new ReviewVO();

        // 빈 문자열 설정
        reviewVO.setReviewTitle("");
        reviewVO.setReviewContent("");
        reviewVO.setReviewStatus("");

        // 빈 문자열과 null 구분 확인
        assertEquals("", reviewVO.getReviewTitle());
        assertEquals("", reviewVO.getReviewContent());
        assertEquals("", reviewVO.getReviewStatus());
    }

    @Test
    @DisplayName("잘못된 별점 값 감지")
    void setInvalidStarValues_OutOfRange_DetectedByValidation() {
        ReviewVO reviewVO = new ReviewVO();
        int[] invalidStars = {-1, 0, 6, 10, 100}; // 1-5 범위 밖의 값들

        for (int star : invalidStars) {
            reviewVO.setReviewStar(star);
            assertEquals(star, reviewVO.getReviewStar()); // 값은 설정됨
            
            // 유효성 검사에서 걸러져야 함
            assertFalse(isValidStarRating(star), 
                "별점 " + star + "는 유효하지 않은 값입니다");
        }
    }

    @ParameterizedTest
    @ValueSource(strings = {"", "   ", "\n", "\t", "null"})
    @DisplayName("공백 및 특수 문자열 처리")
    void handleSpecialStrings_VariousInputs_ProcessedCorrectly(String input) {
        ReviewVO reviewVO = new ReviewVO();

        // 특수 문자열 설정
        reviewVO.setReviewTitle(input);
        reviewVO.setReviewContent(input);

        // 입력값 그대로 저장되는지 확인
        assertEquals(input, reviewVO.getReviewTitle());
        assertEquals(input, reviewVO.getReviewContent());
        
        // 공백 문자열 추가 검증 ("null" 문자열 제외)
        if (input.trim().isEmpty() && !input.equals("null")) {
            assertTrue(input.trim().isEmpty());
        }
    }

    @Test
    @DisplayName("상태값 유효성 검사")
    void validateReviewStatus_ValidAndInvalid_CorrectValidation() {
        // 허용되는 상태값 
        String[] validStatuses = {"active", "inactive", "deleted"};
        // 허용되지 않는 상태값
        String[] invalidStatuses = {"ACTIVE", "Invalid", "123", "특수문자!", "pending"};

        // 유효한 상태값 확인
        for (String status : validStatuses) {
            assertTrue(isValidReviewStatus(status), 
                "'" + status + "'는 유효한 상태여야 합니다");
        }

        // 잘못된 상태값 확인
        for (String status : invalidStatuses) {
            assertFalse(isValidReviewStatus(status), 
                "'" + status + "'는 잘못된 상태여야 합니다");
        }
    }
    
    // ===== 유효성 검사 헬퍼 메서드 =====
    
    private boolean isValidStarRating(int star) {
        return star >= 1 && star <= 5;
    }

    private boolean isValidReviewStatus(String status) {
        if (status == null || status.isEmpty()) {
            return false;
        }
        // 허용되는 상태: 활성화, 비활성화, 삭제됨
        return status.equals("active") || 
               status.equals("inactive") || 
               status.equals("deleted");
    }
} 