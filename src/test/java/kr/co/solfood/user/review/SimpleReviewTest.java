package kr.co.solfood.user.review;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;

/**
 * ReviewVO 객체의 기본 기능 테스트
 *  1. 객체 생성 및 필드 설정
 *  2. 필수 데이터 검증
 *  3. 1-5점 별점 시스템
 *  4. 날짜 처리
 */
@DisplayName("ReviewVO 기본 기능 테스트")
class SimpleReviewTest {

    private ReviewVO reviewVO;

    @BeforeEach
    void setUp() {
        reviewVO = new ReviewVO();
        reviewVO.setReviewId(1);
        reviewVO.setUsersId(1);
        reviewVO.setStoreId(1);
        reviewVO.setReviewStar(5);
        reviewVO.setReviewDate(new Date());
        reviewVO.setReviewStatus("active");
        reviewVO.setReviewTitle("맛있는 음식점");
        reviewVO.setReviewContent("정말 맛있었습니다!");
    }

    @Test
    @DisplayName("기본 객체 생성 및 필드 설정")
    void createReviewVO_WithBasicFields_Success() {
        // 새로운 객체 생성 및 설정
        ReviewVO newReview = new ReviewVO();
        newReview.setReviewTitle("테스트 리뷰");
        newReview.setReviewContent("테스트 내용");
        newReview.setReviewStar(4);
        newReview.setUsersId(123);
        newReview.setStoreId(456);

        // 설정 확인
        assertNotNull(newReview);
        assertEquals("테스트 리뷰", newReview.getReviewTitle());
        assertEquals("테스트 내용", newReview.getReviewContent());
        assertEquals(4, newReview.getReviewStar());
        assertEquals(123, newReview.getUsersId());
        assertEquals(456, newReview.getStoreId());
    }

    @Test
    @DisplayName("필수 필드 검증")
    void setRequiredFields_ValidData_Success() {
        // 필수 필드들 설정
        reviewVO.setUsersId(100);
        reviewVO.setStoreId(200);
        reviewVO.setReviewStar(5);
        reviewVO.setReviewTitle("훌륭한 음식점");
        reviewVO.setReviewContent("매우 만족스러운 식사였습니다.");

        // 필수 필드 존재 확인
        assertNotNull(reviewVO.getUsersId());
        assertNotNull(reviewVO.getStoreId());
        assertNotNull(reviewVO.getReviewStar());
        assertNotNull(reviewVO.getReviewTitle());
        assertNotNull(reviewVO.getReviewContent());
    }

    @ParameterizedTest
    @ValueSource(ints = {1, 2, 3, 4, 5})
    @DisplayName("1-5점 별점 시스템")
    void setReviewStar_ValidRange_Success(int starValue) {
        reviewVO.setReviewStar(starValue);
        
        assertEquals(starValue, reviewVO.getReviewStar());
        assertTrue(starValue >= 1 && starValue <= 5);
    }

    @Test
    @DisplayName("날짜 설정 및 조회")
    void setReviewDate_ValidDate_Success() {
        Date testDate = new Date();
        reviewVO.setReviewDate(testDate);

        assertNotNull(reviewVO.getReviewDate());
        assertEquals(testDate, reviewVO.getReviewDate());
    }

    @Test
    @DisplayName("상태값 설정 (3가지 상태)")
    void setReviewStatus_ValidStatuses_Success() {
        // 시스템에서 허용하는 3가지 상태 테스트 (활성화, 비활성화, 삭제됨)
        String[] validStatuses = {"active", "inactive", "deleted"};

        for (String status : validStatuses) {
            reviewVO.setReviewStatus(status);
            assertEquals(status, reviewVO.getReviewStatus());
        }
    }

    @Test
    @DisplayName("빈 객체의 기본값 확인")
    void createEmptyReviewVO_DefaultValues_AllNull() {
        ReviewVO emptyReview = new ReviewVO();

        // 모든 필드가 null인지 확인
        assertNull(emptyReview.getReviewId());
        assertNull(emptyReview.getUsersId());
        assertNull(emptyReview.getStoreId());
        assertNull(emptyReview.getReviewStar());
        assertNull(emptyReview.getReviewTitle());
        assertNull(emptyReview.getReviewContent());
        assertNull(emptyReview.getReviewDate());
        assertNull(emptyReview.getReviewStatus());
    }
} 