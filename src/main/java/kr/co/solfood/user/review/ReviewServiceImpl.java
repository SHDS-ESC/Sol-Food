package kr.co.solfood.user.review;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.extern.slf4j.Slf4j;

import kr.co.solfood.user.store.StoreMapper;
import kr.co.solfood.user.store.StoreService;
import kr.co.solfood.user.store.StoreVO;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

import static kr.co.solfood.user.review.ReviewConstants.*;
import static kr.co.solfood.user.review.ReviewValidator.*;

@Slf4j
@Service
public class ReviewServiceImpl implements ReviewService {
    
    @Autowired
    private ReviewMapper reviewMapper;
    
    @Autowired
    private StoreMapper storeMapper;
    
    @Autowired
    private StoreService storeService;
    
    @Override
    @Transactional(readOnly = true)
    public List<ReviewVO> getReviewList() {
        return reviewMapper.selectReviewList();
    }
    
    @Override
    @Transactional(readOnly = true)
    public Double getAverageStar() {
        Double avg = reviewMapper.selectAverageStar();
        return avg != null ? avg : 0.0;
    }
    
    @Override
    @Transactional(readOnly = true)
    public Integer getTotalCount() {
        Integer count = reviewMapper.selectTotalCount();
        return count != null ? count : 0;
    }
    
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getStarCounts() {
        return reviewMapper.selectStarCounts();
    }
    
    @Override
    @Transactional(readOnly = true)
    public ReviewVO getReviewById(Integer reviewId) {
        validateReviewId(reviewId);
        return reviewMapper.selectReviewById(reviewId);
    }
    
    @Override
    @Transactional
    public boolean registerReview(ReviewVO review) {
        try {
            validateReview(review);
            
            int result = reviewMapper.insertReview(review);
            
            if (result > 0) {
                // 리뷰 등록 후 해당 가게의 평균 별점 갱신
                updateStoreAvgStar(review.getStoreId());
            }
            
            return result > 0;
        } catch (Exception e) {
            throw e;
        }
    }
    
    @Override
    @Transactional
    public boolean updateReview(ReviewVO review) {
        validateReview(review);
        validateReviewId(review.getReviewId());
        
        // 기존 리뷰 정보 조회 (가게 ID 확인용)
        ReviewVO existingReview = reviewMapper.selectReviewById(review.getReviewId());
        if (existingReview == null) {
            return false;
        }
        
        int result = reviewMapper.updateReview(review);
        
        if (result > 0) {
            // 리뷰 수정 후 해당 가게의 평균 별점 갱신
            updateStoreAvgStar(existingReview.getStoreId());
        }
        
        return result > 0;
    }
    
    @Override
    @Transactional
    public boolean deleteReview(Integer reviewId) {
        validateReviewId(reviewId);
        
        // 삭제 전 리뷰 정보 조회 (가게 ID 확인용)
        ReviewVO existingReview = reviewMapper.selectReviewById(reviewId);
        if (existingReview == null) {
            return false;
        }
        
        int result = reviewMapper.deleteReview(reviewId);
        
        if (result > 0) {
            // 리뷰 삭제 후 해당 가게의 평균 별점 갱신
            updateStoreAvgStar(existingReview.getStoreId());
        }
        
        return result > 0;
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ReviewVO> getReviewsByRestaurant(String restaurantName) {
        if (restaurantName == null || restaurantName.trim().isEmpty()) {
            throw new IllegalArgumentException("음식점 이름은 비어있을 수 없습니다.");
        }
        return reviewMapper.selectReviewsByRestaurant(restaurantName.trim());
    }
    
    @Override
    @Transactional(readOnly = true)
    public List<ReviewVO> getReviewsByStoreId(Integer storeId) {
        validateStoreId(storeId);
        return reviewMapper.selectReviewsByStoreId(storeId);
    }
    
    @Override
    @Transactional(readOnly = true)
    public StoreVO getStoreById(Integer storeId) {
        validateStoreId(storeId);
        return storeMapper.getStoreById(storeId);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Double getAverageStarByStoreId(Integer storeId) {
        validateStoreId(storeId);
        Double avg = reviewMapper.selectAverageStarByStoreId(storeId);
        return avg != null ? avg : 0.0;
    }
    
    @Override
    @Transactional(readOnly = true)
    public Integer getTotalCountByStoreId(Integer storeId) {
        validateStoreId(storeId);
        Integer count = reviewMapper.selectTotalCountByStoreId(storeId);
        return count != null ? count : 0;
    }
    
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getStarCountsByStoreId(Integer storeId) {
        validateStoreId(storeId);
        return reviewMapper.selectStarCountsByStoreId(storeId);
    }
    
    @Override
    public boolean isValidStarRating(Integer star) {
        return ReviewValidator.isValidStarRating(star);
    }
    
    // ========================= 별점 평균 자동 갱신 메서드 =========================
    
    /**
     * 해당 가게의 평균 별점을 계산하여 store 테이블의 store_avgstar를 업데이트
     */
    private void updateStoreAvgStar(Integer storeId) {
        try {
            // 해당 가게의 평균 별점 계산
            Double avgStar = getAverageStarByStoreId(storeId);
            
            // store 테이블의 store_avgstar 업데이트
            storeService.updateStoreAvgStar(storeId, avgStar);
            
        } catch (Exception e) {
            // 평균 별점 갱신 실패 시에도 리뷰 등록/수정/삭제는 성공으로 처리
            // (별점 갱신은 부가 기능이므로)
            e.printStackTrace();
        }
    }
    
    @Override
    @Transactional(readOnly = true)
    public Map<Integer, Double> getAverageStarsByStoreIds(List<Integer> storeIds) {
        Map<Integer, Double> result = new HashMap<>();
        
        if (storeIds == null || storeIds.isEmpty()) {
            return result;
        }
        
        try {
            // 각 가게의 평균 별점을 개별적으로 계산
            for (Integer storeId : storeIds) {
                Double avgStar = getAverageStarByStoreId(storeId);
                result.put(storeId, avgStar);
            }
        } catch (Exception e) {
            log.error("여러 가게의 평균 별점 계산 실패", e);
        }
        
        return result;
    }
}
