package kr.co.solfood.owner.review;

import kr.co.solfood.user.review.ReviewService;
import kr.co.solfood.user.review.ReviewVO;
import kr.co.solfood.user.store.StoreService;
import kr.co.solfood.user.store.StoreVO;
import kr.co.solfood.owner.login.OwnerVO;
import kr.co.solfood.owner.store.OwnerStoreService;
import kr.co.solfood.owner.store.OwnerStoreVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/owner/review")
public class OwnerReviewController {

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private StoreService storeService;

    @Autowired
    private OwnerStoreService ownerStoreService;

    /**
     * 점주 리뷰 관리 페이지
     */
    @GetMapping("")
    public String reviewManagement(Model model, HttpSession session) {
        OwnerVO owner = (OwnerVO) session.getAttribute("ownerLoginSession");
        if (owner == null) {
            return "redirect:/owner/login";
        }

        // 점주가 관리하는 가게 정보 조회
        OwnerStoreVO ownerStore = ownerStoreService.getOwnerStore(owner.getOwnerId());
        if (ownerStore == null) {
            model.addAttribute("error", "등록된 가게가 없습니다.");
            return "owner/review";
        }

        // 가게의 리뷰 목록 조회
        List<ReviewVO> reviews = reviewService.getReviewsByStoreId(ownerStore.getStoreId());
        
        // 통계 정보 (store_avgstar 사용)
        Double avgStar = ownerStore.getStoreAvgstar();
        Integer totalCount = reviewService.getTotalCountByStoreId(ownerStore.getStoreId());
        Map<String, Object> starCounts = reviewService.getStarCountsByStoreId(ownerStore.getStoreId());

        model.addAttribute("store", ownerStore);
        model.addAttribute("reviews", reviews);
        model.addAttribute("avgStar", avgStar != null ? avgStar : 0.0);
        model.addAttribute("totalCount", totalCount != null ? totalCount : 0);
        model.addAttribute("starCounts", starCounts);

        return "owner/review";
    }

    /**
     * 리뷰 답글 작성/수정 API
     */
    @PostMapping("/response")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> writeResponse(
            @RequestParam Integer reviewId,
            @RequestParam String response,
            @RequestParam(required = false) Integer currentStoreId,
            HttpSession session) {
        
        Map<String, Object> result = new HashMap<>();
        OwnerVO owner = (OwnerVO) session.getAttribute("ownerLoginSession");
        

        
        if (owner == null) {
            log.warn("세션에 점주 정보가 없음");
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.badRequest().body(result);
        }
        


        try {
            // 리뷰 조회
            ReviewVO review = reviewService.getReviewById(reviewId);
            if (review == null) {
                log.warn("존재하지 않는 리뷰: reviewId={}", reviewId);
                result.put("success", false);
                result.put("message", "존재하지 않는 리뷰입니다.");
                return ResponseEntity.badRequest().body(result);
            }
            


            // 권한 검증
            boolean hasPermission = false;
            String permissionSource = "";
            
            // 1. Store ID 입력을 통해 조회한 경우
            if (currentStoreId != null && currentStoreId.equals(review.getStoreId())) {
                hasPermission = true;
                permissionSource = "Store ID 입력 (currentStoreId: " + currentStoreId + ")";
            } else {
                // 2. 점주 본인의 가게인지 확인
                OwnerStoreVO ownerStore = ownerStoreService.getOwnerStore(owner.getOwnerId());
                if (ownerStore != null && ownerStore.getStoreId() == review.getStoreId()) {
                    hasPermission = true;
                    permissionSource = "점주 소유 가게 (storeId: " + ownerStore.getStoreId() + ")";
                }
            }
            
            if (!hasPermission) {
                result.put("success", false);
                result.put("message", "권한이 없습니다.");
                return ResponseEntity.badRequest().body(result);
            }

            // 답글 업데이트
            review.setReviewResponse(response);
            boolean updated = reviewService.updateReview(review);
            
            if (updated) {
                result.put("success", true);
                result.put("message", "답글이 저장되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "답글 저장에 실패했습니다.");
            }

        } catch (Exception e) {
            log.error("리뷰 답글 저장 중 오류", e);
            result.put("success", false);
            result.put("message", "서버 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 리뷰 답글 삭제 API
     */
    @DeleteMapping("/response/{reviewId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteResponse(
            @PathVariable Integer reviewId,
            HttpSession session) {
        
        Map<String, Object> result = new HashMap<>();
        OwnerVO owner = (OwnerVO) session.getAttribute("ownerLoginSession");
        
        if (owner == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.badRequest().body(result);
        }

        try {
            // 리뷰 조회
            ReviewVO review = reviewService.getReviewById(reviewId);
            if (review == null) {
                result.put("success", false);
                result.put("message", "존재하지 않는 리뷰입니다.");
                return ResponseEntity.badRequest().body(result);
            }

            // 점주가 관리하는 가게의 리뷰인지 확인
            OwnerStoreVO ownerStore = ownerStoreService.getOwnerStore(owner.getOwnerId());
            if (ownerStore == null || ownerStore.getStoreId() != review.getStoreId()) {
                result.put("success", false);
                result.put("message", "권한이 없습니다.");
                return ResponseEntity.badRequest().body(result);
            }

            // 답글 삭제 (빈 문자열로 설정)
            review.setReviewResponse("");
            boolean updated = reviewService.updateReview(review);
            
            if (updated) {
                result.put("success", true);
                result.put("message", "답글이 삭제되었습니다.");
            } else {
                result.put("success", false);
                result.put("message", "답글 삭제에 실패했습니다.");
            }

        } catch (Exception e) {
            log.error("리뷰 답글 삭제 중 오류", e);
            result.put("success", false);
            result.put("message", "서버 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }

    /**
     * 필터링된 리뷰 목록 조회 API
     */
    @GetMapping("/api/list")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getFilteredReviews(
            @RequestParam(required = false) Integer star,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) String period,
            @RequestParam(required = false) Integer storeId,
            HttpSession session) {
        
        Map<String, Object> result = new HashMap<>();
        OwnerVO owner = (OwnerVO) session.getAttribute("ownerLoginSession");
        
        if (owner == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.badRequest().body(result);
        }

        try {
            // storeId가 제공된 경우 해당 store의 리뷰 조회, 아니면 점주의 가게 리뷰 조회
            Integer targetStoreId = storeId;
            if (targetStoreId == null) {
                // 점주가 관리하는 가게 정보 조회
                OwnerStoreVO ownerStore = ownerStoreService.getOwnerStore(owner.getOwnerId());
                if (ownerStore == null) {
                    result.put("success", false);
                    result.put("message", "등록된 가게가 없습니다.");
                    return ResponseEntity.badRequest().body(result);
                }
                targetStoreId = ownerStore.getStoreId();
            }

            // 가게의 모든 리뷰 조회 (필터링은 프론트엔드에서 처리)
            List<ReviewVO> reviews = reviewService.getReviewsByStoreId(targetStoreId);
            
            result.put("success", true);
            result.put("reviews", reviews);
            
            // null 값을 허용하는 HashMap 사용
            Map<String, Object> filters = new HashMap<>();
            filters.put("star", star);
            filters.put("keyword", keyword);
            filters.put("period", period);
            result.put("filters", filters);

        } catch (Exception e) {
            log.error("리뷰 목록 조회 중 오류", e);
            result.put("success", false);
            result.put("message", "서버 오류가 발생했습니다.");
        }

        return ResponseEntity.ok(result);
    }


} 