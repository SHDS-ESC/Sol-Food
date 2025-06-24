package kr.co.solfood.user.review;

import kr.co.solfood.user.menu.MenuVO;
import kr.co.solfood.user.menu.MenuService;
import kr.co.solfood.user.store.StoreVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import properties.KakaoProperties;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class ReviewController {
    
    @Autowired
    private ReviewService reviewService;
    
    @Autowired
    private MenuService menuService;
    
    @Autowired
    private KakaoProperties kakaoProperties;
    
    // 한 가게의 리뷰 목록 페이지 (storeId로 필터)
    @GetMapping("/list")
    public String reviewList(@RequestParam(required = false) Integer storeId, Model model) {
        if (storeId == null) {
            return "redirect:/user/list?storeId=1";
        }
        
        // 가게 정보 조회
        StoreVO store = reviewService.getStoreById(storeId);
        if (store == null) {
            // 가게 정보가 없으면 1번 가게로 리다이렉트
            return "redirect:/user/list?storeId=1";
        }
        
        // 해당 가게의 리뷰 목록 조회
        List<ReviewVO> reviewList = reviewService.getReviewsByStoreId(storeId);
        model.addAttribute("reviewList", reviewList);
        model.addAttribute("storeId", storeId);
        model.addAttribute("store", store);
        
        // 카카오맵 JavaScript API 키 추가
        model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
        
        // 해당 가게의 평균 별점 및 통계 조회
        Double avgStar = reviewService.getAverageStarByStoreId(storeId);
        Integer totalCount = reviewService.getTotalCountByStoreId(storeId);
        Map<String, Object> starCountsMap = reviewService.getStarCountsByStoreId(storeId);
        
        // 별점별 개수를 배열로 변환 (5점부터 1점까지)
        long[] starCounts = new long[5];
        if (starCountsMap != null) {
            starCounts[4] = ((Number) starCountsMap.get("star5")).longValue(); // 5점
            starCounts[3] = ((Number) starCountsMap.get("star4")).longValue(); // 4점
            starCounts[2] = ((Number) starCountsMap.get("star3")).longValue(); // 3점
            starCounts[1] = ((Number) starCountsMap.get("star2")).longValue(); // 2점
            starCounts[0] = ((Number) starCountsMap.get("star1")).longValue(); // 1점
        }
        
        model.addAttribute("avgStar", avgStar != null ? avgStar : 0.0);
        model.addAttribute("totalCount", totalCount != null ? totalCount : 0);
        model.addAttribute("starCounts", starCounts);
        
        // 해당 가게의 메뉴 목록 조회
        List<MenuVO> menuList = menuService.getMenusByStoreId(storeId);
        model.addAttribute("menuList", menuList);
        
        return "review/reviewList";
    }
    
    // 리뷰 작성 페이지
    @GetMapping("/write")
    public String reviewWriteForm(Model model) {
        model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
        return "review/reviewWrite";
    }
    
    // 리뷰 작성 처리
    @PostMapping("/write")
    public String reviewWrite(@ModelAttribute ReviewVO review) {
        try {
            reviewService.registerReview(review);
            System.out.println("리뷰 등록 성공: " + review.getReviewTitle());
            return "redirect:/user/list?storeId=" + review.getStoreId();
        } catch (Exception e) {
            System.out.println("리뷰 등록 실패: " + e.getMessage());
            e.printStackTrace();
            return "error";
        }
    }
    
    // 리뷰 상세 보기
    @GetMapping("/detail/{reviewId}")
    public String reviewDetail(@PathVariable Integer reviewId, Model model) {
        try {
            ReviewVO review = reviewService.getReviewById(reviewId);
            model.addAttribute("review", review);
            model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
            return "review/reviewDetail";
        } catch (Exception e) {
            System.out.println("리뷰 상세 조회 실패: " + e.getMessage());
            e.printStackTrace();
            return "error";
        }
    }
    
    // 리뷰 수정 페이지
    @GetMapping("/edit/{reviewId}")
    public String reviewEditForm(@PathVariable Integer reviewId, Model model) {
        try {
            ReviewVO review = reviewService.getReviewById(reviewId);
            model.addAttribute("review", review);
            model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
            return "review/reviewEdit";
        } catch (Exception e) {
            System.out.println("리뷰 수정 페이지 조회 실패: " + e.getMessage());
            e.printStackTrace();
            return "error";
        }
    }
    
    // 리뷰 수정 처리
    @PostMapping("/edit")
    public String reviewEdit(@ModelAttribute ReviewVO review) {
        try {
            reviewService.updateReview(review);
            return "redirect:/user/detail/" + review.getReviewId();
        } catch (Exception e) {
            System.out.println("리뷰 수정 실패: " + e.getMessage());
            e.printStackTrace();
            return "error";
        }
    }
    
    // 리뷰 삭제
    @PostMapping("/delete/{reviewId}")
    public String reviewDelete(@PathVariable Integer reviewId) {
        try {
            // 삭제 전에 해당 리뷰의 storeId를 조회
            ReviewVO review = reviewService.getReviewById(reviewId);
            Integer storeId = review != null ? review.getStoreId() : 1;
            
            reviewService.deleteReview(reviewId);
            return "redirect:/user/list?storeId=" + storeId;
        } catch (Exception e) {
            System.out.println("리뷰 삭제 실패: " + e.getMessage());
            e.printStackTrace();
            return "error";
        }
    }
    
    // 식당명으로 리뷰 검색 (임시: 리뷰 제목으로 검색)
    @GetMapping("/search")
    public String reviewSearch(@RequestParam String reviewTitle, Model model) {
        try {
            // 예시: 제목으로 검색 (실제 구현에 맞게 수정 필요)
            List<ReviewVO> reviewList = reviewService.getReviewsByTitle(reviewTitle);
            model.addAttribute("reviewList", reviewList);
            model.addAttribute("searchKeyword", reviewTitle);
            model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
            return "review/reviewList";
        } catch (Exception e) {
            System.out.println("리뷰 검색 실패: " + e.getMessage());
            e.printStackTrace();
            return "error";
        }
    }
    
    // 리뷰 메인 페이지
    @GetMapping("/main")
    public String reviewMain(Model model) {
        model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
        return "review/reviewMain";
    }
    

}
