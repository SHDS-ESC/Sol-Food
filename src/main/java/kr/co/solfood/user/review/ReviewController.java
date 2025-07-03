package kr.co.solfood.user.review;

import kr.co.solfood.common.constants.UrlConstants;
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

import static kr.co.solfood.user.review.ReviewConstants.*;

@Controller
@RequestMapping(UrlConstants.User.REVIEW_BASE)
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
            model.addAttribute(UrlConstants.Param.STORE_ID, storeId);
        }
        model.addAttribute(UrlConstants.Model.KAKAO_JS_KEY, kakaoProperties.getJsApiKey());
        return UrlConstants.View.USER_REVIEW_WRITE;
    }
    
    // 리뷰 작성 처리
    @PostMapping("/write")
    public String reviewWrite(@ModelAttribute ReviewVO review, RedirectAttributes redirectAttributes) {
        try {
            if (!reviewService.isValidStarRating(review.getReviewStar())) {
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_INVALID_STAR_RATING);
                return "redirect:" + UrlConstants.User.REVIEW_WRITE + "?" + UrlConstants.Param.STORE_ID + "=" + review.getStoreId();
            }
            
            reviewService.registerReview(review);
            logger.info("리뷰 등록 성공. 제목: {}, 가게ID: {}", review.getReviewTitle(), review.getStoreId());
            redirectAttributes.addFlashAttribute(UrlConstants.Model.SUCCESS, MSG_REVIEW_REGISTER_SUCCESS);
            
            return "redirect:" + UrlConstants.User.STORE_DETAIL + "?" + UrlConstants.Param.STORE_ID + "=" + review.getStoreId();
            
        } catch (IllegalArgumentException e) {
            logger.warn("리뷰 등록 유효성 검사 실패: {}", e.getMessage());
            redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, e.getMessage());
            return "redirect:" + UrlConstants.User.REVIEW_WRITE + "?" + UrlConstants.Param.STORE_ID + "=" + review.getStoreId();
            
        } catch (Exception e) {
            logger.error("리뷰 등록 중 오류 발생", e);
            redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_REVIEW_REGISTER_ERROR);
            return "redirect:" + UrlConstants.User.REVIEW_WRITE + "?" + UrlConstants.Param.STORE_ID + "=" + review.getStoreId();
        }
    }
    
    // 리뷰 수정 페이지
    @GetMapping("/edit/{reviewId}")
    public String reviewEditForm(@PathVariable Integer reviewId, Model model, RedirectAttributes redirectAttributes) {
        try {
            ReviewVO review = reviewService.getReviewById(reviewId);
            if (review == null) {
                redirectAttributes.addFlashAttribute("error", MSG_REVIEW_NOT_FOUND);
                return "redirect:" + UrlConstants.User.STORE_LIST;
            }
            
            model.addAttribute("review", review);
            model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
            
            logger.info("리뷰 수정 페이지 조회. reviewId: {}", reviewId);
            return "user/review/edit";
            
        } catch (Exception e) {
            logger.error("리뷰 수정 페이지 조회 중 오류 발생. reviewId: {}", reviewId, e);
            redirectAttributes.addFlashAttribute("error", MSG_REVIEW_LOAD_ERROR);
            return "redirect:" + UrlConstants.User.STORE_LIST;
        }
    }
    
    // 리뷰 수정 처리
    @PostMapping("/edit")
    public String reviewEdit(@ModelAttribute ReviewVO review, RedirectAttributes redirectAttributes) {
        try {
            reviewService.updateReview(review);
            logger.info("리뷰 수정 성공. reviewId: {}", review.getReviewId());
            redirectAttributes.addFlashAttribute("success", MSG_REVIEW_UPDATE_SUCCESS);
            
            return "redirect:" + UrlConstants.User.STORE_DETAIL + "?storeId=" + review.getStoreId();
            
        } catch (IllegalArgumentException e) {
            logger.warn("리뷰 수정 유효성 검사 실패: {}", e.getMessage());
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:" + UrlConstants.User.REVIEW_EDIT + "/" + review.getReviewId();
            
        } catch (Exception e) {
            logger.error("리뷰 수정 중 오류 발생. reviewId: {}", review.getReviewId(), e);
            redirectAttributes.addFlashAttribute("error", MSG_REVIEW_UPDATE_ERROR);
            return "redirect:" + UrlConstants.User.REVIEW_EDIT + "/" + review.getReviewId();
        }
    }
    
    // 리뷰 삭제
    @PostMapping("/delete/{reviewId}")
    public String reviewDelete(@PathVariable Integer reviewId, RedirectAttributes redirectAttributes) {
        try {
            // 삭제 전에 해당 리뷰의 storeId를 조회
            ReviewVO review = reviewService.getReviewById(reviewId);
            
            if (review == null) {
                redirectAttributes.addFlashAttribute("error", MSG_REVIEW_NOT_FOUND);
                return "redirect:" + UrlConstants.User.STORE_LIST;
            }
            
            Integer storeId = review.getStoreId();
            reviewService.deleteReview(reviewId);
            
            logger.info("리뷰 삭제 성공. reviewId: {}", reviewId);
            redirectAttributes.addFlashAttribute("success", MSG_REVIEW_DELETE_SUCCESS);
            
            return "redirect:" + UrlConstants.User.STORE_DETAIL + "?storeId=" + storeId;
            
        } catch (Exception e) {
            logger.error("리뷰 삭제 중 오류 발생. reviewId: {}", reviewId, e);
            redirectAttributes.addFlashAttribute("error", MSG_REVIEW_DELETE_ERROR);
            return "redirect:" + UrlConstants.User.STORE_LIST;
        }
    }
}
