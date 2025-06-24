package kr.co.solfood.user.store;

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
        List<StoreVO> storeList;
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

    // 검색 API - AJAX 요청용
    @GetMapping("/search")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> searchStores(@RequestParam String keyword) {
        Map<String, Object> response = new HashMap<>();

        try {
            List<StoreVO> storeList = service.searchStores(keyword);

            response.put("success", true);
            response.put("keyword", keyword);
            response.put("stores", storeList);  // data -> stores로 변경하여 통일
            response.put("count", storeList.size());
            response.put("message", "검색이 완료되었습니다.");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("가게 검색 실패: keyword={}", keyword, e);
            response.put("success", false);
            response.put("message", "검색 중 오류가 발생했습니다.");
            response.put("error", e.getMessage());

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    // 가게명으로 검색 API
    @GetMapping("/search/name")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> searchStoresByName(@RequestParam String name) {
        Map<String, Object> response = new HashMap<>();

        try {
            List<StoreVO> storeList = service.searchStoresByName(name);

            response.put("success", true);
            response.put("searchType", "name");
            response.put("keyword", name);
            response.put("stores", storeList);  // data -> stores로 변경하여 통일
            response.put("count", storeList.size());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("가게명 검색 실패: name={}", name, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("가게명 검색 중 오류가 발생했습니다."));
        }
    }

    // 주소로 검색 API
    @GetMapping("/search/address")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> searchStoresByAddress(@RequestParam String address) {
        Map<String, Object> response = new HashMap<>();

        try {
            List<StoreVO> storeList = service.searchStoresByAddress(address);

            response.put("success", true);
            response.put("searchType", "address");
            response.put("keyword", address);
            response.put("stores", storeList);  // data -> stores로 변경하여 통일
            response.put("count", storeList.size());

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("주소 검색 실패: address={}", address, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("주소 검색 중 오류가 발생했습니다."));
        }
    }

    // Ajax용 전체 가게 목록 조회 API
    @GetMapping("/stores")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getAllStoresApi() {
        Map<String, Object> response = new HashMap<>();

        try {
            List<StoreVO> storeList = service.getAllStore();

            response.put("success", true);
            response.put("stores", storeList);
            response.put("count", storeList.size());
            response.put("category", "전체");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("전체 가게 목록 조회 실패", e);
            response.put("success", false);
            response.put("message", "가게 목록을 불러오는데 실패했습니다.");
            response.put("error", e.getMessage());

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    // Ajax용 카테고리별 목록 조회 API
    @GetMapping("/category")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCategoryStoreApi(@RequestParam String category) {
        Map<String, Object> response = new HashMap<>();

        try {
            List<StoreVO> storeList;
            if ("전체".equals(category)) {
                storeList = service.getAllStore();
            } else {
                storeList = service.getCategoryStore(category);
            }

            response.put("success", true);
            response.put("stores", storeList);  // 검색 API와 동일한 키 이름 사용
            response.put("count", storeList.size());
            response.put("category", category);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("카테고리별 가게 조회 실패: category={}", category, e);
            response.put("success", false);
            response.put("message", "가게 목록을 불러오는데 실패했습니다.");
            response.put("error", e.getMessage());

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    
    // 상점 상세 페이지로 이동
    @GetMapping("/detail/{storeId}")
    public String getStoreDetail(@PathVariable int storeId) {
        // 해당 가게가 존재하는지 확인
        StoreVO store = service.getStoreById(storeId);
        if (store == null) {
            // 존재하지 않는 가게면 404 페이지 표시
            return "error/404";
        }
        
        // 리뷰 리스트 페이지로 리다이렉트 (상점 상세 페이지 역할)
        return "redirect:/user/review/list?storeId=" + storeId;
    }
    
    //카테고리 설정 정보 API
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
