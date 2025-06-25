package kr.co.solfood.user.review;

import kr.co.solfood.user.store.StoreVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import properties.KakaoProperties;

@Controller
@RequestMapping("/user/review")
public class ReviewController {
    
    private static final Logger logger = LoggerFactory.getLogger(ReviewController.class);
    
    @Autowired
    private ReviewService reviewService;
    
    @Autowired
    private KakaoProperties kakaoProperties;
    
    // 리뷰 작성 페이지
    @GetMapping("/write")
    public String reviewWriteForm(@RequestParam(required = false) Integer storeId, Model model) {
        if (storeId != null) {
            model.addAttribute("storeId", storeId);
        }
        model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
        return "user/review/write";
    }
    
    // 리뷰 작성 처리
    @PostMapping("/write")
    public String reviewWrite(@ModelAttribute ReviewVO review, RedirectAttributes redirectAttributes) {
        try {
            if (!reviewService.isValidStarRating(review.getReviewStar())) {
                redirectAttributes.addFlashAttribute("error", "올바른 별점을 선택해주세요.");
                return "redirect:/user/review/write?storeId=" + review.getStoreId();
            }
            
            reviewService.registerReview(review);
            logger.info("리뷰 등록 성공. 제목: {}, 가게ID: {}", review.getReviewTitle(), review.getStoreId());
            redirectAttributes.addFlashAttribute("success", "리뷰가 성공적으로 등록되었습니다.");
            
            return "redirect:/user/store/detail?storeId=" + review.getStoreId();
            
        } catch (IllegalArgumentException e) {
            logger.warn("리뷰 등록 유효성 검사 실패: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/user/review/write?storeId=" + review.getStoreId();
            
        } catch (Exception e) {
            logger.error("리뷰 등록 중 오류 발생", e);
            redirectAttributes.addFlashAttribute("error", "리뷰 등록 중 오류가 발생했습니다.");
            return "redirect:/user/review/write?storeId=" + review.getStoreId();
        }
    }
    
    // 리뷰 수정 페이지
    @GetMapping("/edit/{reviewId}")
    public String reviewEditForm(@PathVariable Integer reviewId, Model model, RedirectAttributes redirectAttributes) {
        try {
            ReviewVO review = reviewService.getReviewById(reviewId);
            if (review == null) {
                redirectAttributes.addFlashAttribute("error", "존재하지 않는 리뷰입니다.");
                return "redirect:/user/store/list";
            }
            
            model.addAttribute("review", review);
            model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
            
            logger.info("리뷰 수정 페이지 조회. reviewId: {}", reviewId);
            return "user/review/edit";
            
        } catch (Exception e) {
            logger.error("리뷰 수정 페이지 조회 중 오류 발생. reviewId: {}", reviewId, e);
            redirectAttributes.addFlashAttribute("error", "리뷰 정보를 불러오는 중 오류가 발생했습니다.");
            return "redirect:/user/store/list";
        }
    }
    
    // 리뷰 수정 처리
    @PostMapping("/edit")
    public String reviewEdit(@ModelAttribute ReviewVO review, RedirectAttributes redirectAttributes) {
        try {
            reviewService.updateReview(review);
            logger.info("리뷰 수정 성공. reviewId: {}", review.getReviewId());
            redirectAttributes.addFlashAttribute("success", "리뷰가 성공적으로 수정되었습니다.");
            
            return "redirect:/user/store/detail?storeId=" + review.getStoreId();
            
        } catch (IllegalArgumentException e) {
            logger.warn("리뷰 수정 유효성 검사 실패: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/user/review/edit/" + review.getReviewId();
            
        } catch (Exception e) {
            logger.error("리뷰 수정 중 오류 발생. reviewId: {}", review.getReviewId(), e);
            redirectAttributes.addFlashAttribute("error", "리뷰 수정 중 오류가 발생했습니다.");
            return "redirect:/user/review/edit/" + review.getReviewId();
        }
    }
    
    // 리뷰 삭제
    @PostMapping("/delete/{reviewId}")
    public String reviewDelete(@PathVariable Integer reviewId, RedirectAttributes redirectAttributes) {
        try {
            // 삭제 전에 해당 리뷰의 storeId를 조회
            ReviewVO review = reviewService.getReviewById(reviewId);
            
            if (review == null) {
                redirectAttributes.addFlashAttribute("error", "존재하지 않는 리뷰입니다.");
                return "redirect:/user/store/list";
            }
            
            Integer storeId = review.getStoreId();
            reviewService.deleteReview(reviewId);
            
            logger.info("리뷰 삭제 성공. reviewId: {}", reviewId);
            redirectAttributes.addFlashAttribute("success", "리뷰가 성공적으로 삭제되었습니다.");
            
            return "redirect:/user/store/detail?storeId=" + storeId;
            
        } catch (Exception e) {
            logger.error("리뷰 삭제 중 오류 발생. reviewId: {}", reviewId, e);
            redirectAttributes.addFlashAttribute("error", "리뷰 삭제 중 오류가 발생했습니다.");
            return "redirect:/user/store/list";
        }
    }
}
