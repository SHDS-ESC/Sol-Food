package kr.co.solfood.user.review;

import kr.co.solfood.common.constants.UrlConstants;
import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.user.store.StoreService;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import properties.KakaoProperties;
import kr.co.solfood.common.s3.S3ServiceV2;
import org.apache.commons.io.FilenameUtils;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static kr.co.solfood.user.review.ReviewConstants.*;

@Controller
@RequestMapping(UrlConstants.User.REVIEW_BASE)
public class ReviewController {
    
    @Autowired
    private ReviewService reviewService;
    
    @Autowired
    private KakaoProperties kakaoProperties;
    
    @Autowired
    private S3ServiceV2 s3ServiceV2;
    
    @Autowired
    private StoreService storeService;
    
    // 리뷰 작성 페이지
    @GetMapping("/write")
    public String reviewWriteForm(@RequestParam(value = "storeId", required = false) Integer storeId, 
                                 @RequestParam(value = "paymentId", required = false) Integer paymentId, 
                                 Model model, RedirectAttributes redirectAttributes) {
        // storeId가 없으면 리뷰 작성 페이지에 접근할 수 없음
        if (storeId == null) {
            redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, "가게 정보가 없습니다.");
            return "redirect:" + UrlConstants.User.STORE_LIST;
        }
        
        model.addAttribute(UrlConstants.Param.STORE_ID, storeId);
        
