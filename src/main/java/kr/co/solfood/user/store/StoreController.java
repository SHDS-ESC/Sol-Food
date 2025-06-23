package kr.co.solfood.user.store;

import configuration.KakaoProperties;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/user/store")
public class StoreController {
    
    @Autowired
    private StoreService service;

    @Autowired
    private CategoryProperties categoryProperties;
    
    @Autowired
    private KakaoProperties kakaoProperties;

        @GetMapping("")
    public String getStoreList(@RequestParam(value = "category", required = false) String category, Model model) {
        List<StoreVO> storeList;
        if (category == null) {
            storeList = service.getAllStore();
        } else {
            storeList = service.getCategoryStore(category);
            model.addAttribute("currentCategory", category);
        }
        
        model.addAttribute("store", storeList);
        model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
        return "user/store";
    }

    //Ajax용 카테고리별 목록 조회 API
    @GetMapping("/api/store/category/{category}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCategoryStoreApi(@PathVariable String category) {
        List<StoreVO> storeList;
        if (StoreConstants.CATEGORY_ALL.equals(category)) {
            storeList = service.getAllStore();
        } else {
            storeList = service.getCategoryStore(category);
        }
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", storeList);
        response.put("count", storeList.size());
        response.put("category", category);
        
        return ResponseEntity.ok(response);
    }

    //카테고리 설정 정보 API (프론트엔드용)
    @GetMapping("/api/category/config")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCategoryConfig() {
        Map<String, Object> config = categoryProperties.getCategoryConfig();
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", config);
        
        return ResponseEntity.ok(response);
    }

    // 상점 상세 페이지로 이동
    @GetMapping("/detail/{storeId}")
    public String getStoreDetail(@PathVariable int storeId) {
        // 해당 가게가 존재하는지 확인
        StoreVO store = service.getStoreById(storeId);
        if (store == null) {
            // 가게가 없으면 전체 상점 목록으로 리다이렉트
            return "redirect:/user/store";
        }
        
        // 리뷰 리스트 페이지로 리다이렉트 (상점 상세 페이지 역할)
        return "redirect:/user/list?storeId=" + storeId;
    }
    
    /**
     * API 에러 응답 생성 헬퍼 메서드
     */
    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("error", message);
        errorResponse.put("timestamp", System.currentTimeMillis());
        return errorResponse;
    }
    
    /**
     * Store 관련 예외 전역 처리 - API 요청용
     */
    @ExceptionHandler(StoreException.class)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> handleStoreException(StoreException e) {
        log.error("Store 비즈니스 예외 발생", e);
        Map<String, Object> errorResponse = createErrorResponse(e.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
    }
    
    /**
     * 데이터베이스 예외 전역 처리 - API 요청용
     */
    @ExceptionHandler(org.springframework.dao.DataAccessException.class)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> handleDataAccessException(org.springframework.dao.DataAccessException e) {
        log.error("데이터베이스 접근 예외 발생", e);
        Map<String, Object> errorResponse = createErrorResponse("데이터 처리 중 오류가 발생했습니다.");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
    }
}
