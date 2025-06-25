package kr.co.solfood.user.review;

import java.util.List;
import java.util.Map;

import kr.co.solfood.user.store.StoreVO;

public interface ReviewService {
    
    // === 상수 정의 ===
    int MIN_STAR_RATING = 1;
    int MAX_STAR_RATING = 5;
    int DEFAULT_PAGE_SIZE = 10;
    
    // 리뷰 목록 조회
    List<ReviewVO> getReviewList();
    
    // 평균 별점 조회
    Double getAverageStar();
    
    // 총 리뷰 개수 조회
    Integer getTotalCount();
    
    // 별점별 개수 조회
    Map<String, Object> getStarCounts();
    
    // 리뷰 상세 조회
    ReviewVO getReviewById(Integer reviewId);
    
    // 리뷰 등록
    boolean registerReview(ReviewVO review);
    
    // 리뷰 수정
    boolean updateReview(ReviewVO review);
    
    // 리뷰 삭제
    boolean deleteReview(Integer reviewId);
    
    // 식당명으로 리뷰 검색 (DB에서 직접 검색)
    List<ReviewVO> getReviewsByRestaurant(String restaurantName);

    // 가게ID로 리뷰 검색
    List<ReviewVO> getReviewsByStoreId(Integer storeId);
    
    // 가게 정보 조회
    StoreVO getStoreById(Integer storeId);
    
    // 특정 가게의 평균 별점 조회
    Double getAverageStarByStoreId(Integer storeId);
    
    // 특정 가게의 총 리뷰 개수 조회
    Integer getTotalCountByStoreId(Integer storeId);
    
    // 특정 가게의 별점별 개수 조회
    Map<String, Object> getStarCountsByStoreId(Integer storeId);
    
    // 별점 유효성 검증
    boolean isValidStarRating(Integer star);
}