        // 가게 정보 조회
        try {
            StoreVO store = storeService.getStoreById(storeId);
            if (store != null) {
                model.addAttribute("store", store);
            } else {
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, "존재하지 않는 가게입니다.");
                return "redirect:" + UrlConstants.User.STORE_LIST;
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, "가게 정보를 불러올 수 없습니다.");
            return "redirect:" + UrlConstants.User.STORE_LIST;
        }
        
        if (paymentId != null) {
            model.addAttribute("paymentId", paymentId);
        }
        
        model.addAttribute(UrlConstants.Model.KAKAO_JS_KEY, kakaoProperties.getJsApiKey());
        return UrlConstants.View.USER_REVIEW_WRITE;
    }
    
    // 리뷰 작성 처리
    @PostMapping("/write")
    public String reviewWrite(
            @RequestParam(value = "storeId", required = false) Integer storeId,
            @RequestParam(value = "paymentId", required = false) Integer paymentId,
            @RequestParam(value = "reviewStar", required = false) Integer reviewStar,
            @RequestParam(value = "reviewTitle", required = false) String reviewTitle,
            @RequestParam(value = "reviewContent", required = false) String reviewContent,
            @RequestParam(value = "reviewImage", required = false) MultipartFile reviewImage,
            RedirectAttributes redirectAttributes, 
            HttpSession session) {
        try {
            // 세션에서 사용자 정보 가져오기
            UserVO loginUser = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
            if (loginUser == null) {
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_LOGIN_REQUIRED);
                return "redirect:" + UrlConstants.User.LOGIN_PAGE;
            }
            
            // ReviewVO 객체 생성
            ReviewVO review = new ReviewVO();
            review.setUsersId((int) loginUser.getUsersId());
            review.setStoreId(storeId);
            review.setReviewStar(reviewStar);
            review.setReviewTitle(reviewTitle);
            review.setReviewContent(reviewContent);
            review.setUsersPaymentId(paymentId != null ? paymentId : DEFAULT_USERS_PAYMENT_ID); // paymentId 설정
            review.setReviewCommentId(DEFAULT_REVIEW_COMMENT_ID); // 기본값 설정
            
            // 가게 ID 검증
            if (review.getStoreId() == null) {
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_STORE_ID_REQUIRED);
                return "redirect:" + UrlConstants.User.REVIEW_WRITE;
            }
            
            // 별점 검증
            if (review.getReviewStar() == null) {
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_STAR_RATING_REQUIRED);
                return "redirect:" + UrlConstants.User.REVIEW_WRITE;
            }
            
            if (!reviewService.isValidStarRating(review.getReviewStar())) {
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_INVALID_STAR_RATING);
                return "redirect:" + UrlConstants.User.REVIEW_WRITE;
            }
            
            // 내용 검증
            if (review.getReviewContent() == null || review.getReviewContent().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_REVIEW_CONTENT_REQUIRED);
                return "redirect:" + UrlConstants.User.REVIEW_WRITE;
            }
            
            // 이미지 업로드 처리
            if (reviewImage != null && !reviewImage.isEmpty()) {
                String fileName = s3ServiceV2.uploadReviewImage(reviewImage);
                String publicUrl = s3ServiceV2.getPublicFileUrl(fileName);
                review.setReviewImage(publicUrl);
            }
            
            reviewService.registerReview(review);
            redirectAttributes.addFlashAttribute(UrlConstants.Model.SUCCESS, MSG_REVIEW_REGISTER_SUCCESS);
            
            // 결제 내역 페이지로 리다이렉트 (paymentId가 있는 경우)
            if (paymentId != null) {
                return "redirect:" + UrlConstants.User.PAYMENT_HISTORY + "?reviewCompleted=true";
            } else {
                // 해당 가게의 상세페이지로 리다이렉트
                return "redirect:" + UrlConstants.User.STORE_DETAIL + "?storeId=" + review.getStoreId();
            }
            
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
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_REVIEW_NOT_FOUND);
                return "redirect:" + UrlConstants.User.STORE_LIST;
            }
            
            model.addAttribute("review", review);
            model.addAttribute(UrlConstants.Model.KAKAO_JS_KEY, kakaoProperties.getJsApiKey());
            
            return UrlConstants.View.USER_REVIEW_EDIT;
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_REVIEW_LOAD_ERROR);
            return "redirect:" + UrlConstants.User.STORE_LIST;
        }
    }
    
    // 리뷰 수정 처리
    @PostMapping("/edit")
    public String reviewEdit(@ModelAttribute ReviewVO review, RedirectAttributes redirectAttributes) {
        try {
            reviewService.updateReview(review);
            redirectAttributes.addFlashAttribute(UrlConstants.Model.SUCCESS, MSG_REVIEW_UPDATE_SUCCESS);
            
            return "redirect:" + UrlConstants.User.STORE_DETAIL + "?storeId=" + review.getStoreId();
            
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, e.getMessage());
            return "redirect:" + UrlConstants.User.REVIEW_EDIT + "/" + review.getReviewId();
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_REVIEW_UPDATE_ERROR);
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
                redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_REVIEW_NOT_FOUND);
                return "redirect:" + UrlConstants.User.STORE_LIST;
            }
            
            Integer storeId = review.getStoreId();
            reviewService.deleteReview(reviewId);
            
            redirectAttributes.addFlashAttribute(UrlConstants.Model.SUCCESS, MSG_REVIEW_DELETE_SUCCESS);
            
            return "redirect:" + UrlConstants.User.STORE_DETAIL + "?storeId=" + storeId;
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_REVIEW_DELETE_ERROR);
            return "redirect:" + UrlConstants.User.STORE_LIST;
        }
    }
    
    // 내 리뷰 관리 페이지
    @GetMapping("/my-review")
    public String myReviewPage(HttpSession session, RedirectAttributes redirectAttributes) {
        UserVO loginUser = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (loginUser == null) {
            redirectAttributes.addFlashAttribute(UrlConstants.Model.ERROR, MSG_LOGIN_REQUIRED);
            return "redirect:" + UrlConstants.User.LOGIN_PAGE;
        }
        
        return UrlConstants.View.USER_REVIEW_MY_REVIEW;
    }
    
    // 내 리뷰 목록 API
    @GetMapping("/my-reviews")
    @ResponseBody
    public Map<String, Object> getMyReviews(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "all") String filter,
            @RequestParam(defaultValue = "latest") String sort,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO loginUser = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
            if (loginUser == null) {
                response.put("success", false);
                response.put("message", MSG_LOGIN_REQUIRED);
                return response;
            }
            
            int pageSize = DEFAULT_PAGE_SIZE;
            int offset = (page - 1) * pageSize;
            
            // 리뷰 목록 조회
            List<ReviewVO> reviews = reviewService.getMyReviews((int) loginUser.getUsersId(), filter, sort, offset, pageSize);
            
            // 통계 정보 조회
            Map<String, Object> stats = reviewService.getMyReviewStats((int) loginUser.getUsersId());
            
            // 리뷰 데이터 변환
            List<Map<String, Object>> reviewData = reviews.stream()
                .map(review -> {
                    Map<String, Object> reviewMap = new HashMap<>();
                    reviewMap.put("reviewId", review.getReviewId());
                    reviewMap.put("reviewTitle", review.getReviewTitle());
                    reviewMap.put("reviewContent", review.getReviewContent());
                    reviewMap.put("reviewRating", review.getReviewStar());
                    reviewMap.put("reviewDate", review.getReviewDate());
                    reviewMap.put("reviewImage", review.getReviewImage());
                    reviewMap.put("storeName", review.getStoreName());
                    return reviewMap;
                })
                .collect(Collectors.toList());
            
            response.put("success", true);
            response.put("reviews", reviewData);
            response.put("stats", stats);
            response.put("hasMore", reviews.size() == pageSize);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", MSG_REVIEW_LOAD_FAILED);
        }
        
        return response;
    }
    
    // 리뷰 상세 정보 API
    @GetMapping("/detail/{reviewId}")
    @ResponseBody
    public Map<String, Object> getReviewDetail(@PathVariable Integer reviewId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO loginUser = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
            if (loginUser == null) {
                response.put("success", false);
                response.put("message", MSG_LOGIN_REQUIRED);
                return response;
            }
            
            ReviewVO review = reviewService.getReviewById(reviewId);
            if (review == null) {
                response.put("success", false);
                response.put("message", MSG_REVIEW_NOT_FOUND_API);
                return response;
            }
            
            // 본인이 작성한 리뷰인지 확인
            if (review.getUsersId() != (int) loginUser.getUsersId()) {
                response.put("success", false);
                response.put("message", MSG_NO_PERMISSION);
                return response;
            }
            
            Map<String, Object> reviewData = new HashMap<>();
            reviewData.put("reviewId", review.getReviewId());
            reviewData.put("reviewTitle", review.getReviewTitle());
            reviewData.put("reviewContent", review.getReviewContent());
            reviewData.put("reviewRating", review.getReviewStar());
            reviewData.put("reviewImage", review.getReviewImage());
            
            response.put("success", true);
            response.put("review", reviewData);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", MSG_REVIEW_INFO_LOAD_FAILED);
        }
        
        return response;
    }
    
    // 리뷰 수정 API
    @PostMapping("/update")
    @ResponseBody
    public Map<String, Object> updateReview(
            @RequestParam Integer reviewId,
            @RequestParam String reviewTitle,
            @RequestParam String reviewContent,
            @RequestParam Integer reviewRating,
            @RequestParam(required = false) MultipartFile reviewImage,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO loginUser = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
            if (loginUser == null) {
                response.put("success", false);
                response.put("message", MSG_LOGIN_REQUIRED);
                return response;
            }
            
            ReviewVO review = reviewService.getReviewById(reviewId);
            if (review == null) {
                response.put("success", false);
                response.put("message", MSG_REVIEW_NOT_FOUND_API);
                return response;
            }
            
            // 본인이 작성한 리뷰인지 확인
            if (review.getUsersId() != (int) loginUser.getUsersId()) {
                response.put("success", false);
                response.put("message", MSG_NO_PERMISSION);
                return response;
            }
            
            // 리뷰 정보 업데이트
            review.setReviewTitle(reviewTitle);
            review.setReviewContent(reviewContent);
            review.setReviewStar(reviewRating);
            
            // 이미지 업로드 처리
            if (reviewImage != null && !reviewImage.isEmpty()) {
                String fileName = s3ServiceV2.uploadReviewImage(reviewImage);
                String publicUrl = s3ServiceV2.getPublicFileUrl(fileName);
                review.setReviewImage(publicUrl);
            }
            
            reviewService.updateReview(review);
            
            response.put("success", true);
            response.put("message", MSG_REVIEW_UPDATED);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", MSG_REVIEW_UPDATE_FAILED);
        }
        
        return response;
    }
    
    // 리뷰 삭제 API
    @DeleteMapping("/delete/{reviewId}")
    @ResponseBody
    public Map<String, Object> deleteReview(@PathVariable Integer reviewId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO loginUser = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
            if (loginUser == null) {
                response.put("success", false);
                response.put("message", MSG_LOGIN_REQUIRED);
                return response;
            }
            
            ReviewVO review = reviewService.getReviewById(reviewId);
            if (review == null) {
                response.put("success", false);
                response.put("message", MSG_REVIEW_NOT_FOUND_API);
                return response;
            }
            
            // 본인이 작성한 리뷰인지 확인
            if (review.getUsersId() != (int) loginUser.getUsersId()) {
                response.put("success", false);
                response.put("message", MSG_NO_PERMISSION);
                return response;
            }
            
            reviewService.deleteReview(reviewId);
            
            response.put("success", true);
            response.put("message", MSG_REVIEW_DELETED);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", MSG_REVIEW_DELETE_FAILED);
        }
        
        return response;
    }
}
