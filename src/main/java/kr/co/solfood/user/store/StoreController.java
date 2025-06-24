package kr.co.solfood.user.store;

import configuration.KakaoProperties;
import kr.co.solfood.util.PageDTO;
import kr.co.solfood.util.PageMaker;
import properties.KakaoProperties;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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
    public String getStoreList(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
            Model model
    ) {
        PageDTO pageDTO = new PageDTO();
        pageDTO.setCurrentPage(page);
        pageDTO.setPageSize(pageSize);

        PageMaker<StoreVO> pageMaker;

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

    // /user/store/api/list?category=한식&offset=10&pageSize=10
    @GetMapping("/api/list")
    @ResponseBody
    public Map<String, Object> getStoreListAjax(
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "offset", defaultValue = "0") int offset,
            @RequestParam(value = "pageSize", defaultValue = "10") int pageSize) {

        PageDTO pageDTO = new PageDTO();
        pageDTO.setCurrentPage(offset / pageSize + 1); // 실제로는 offset만 쓰면 됨
        pageDTO.setPageSize(pageSize);

        PageMaker<StoreVO> pageMaker;
        if (category == null || category.equals("전체")) {
            pageMaker = service.getPagedStoreList(pageDTO);
        } else {
            pageMaker = service.getPagedCategoryStoreList(category, pageDTO);
        }

        boolean hasNext = offset + pageSize < pageMaker.getCount();

        Map<String, Object> result = new HashMap<>();
        result.put("list", pageMaker.getList());
        result.put("hasNext", hasNext);
        result.put("offset", offset);
        result.put("pageSize", pageSize);
        result.put("totalCount", pageMaker.getCount());
        return result;
    }

}
