package kr.co.solfood.user.store;

import kr.co.solfood.user.category.CategoryService;
import kr.co.solfood.user.category.CategoryVO;
import kr.co.solfood.user.menu.MenuService;
import kr.co.solfood.user.menu.MenuVO;
import kr.co.solfood.user.review.ReviewService;
import kr.co.solfood.user.review.ReviewVO;
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

import java.util.ArrayList;
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
    private CategoryService categoryService;

    @Autowired
    private CategoryProperties categoryProperties;
    
    @Autowired
    private KakaoProperties kakaoProperties;

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private MenuService menuService;

    // 별점 개수 상수
    private static final int STAR_COUNT = 5;

    @GetMapping({"", "/list"})
    public String getStoreList(
            @RequestParam(value = "category", required = false) String category,
            Model model
    ) {
        try {
            // 데이터베이스에서 카테고리 목록 조회
            if (categoryService != null) {
                List<CategoryVO> categories = categoryService.getAllCategories();
                model.addAttribute("categories", categories);
            } else {
                model.addAttribute("categories", new ArrayList<CategoryVO>());
            }
            
            // 초기 로딩은 JavaScript에서 Ajax로 처리하므로 빈 페이지만 반환
            if (category != null) {
                model.addAttribute("currentCategory", category);
            }
            
            model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
            
        } catch (Exception e) {
            log.error("카테고리 목록 조회 실패", e);
            model.addAttribute("categories", new ArrayList<CategoryVO>());
            model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
        }
        
        return "user/store/list";
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

    // 가게 상세 페이지 (기존 review/list 기능)
    @GetMapping("/detail")
    public String getStoreDetail(@RequestParam(required = false) Integer storeId, Model model) {
        if (storeId == null) {
            return "redirect:/user/store/list";
        }
        
        try {
            // 가게 정보 조회
            StoreVO store = service.getStoreById(storeId);
            if (store == null) {
                return "redirect:/user/store/list";
            }
            
            // 해당 가게의 리뷰 목록 조회
            List<ReviewVO> reviewList = reviewService.getReviewsByStoreId(storeId);
            
            // 해당 가게의 메뉴 목록 조회
            List<MenuVO> menuList = menuService.getMenusByStoreId(storeId);
            
            model.addAttribute("reviewList", reviewList);
            model.addAttribute("storeId", storeId);
            model.addAttribute("store", store);
            model.addAttribute("kakaoJsKey", kakaoProperties.getJsApiKey());
            model.addAttribute("menuList", menuList);
            
            // 해당 가게의 평균 별점 및 통계 조회
            addStoreStatistics(model, storeId);
            
            return "user/store/detail";
            
        } catch (Exception e) {
            log.error("가게 상세 페이지 조회 중 오류 발생. storeId: {}", storeId, e);
            return "redirect:/user/store/list";
        }
    }
    
    // 상점 상세 페이지로 이동 (기졸 메서드)
    @GetMapping("/detail/{storeId}")
    public String getStoreDetailById(@PathVariable int storeId) {
        // 해당 가게가 존재하는지 확인
        StoreVO store = service.getStoreById(storeId);
        if (store == null) {
            // 존재하지 않는 가게면 404 페이지 표시
            return "error/404";
        }
        
        // 가게 상세 페이지로 리다이렉트
        return "redirect:/user/store/detail?storeId=" + storeId;
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
    
    // 카테고리 목록 API
    @GetMapping("/api/categories")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCategories() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<CategoryVO> categories = categoryService.getAllCategories();
            
            response.put("success", true);
            response.put("categories", categories);
            response.put("count", categories.size());
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            log.error("카테고리 목록 조회 실패", e);
            response.put("success", false);
            response.put("message", "카테고리 목록을 불러오는데 실패했습니다.");
            response.put("error", e.getMessage());
            
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
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
        
        try {
            PageDTO pageDTO = new PageDTO();
            pageDTO.setCurrentPage(offset / pageSize + 1);
            pageDTO.setPageSize(pageSize);

            String searchCategory = (category == null) ? "전체" : category;
            PageMaker<StoreVO> pageMaker = service.getPagedCategoryStoreList(searchCategory, pageDTO);
            boolean hasNext = offset + pageSize < pageMaker.getCount();

            Map<String, Object> result = new HashMap<>();
            result.put("list", pageMaker.getList());
            result.put("hasNext", hasNext);
            result.put("offset", offset);
            result.put("pageSize", pageSize);
            result.put("totalCount", pageMaker.getCount());
            
            return result;
            
        } catch (Exception e) {
            log.error("API 호출 중 에러 발생", e);
            
            Map<String, Object> errorResult = new HashMap<>();
            errorResult.put("error", true);
            errorResult.put("message", e.getMessage());
            errorResult.put("list", List.of());
            errorResult.put("hasNext", false);
            errorResult.put("totalCount", 0);
            
            return errorResult;
        }
    }

    // 검색용 페이징 API - /user/store/api/search?keyword=치킨&offset=0&pageSize=10
    @GetMapping("/api/search")
    @ResponseBody
    public Map<String, Object> searchStoresWithPaging(
            @RequestParam String keyword,
            @RequestParam(value = "offset", defaultValue = "0") int offset,
            @RequestParam(value = "pageSize", defaultValue = "10") int pageSize) {

        Map<String, Object> result = new HashMap<>();

        try {
            PageDTO pageDTO = new PageDTO();
            pageDTO.setCurrentPage(offset / pageSize + 1);
            pageDTO.setPageSize(pageSize);

            PageMaker<StoreVO> pageMaker = service.getPagedSearchResults(keyword, pageDTO);
            boolean hasNext = offset + pageSize < pageMaker.getCount();

            result.put("success", true);
            result.put("list", pageMaker.getList());
            result.put("hasNext", hasNext);
            result.put("offset", offset);
            result.put("pageSize", pageSize);
            result.put("totalCount", pageMaker.getCount());
            result.put("keyword", keyword);

        } catch (Exception e) {
            log.error("페이징 검색 실패: keyword={}", keyword, e);
            result.put("success", false);
            result.put("message", "검색 중 오류가 발생했습니다.");
        }

        return result;
    }

    // 가게의 통계 정보를 모델에 추가하는 private 메서드
    private void addStoreStatistics(Model model, Integer storeId) {
        Double avgStar = reviewService.getAverageStarByStoreId(storeId);
        Integer totalCount = reviewService.getTotalCountByStoreId(storeId);
        Map<String, Object> starCountsMap = reviewService.getStarCountsByStoreId(storeId);
        
        // 별점별 개수를 배열로 변환 (1점부터 5점까지)
        long[] starCounts = new long[STAR_COUNT];
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
    }

}
