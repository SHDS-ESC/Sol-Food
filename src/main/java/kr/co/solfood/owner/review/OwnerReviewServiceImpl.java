package kr.co.solfood.owner.review;

import kr.co.solfood.user.review.ReviewService;
import kr.co.solfood.user.review.ReviewVO;
import kr.co.solfood.owner.store.OwnerStoreService;
import kr.co.solfood.owner.store.OwnerStoreVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class OwnerReviewServiceImpl implements OwnerReviewService {

    @Autowired
    private ReviewService reviewService;
    @Autowired
    private OwnerStoreService ownerStoreService;

    @Override
    public List<ReviewVO> getReviewsByStoreId(Integer storeId) {
        return reviewService.getReviewsByStoreId(storeId);
    }

    @Override
    public ReviewVO getReviewById(Integer reviewId) {
        return reviewService.getReviewById(reviewId);
    }

    @Override
    public boolean updateReviewResponse(Integer reviewId, String response) {
        ReviewVO review = reviewService.getReviewById(reviewId);
        if (review == null) return false;
        review.setReviewResponse(response);
        return reviewService.updateReview(review);
    }

    @Override
    public boolean deleteReviewResponse(Integer reviewId) {
        ReviewVO review = reviewService.getReviewById(reviewId);
        if (review == null) return false;
        review.setReviewResponse("");
        return reviewService.updateReview(review);
    }

    @Override
    public Double getAverageStarByStoreId(Integer storeId) {
        return reviewService.getAverageStarByStoreId(storeId);
    }

    @Override
    public Integer getTotalCountByStoreId(Integer storeId) {
        return reviewService.getTotalCountByStoreId(storeId);
    }

    @Override
    public Map<String, Object> getStarCountsByStoreId(Integer storeId) {
        return reviewService.getStarCountsByStoreId(storeId);
    }

    @Override
    public boolean hasPermission(Integer reviewId, Integer ownerId) {
        ReviewVO review = reviewService.getReviewById(reviewId);
        if (review == null) return false;
        OwnerStoreVO ownerStore = ownerStoreService.getOwnerStore(ownerId);
        return ownerStore != null && ownerStore.getStoreId() == review.getStoreId();
    }
} 