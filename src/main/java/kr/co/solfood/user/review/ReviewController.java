package kr.co.solfood.user.review;

import kr.co.solfood.common.constants.UrlConstants;
import kr.co.solfood.user.login.UserVO;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import properties.KakaoProperties;

import javax.servlet.http.HttpSession;

import static kr.co.solfood.user.review.ReviewConstants.*;

@Controller
@RequestMapping(UrlConstants.User.REVIEW_BASE)
public class ReviewController {
    
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
    public String reviewWrite(
            @RequestParam(required = false) Integer storeId,
            @RequestParam(required = false) Integer reviewStar,
            @RequestParam(required = false) String reviewTitle,
            @RequestParam(required = false) String reviewContent,
            @RequestParam(required = false) MultipartFile reviewImage,
            RedirectAttributes redirectAttributes, 
            HttpSession session) {
        try {
            // 세션에서 사용자 정보 가져오기
            UserVO loginUser = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
            if (loginUser == null) {
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, "로그인이 필요합니다.");
                return "redirect:" + UrlConstants.User.LOGIN_PAGE;
            }
            
            // ReviewVO 객체 생성
            ReviewVO review = new ReviewVO();
            review.setUsersId((int) loginUser.getUsersId());
            review.setStoreId(storeId);
            review.setReviewStar(reviewStar);
            review.setReviewTitle(reviewTitle);
            review.setReviewContent(reviewContent);
            review.setUsersPaymentId(0); // 기본값 설정
            review.setReviewCommentId(0); // 기본값 설정
            
            // 가게 ID 검증
            if (review.getStoreId() == null) {
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, "가게 ID를 입력해주세요.");
                return "redirect:" + UrlConstants.User.REVIEW_WRITE;
            }
            
            // 별점 검증
            if (review.getReviewStar() == null) {
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, "별점을 선택해주세요.");
                return "redirect:" + UrlConstants.User.REVIEW_WRITE;
            }
            
            if (!reviewService.isValidStarRating(review.getReviewStar())) {
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_INVALID_STAR_RATING);
                return "redirect:" + UrlConstants.User.REVIEW_WRITE;
            }
            
            // 내용 검증
            if (review.getReviewContent() == null || review.getReviewContent().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, "리뷰 내용을 입력해주세요.");
                return "redirect:" + UrlConstants.User.REVIEW_WRITE;
            }
            
            reviewService.registerReview(review);
            redirectAttributes.addFlashAttribute(UrlConstants.Model.SUCCESS, MSG_REVIEW_REGISTER_SUCCESS);
            
            // 해당 가게의 상세페이지로 리다이렉트
            return "redirect:" + UrlConstants.User.STORE_DETAIL + "?storeId=" + review.getStoreId();
            
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, e.getMessage());
            return "redirect:" + UrlConstants.User.REVIEW_WRITE;
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_REVIEW_REGISTER_ERROR);
            return "redirect:" + UrlConstants.User.REVIEW_WRITE;
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
            
            return "user/review/edit";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", MSG_REVIEW_LOAD_ERROR);
            return "redirect:" + UrlConstants.User.STORE_LIST;
        }
    }
    
    // 리뷰 수정 처리
    @PostMapping("/edit")
    public String reviewEdit(@ModelAttribute ReviewVO review, RedirectAttributes redirectAttributes) {
        try {
            reviewService.updateReview(review);
            redirectAttributes.addFlashAttribute("success", MSG_REVIEW_UPDATE_SUCCESS);
            
            return "redirect:" + UrlConstants.User.STORE_DETAIL + "?storeId=" + review.getStoreId();
            
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:" + UrlConstants.User.REVIEW_EDIT + "/" + review.getReviewId();
            
        } catch (Exception e) {
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
            
            redirectAttributes.addFlashAttribute("success", MSG_REVIEW_DELETE_SUCCESS);
            
            return "redirect:" + UrlConstants.User.STORE_DETAIL + "?storeId=" + storeId;
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", MSG_REVIEW_DELETE_ERROR);
            return "redirect:" + UrlConstants.User.STORE_LIST;
        }
    }
}
