package kr.co.solfood.user.review;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.solfood.user.store.MenuMapper;
import kr.co.solfood.user.store.MenuVO;
import kr.co.solfood.user.store.StoreMapper;
import kr.co.solfood.user.store.StoreVO;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional
public class ReviewServiceImpl implements ReviewService {
    
    @Autowired
    private ReviewMapper reviewMapper;
    
    @Autowired
    private StoreMapper storeMapper;
    
    @Autowired
    private MenuMapper menuMapper;
    
    @Override
    public List<ReviewVO> getReviewList() {
        return reviewMapper.selectReviewList();
    }
    
    @Override
    public Double getAverageStar() {
        return reviewMapper.selectAverageStar();
    }
    
    @Override
    public Integer getTotalCount() {
        return reviewMapper.selectTotalCount();
    }
    
    @Override
    public Map<String, Object> getStarCounts() {
        return reviewMapper.selectStarCounts();
    }
    
    @Override
    public ReviewVO getReviewById(Integer reviewId) {
        return reviewMapper.selectReviewById(reviewId);
    }
    
    @Override
    public boolean registerReview(ReviewVO review) {
        return reviewMapper.insertReview(review) > 0;
    }
    
    @Override
    public boolean updateReview(ReviewVO review) {
        return reviewMapper.updateReview(review) > 0;
    }
    
    @Override
    public boolean deleteReview(Integer reviewId) {
        return reviewMapper.deleteReview(reviewId) > 0;
    }
    
    @Override
    public List<ReviewVO> getReviewsByRestaurant(String restaurantName) {
        return reviewMapper.selectReviewsByRestaurant(restaurantName);
    }
    
    // (임시) 제목으로 검색: 전체 목록에서 필터링
    @Override
    public List<ReviewVO> getReviewsByTitle(String reviewTitle) {
        return reviewMapper.selectReviewList().stream()
                .filter(r -> r.getReviewTitle() != null && r.getReviewTitle().contains(reviewTitle))
                .collect(Collectors.toList());
    }
    
    @Override
    public List<ReviewVO> getReviewsByStoreId(Integer storeId) {
        return reviewMapper.selectReviewsByStoreId(storeId);
    }
    
    @Override
    public StoreVO getStoreById(Integer storeId) {
        return storeMapper.getStoreById(storeId);
    }
    
    @Override
    public Double getAverageStarByStoreId(Integer storeId) {
        return reviewMapper.selectAverageStarByStoreId(storeId);
    }
    
    @Override
    public Integer getTotalCountByStoreId(Integer storeId) {
        return reviewMapper.selectTotalCountByStoreId(storeId);
    }
    
    @Override
    public Map<String, Object> getStarCountsByStoreId(Integer storeId) {
        return reviewMapper.selectStarCountsByStoreId(storeId);
    }
    
    @Override
    public List<MenuVO> getMenusByStoreId(Integer storeId) {
        return menuMapper.getMenusByStoreId(storeId);
    }
}
