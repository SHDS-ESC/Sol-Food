package kr.co.solfood.user.review;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.solfood.user.store.StoreMapper;
import kr.co.solfood.user.store.StoreVO;

import java.util.List;
import java.util.Map;

@Service
public class ReviewServiceImpl implements ReviewService {
    
    @Autowired
    private ReviewMapper reviewMapper;
    
    @Autowired
    private StoreMapper storeMapper;
    
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
        if (reviewId == null) {
            throw new IllegalArgumentException("리뷰 ID가 필요합니다.");
        }
        return reviewMapper.selectReviewById(reviewId);
    }
    
    @Override
    @Transactional
    public boolean registerReview(ReviewVO review) {
        validateReview(review);
        return reviewMapper.insertReview(review) > 0;
    }
    
    @Override
    @Transactional
    public boolean updateReview(ReviewVO review) {
        validateReview(review);
        if (review.getReviewId() == null) {
            throw new IllegalArgumentException("리뷰 ID가 필요합니다.");
        }
        return reviewMapper.updateReview(review) > 0;
    }
    
    @Override
    @Transactional
    public boolean deleteReview(Integer reviewId) {
        if (reviewId == null) {
            throw new IllegalArgumentException("리뷰 ID가 필요합니다.");
        }
        return reviewMapper.deleteReview(reviewId) > 0;
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
        if (storeId == null) {
            throw new IllegalArgumentException("가게 ID가 필요합니다.");
        }
        return reviewMapper.selectReviewsByStoreId(storeId);
    }
    
    @Override
    @Transactional(readOnly = true)
    public StoreVO getStoreById(Integer storeId) {
        if (storeId == null) {
            throw new IllegalArgumentException("가게 ID가 필요합니다.");
        }
        return storeMapper.getStoreById(storeId);
    }
    
    @Override
    @Transactional(readOnly = true)
    public Double getAverageStarByStoreId(Integer storeId) {
        if (storeId == null) {
            throw new IllegalArgumentException("가게 ID가 필요합니다.");
        }
        Double avg = reviewMapper.selectAverageStarByStoreId(storeId);
        return avg != null ? avg : 0.0;
    }
    
    @Override
    @Transactional(readOnly = true)
    public Integer getTotalCountByStoreId(Integer storeId) {
        if (storeId == null) {
            throw new IllegalArgumentException("가게 ID가 필요합니다.");
        }
        Integer count = reviewMapper.selectTotalCountByStoreId(storeId);
        return count != null ? count : 0;
    }
    
    @Override
    @Transactional(readOnly = true)
    public Map<String, Object> getStarCountsByStoreId(Integer storeId) {
        if (storeId == null) {
            throw new IllegalArgumentException("가게 ID가 필요합니다.");
        }
        return reviewMapper.selectStarCountsByStoreId(storeId);
    }
    
    @Override
    public boolean isValidStarRating(Integer star) {
        return star != null && star >= MIN_STAR_RATING && star <= MAX_STAR_RATING;
    }
    
    /**
     * 리뷰 유효성 검증 private 메서드
     */
    private void validateReview(ReviewVO review) {
        if (review == null) {
            throw new IllegalArgumentException("리뷰 정보가 없습니다.");
        }
        
        if (review.getStoreId() == null) {
            throw new IllegalArgumentException("가게 ID가 필요합니다.");
        }
        
        if (review.getUsersId() == null) {
            throw new IllegalArgumentException("사용자 ID가 필요합니다.");
        }
        
        if (!isValidStarRating(review.getReviewStar())) {
            throw new IllegalArgumentException("별점은 " + MIN_STAR_RATING + "점에서 " + MAX_STAR_RATING + "점 사이여야 합니다.");
        }
        
        if (review.getReviewContent() == null || review.getReviewContent().trim().isEmpty()) {
            throw new IllegalArgumentException("리뷰 내용은 비어있을 수 없습니다.");
        }
        
        // 리뷰 내용 길이 제한 (예: 1000자)
        if (review.getReviewContent().length() > 1000) {
            throw new IllegalArgumentException("리뷰 내용은 1000자를 초과할 수 없습니다.");
        }
    }
}
