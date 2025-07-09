package kr.co.solfood.user.review;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;
import java.util.Map;

@Mapper
public interface ReviewMapper {
    
    // === 전체 리뷰 관련 메서드 ===
    
    // 전체 리뷰 목록 조회 (최신순)
    List<ReviewVO> selectReviewList();
    
    // 전체 리뷰 평균 별점 조회
    Double selectAverageStar();
    
    // 전체 리뷰 개수 조회
    Integer selectTotalCount();
    
    // 전체 리뷰의 별점별 개수 조회
    Map<String, Object> selectStarCounts();
    
    // === 개별 리뷰 CRUD ===
    
    // 리뷰 상세 조회
    ReviewVO selectReviewById(Integer reviewId);
    
    // 리뷰 등록
    int insertReview(ReviewVO review);
    
    // 리뷰 수정
    int updateReview(ReviewVO review);
    
    // 리뷰 삭제
    int deleteReview(Integer reviewId);
    
    // === 검색 관련 메서드 ===
    
    // 가게 ID로 리뷰 목록 조회
    List<ReviewVO> selectReviewsByStoreId(Integer storeId);
    
    // 음식점 이름으로 리뷰 검색 (DB에서 직접 검색)
    List<ReviewVO> selectReviewsByRestaurant(String restaurantName);
    
    // 리뷰 제목으로 검색 (DB에서 직접 LIKE 검색)
    List<ReviewVO> selectReviewsByTitle(String reviewTitle);
    
    // === 가게별 통계 메서드 ===
    
    // 특정 가게의 평균 별점 조회
    Double selectAverageStarByStoreId(Integer storeId);
    
    // 특정 가게의 총 리뷰 개수 조회
    Integer selectTotalCountByStoreId(Integer storeId);
    
    // 특정 가게의 별점별 개수 조회
    Map<String, Object> selectStarCountsByStoreId(Integer storeId);
    
    // === 내 리뷰 관리 메서드 ===
    
    // 내 리뷰 목록 조회 (필터링, 정렬, 페이징)
    List<ReviewVO> selectMyReviews(
        @Param("usersId") Integer usersId, 
        @Param("filter") String filter, 
        @Param("sort") String sort, 
        @Param("offset") int offset, 
        @Param("pageSize") int pageSize
    );
    
    // 내 리뷰 총 개수 조회
    Integer selectMyReviewCount(Integer usersId);
    
    // 내 리뷰 평균 별점 조회
    Double selectMyReviewAvgRating(Integer usersId);
    
    // 내 리뷰 이번 달 개수 조회
    Integer selectMyReviewCountThisMonth(Integer usersId);
}
