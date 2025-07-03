package kr.co.solfood.owner.review;

import kr.co.solfood.user.review.ReviewVO;
import java.util.List;
import java.util.Map;

/**
 * 점주 전용 리뷰 관리 서비스 인터페이스
 */
public interface OwnerReviewService {
    
    /**
     * 점주가 관리하는 가게의 리뷰 목록 조회
     * @param storeId 가게 ID
     * @return 리뷰 목록
     */
    List<ReviewVO> getReviewsByStoreId(Integer storeId);
    
    /**
     * 특정 리뷰 상세 조회
     * @param reviewId 리뷰 ID
     * @return 리뷰 정보
     */
    ReviewVO getReviewById(Integer reviewId);
    
    /**
     * 리뷰 답글 작성/수정
     * @param reviewId 리뷰 ID
     * @param response 답글 내용
     * @return 성공 여부
     */
    boolean updateReviewResponse(Integer reviewId, String response);
    
    /**
     * 리뷰 답글 삭제
     * @param reviewId 리뷰 ID
     * @return 성공 여부
     */
    boolean deleteReviewResponse(Integer reviewId);
    
    /**
     * 가게의 평균 별점 조회
     * @param storeId 가게 ID
     * @return 평균 별점
     */
    Double getAverageStarByStoreId(Integer storeId);
    
    /**
     * 가게의 총 리뷰 개수 조회
     * @param storeId 가게 ID
     * @return 총 리뷰 개수
     */
    Integer getTotalCountByStoreId(Integer storeId);
    
    /**
     * 가게의 별점별 개수 조회
     * @param storeId 가게 ID
     * @return 별점별 개수 맵
     */
    Map<String, Object> getStarCountsByStoreId(Integer storeId);
    
    /**
     * 점주가 해당 리뷰에 대한 권한이 있는지 확인
     * @param reviewId 리뷰 ID
     * @param ownerId 점주 ID
     * @return 권한 여부
     */
    boolean hasPermission(Integer reviewId, Integer ownerId);
} 