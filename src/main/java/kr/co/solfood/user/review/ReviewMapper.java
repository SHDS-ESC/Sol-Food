package kr.co.solfood.user.review;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface ReviewMapper {
    // 리뷰 목록 조회
    List<ReviewVO> selectReviewList();
    
    // 평균 별점 조회
    Double selectAverageStar();
    
    // 총 리뷰 개수 조회
    Integer selectTotalCount();
    
    // 별점별 개수 조회
    Map<String, Object> selectStarCounts();
    
    // 리뷰 상세 조회
    ReviewVO selectReviewById(Integer reviewId);
    
    // 리뷰 등록
    int insertReview(ReviewVO review);
    
    // 리뷰 수정
    int updateReview(ReviewVO review);
    
    // 리뷰 삭제
    int deleteReview(Integer reviewId);
    
    // 식당명으로 리뷰 검색
    List<ReviewVO> selectReviewsByRestaurant(String restaurantName);
    
    // 가게 ID로 리뷰 검색
    List<ReviewVO> selectReviewsByStoreId(Integer storeId);
    
    // 특정 가게의 평균 별점 조회
    Double selectAverageStarByStoreId(Integer storeId);
    
    // 특정 가게의 총 리뷰 개수 조회
    Integer selectTotalCountByStoreId(Integer storeId);
    
    // 특정 가게의 별점별 개수 조회
    Map<String, Object> selectStarCountsByStoreId(Integer storeId);
}
