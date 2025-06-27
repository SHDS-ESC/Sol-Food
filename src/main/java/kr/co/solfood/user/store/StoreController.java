package kr.co.solfood.user.store;

import properties.KakaoProperties;
import kr.co.solfood.user.category.CategoryService;
import kr.co.solfood.user.category.CategoryVO;
import kr.co.solfood.user.menu.MenuService;
import kr.co.solfood.user.menu.MenuVO;
import kr.co.solfood.user.review.ReviewService;
import kr.co.solfood.user.review.ReviewVO;
import static kr.co.solfood.user.review.ReviewConstants.STAR_COUNT;
import kr.co.solfood.user.store.response.CategoryResponseVO;
import kr.co.solfood.user.store.response.StoreListResponseVO;
import kr.co.solfood.user.store.response.StoreSearchResponseVO;
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
    private KakaoProperties kakaoProperties;

    @Autowired
    private ReviewService reviewService;

    @Autowired
    private MenuService menuService;

    // ========================= 페이지 렌더링 메서드들 =========================

    @GetMapping({"", "/list"})
    public String getStoreList(
            @RequestParam(value = "category", required = false) String category,
            Model model
    ) {
        try {
            // 카테고리 목록 조회
            if (categoryService != null) {
                List<CategoryVO> categories = categoryService.getAllCategories();
                model.addAttribute("categories", categories);
            } else {
                model.addAttribute("categories", new ArrayList<CategoryVO>());
            }

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

    @GetMapping("/detail/{storeId}")
    public String getStoreDetailById(@PathVariable int storeId) {
        StoreVO store = service.getStoreById(storeId);
        if (store == null) {
            return "error/404";
        }
        return "redirect:/user/store/detail?storeId=" + storeId;
    }

    // ========================= API 메서드들 (VO 패턴 적용) =========================

    /**
     * 페이징된 가게 목록 조회 API
     */
    @GetMapping("/api/list")
    @ResponseBody
    public StoreListResponseVO getStoreListAjax(
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

            return StoreListResponseVO.success(
                pageMaker.getList(),
                hasNext,
                offset,
                pageSize,
                pageMaker.getCount()
            );

        } catch (Exception e) {
            log.error("API 호출 중 에러 발생", e);
            return StoreListResponseVO.error(e.getMessage());
        }
    }

    /**
     * 키워드 검색 API
     */
    @GetMapping("/api/search")
    @ResponseBody
    public StoreListResponseVO searchStoresWithPaging(
            @RequestParam String keyword,
            @RequestParam(value = "offset", defaultValue = "0") int offset,
            @RequestParam(value = "pageSize", defaultValue = "10") int pageSize) {

        try {
            PageDTO pageDTO = new PageDTO();
            pageDTO.setCurrentPage(offset / pageSize + 1);
            pageDTO.setPageSize(pageSize);

            PageMaker<StoreVO> pageMaker = service.getPagedSearchResults(keyword, pageDTO);
            boolean hasNext = offset + pageSize < pageMaker.getCount();

            return StoreListResponseVO.success(
                pageMaker.getList(),
                hasNext,
                offset,
                pageSize,
                pageMaker.getCount()
            );

        } catch (Exception e) {
            log.error("페이징 검색 실패: keyword={}", keyword, e);
            return StoreListResponseVO.error("검색 중 오류가 발생했습니다.");
        }
    }

    /**
     * 전체 가게 검색 API (호환성 유지)
     */
    @GetMapping("/search")
    @ResponseBody
    public ResponseEntity<StoreSearchResponseVO> searchStores(@RequestParam String keyword) {
        try {
            List<StoreVO> storeList = service.searchStores(keyword);
            StoreSearchResponseVO response = StoreSearchResponseVO.success(keyword, storeList, "general");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("가게 검색 실패: keyword={}", keyword, e);
            StoreSearchResponseVO response = StoreSearchResponseVO.error(keyword, "검색 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 가게명으로 검색 API
     */
    @GetMapping("/search/name")
    @ResponseBody
    public ResponseEntity<StoreSearchResponseVO> searchStoresByName(@RequestParam String name) {
        try {
            List<StoreVO> storeList = service.searchStoresByName(name);
            StoreSearchResponseVO response = StoreSearchResponseVO.success(name, storeList, "name");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("가게명 검색 실패: name={}", name, e);
            StoreSearchResponseVO response = StoreSearchResponseVO.error(name, "가게명 검색 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 주소로 검색 API
     */
    @GetMapping("/search/address")
    @ResponseBody
    public ResponseEntity<StoreSearchResponseVO> searchStoresByAddress(@RequestParam String address) {
        try {
            List<StoreVO> storeList = service.searchStoresByAddress(address);
            StoreSearchResponseVO response = StoreSearchResponseVO.success(address, storeList, "address");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("주소 검색 실패: address={}", address, e);
            StoreSearchResponseVO response = StoreSearchResponseVO.error(address, "주소 검색 중 오류가 발생했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 전체 가게 목록 조회 API
     */
    @GetMapping("/stores")
    @ResponseBody
    public ResponseEntity<CategoryResponseVO> getAllStoresApi() {
        try {
            List<StoreVO> storeList = service.getAllStore();
            CategoryResponseVO response = CategoryResponseVO.storesByCategory("전체", storeList);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("전체 가게 목록 조회 실패", e);
            CategoryResponseVO response = CategoryResponseVO.error("가게 목록을 불러오는데 실패했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 카테고리별 가게 목록 조회 API
     */
    @GetMapping("/category")
    @ResponseBody
    public ResponseEntity<CategoryResponseVO> getCategoryStoreApi(@RequestParam String category) {
        try {
            List<StoreVO> storeList;
            if ("전체".equals(category)) {
                storeList = service.getAllStore();
            } else {
                storeList = service.getCategoryStore(category);
            }

            CategoryResponseVO response = CategoryResponseVO.storesByCategory(category, storeList);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("카테고리별 가게 조회 실패: category={}", category, e);
            CategoryResponseVO response = CategoryResponseVO.error("가게 목록을 불러오는데 실패했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 카테고리 목록 조회 API
     */
    @GetMapping("/api/categories")
    @ResponseBody
    public ResponseEntity<CategoryResponseVO> getCategories() {
        try {
            List<CategoryVO> categories = categoryService.getAllCategories();
            CategoryResponseVO response = CategoryResponseVO.categoryList(categories);
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            log.error("카테고리 목록 조회 실패", e);
            CategoryResponseVO response = CategoryResponseVO.error("카테고리 목록을 불러오는데 실패했습니다.");
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    /**
     * 카테고리 설정 정보 API
     */
    @GetMapping("/api/category/config")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCategoryConfig() {
        Map<String, Object> config = categoryService.getCategoryConfig();
        return ResponseEntity.ok(Map.of("success", true, "data", config));
    }

    // ========================= 헬퍼 메서드들 =========================

    /**
     * 가게의 통계 정보를 모델에 추가하는 private 메서드
     */
    private void addStoreStatistics(Model model, Integer storeId) {
        Double avgStar = reviewService.getAverageStarByStoreId(storeId);
        Integer totalCount = reviewService.getTotalCountByStoreId(storeId);
        Map<String, Object> starCountsMap = reviewService.getStarCountsByStoreId(storeId);

        long[] starCounts = new long[STAR_COUNT];
        if (starCountsMap != null) {
            for (int i = 1; i <= STAR_COUNT; i++) {
                String key = "star" + i;
                int arrayIndex = i - 1;
                Object value = starCountsMap.get(key);
                starCounts[arrayIndex] = value != null ? ((Number) value).longValue() : 0;
            }
        }

        model.addAttribute("avgStar", avgStar != null ? avgStar : 0.0);
        model.addAttribute("totalCount", totalCount != null ? totalCount : 0);
        model.addAttribute("starCounts", starCounts);
    }

    // ========================= 예외 처리 =========================

    /**
     * Store 관련 예외 전역 처리
     */
    @ExceptionHandler(StoreException.class)
    @ResponseBody
    public ResponseEntity<StoreSearchResponseVO> handleStoreException(StoreException e) {
        log.error("Store 비즈니스 예외 발생", e);
        StoreSearchResponseVO response = StoreSearchResponseVO.error("", e.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
    }
    
    /**
     * 데이터베이스 예외 전역 처리
     */
    @ExceptionHandler(org.springframework.dao.DataAccessException.class)
    @ResponseBody
    public ResponseEntity<StoreSearchResponseVO> handleDataAccessException(org.springframework.dao.DataAccessException e) {
        log.error("데이터베이스 접근 예외 발생", e);
        StoreSearchResponseVO response = StoreSearchResponseVO.error("", "데이터 처리 중 오류가 발생했습니다.");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }
}
