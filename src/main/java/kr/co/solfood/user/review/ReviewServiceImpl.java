package kr.co.solfood.user.review;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.solfood.user.store.StoreMapper;
import kr.co.solfood.user.store.StoreVO;

import java.util.List;
import java.util.Map;

import static kr.co.solfood.user.review.ReviewConstants.*;
import static kr.co.solfood.user.review.ReviewValidator.*;

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
        validateReviewId(reviewId);
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
        validateReviewId(review.getReviewId());
        return reviewMapper.updateReview(review) > 0;
    }
    
    @Override
    @Transactional
    public boolean deleteReview(Integer reviewId) {
        validateReviewId(reviewId);
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
}
