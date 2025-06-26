package kr.co.solfood.user.store;

import kr.co.solfood.user.category.CategoryService;
import kr.co.solfood.user.category.CategoryVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.*;

@Slf4j
@Component
public class CategoryProperties {
    
    @Autowired(required = false)
    private CategoryService categoryService;
    
    // 카테고리별 검색 키워드 매핑
    private static final Map<String, String> SEARCH_KEYWORDS = new HashMap<>();
    
    // 카테고리별 매칭 키워드 매핑
    private static final Map<String, List<String>> MATCHING_KEYWORDS = new HashMap<>();
    
    static {
        // 검색 키워드 초기화
        SEARCH_KEYWORDS.put(StoreConstants.CATEGORY_ALL, StoreConstants.DEFAULT_SEARCH_KEYWORD);
        SEARCH_KEYWORDS.put("치킨", "치킨");
        SEARCH_KEYWORDS.put("한식", "한식당");
        SEARCH_KEYWORDS.put("분식", "분식");
        SEARCH_KEYWORDS.put("피자", "피자");
        SEARCH_KEYWORDS.put("찜/탕", "찜닭");
        SEARCH_KEYWORDS.put("중식", "중식당");
        SEARCH_KEYWORDS.put("일식", "일식당");
        SEARCH_KEYWORDS.put("양식", "양식당");
        SEARCH_KEYWORDS.put("카페", "카페");
        SEARCH_KEYWORDS.put("버거", "햄버거");
        SEARCH_KEYWORDS.put("도시락", "도시락");
        SEARCH_KEYWORDS.put("샐러드", "샐러드");
        SEARCH_KEYWORDS.put("디저트", "디저트");
        SEARCH_KEYWORDS.put("회/해물", "횟집");
        SEARCH_KEYWORDS.put("국물요리", "국수");
        SEARCH_KEYWORDS.put("간식", "분식");
        SEARCH_KEYWORDS.put("족발/보쌈", "족발");
        SEARCH_KEYWORDS.put("베이커리", "베이커리");
        
        // 매칭 키워드 초기화
        MATCHING_KEYWORDS.put("치킨", Arrays.asList("치킨", "chicken"));
        MATCHING_KEYWORDS.put("한식", Arrays.asList("한식", "한국", "김치", "불고기", "갈비", "국밥", "찌개"));
        MATCHING_KEYWORDS.put("분식", Arrays.asList("분식", "떡볶이", "순대", "김밥"));
        MATCHING_KEYWORDS.put("피자", Arrays.asList("피자", "pizza"));
        MATCHING_KEYWORDS.put("찜/탕", Arrays.asList("찜", "탕", "갈비탕", "삼계탕", "감자탕"));
        MATCHING_KEYWORDS.put("중식", Arrays.asList("중식", "중국", "짜장", "짬뽕", "탕수육"));
        MATCHING_KEYWORDS.put("일식", Arrays.asList("일식", "초밥", "라멘", "돈까스", "우동"));
        MATCHING_KEYWORDS.put("양식", Arrays.asList("양식", "스테이크", "파스타"));
        MATCHING_KEYWORDS.put("카페", Arrays.asList("카페", "커피", "coffee", "cafe"));
        MATCHING_KEYWORDS.put("버거", Arrays.asList("버거", "햄버거", "burger"));
        MATCHING_KEYWORDS.put("도시락", Arrays.asList("도시락", "벤토"));
        MATCHING_KEYWORDS.put("샐러드", Arrays.asList("샐러드", "salad"));
        MATCHING_KEYWORDS.put("디저트", Arrays.asList("디저트", "케이크", "아이스크림"));
        MATCHING_KEYWORDS.put("회/해물", Arrays.asList("회", "해물", "횟집"));
        MATCHING_KEYWORDS.put("국물요리", Arrays.asList("국", "탕", "찌개", "국수"));
        MATCHING_KEYWORDS.put("간식", Arrays.asList("간식", "과자"));
        MATCHING_KEYWORDS.put("족발/보쌈", Arrays.asList("족발", "보쌈"));
        MATCHING_KEYWORDS.put("베이커리", Arrays.asList("베이커리", "빵집", "bakery"));
    }
    
    // 데이터베이스에서 카테고리 목록을 실시간으로 가져오기
    private List<CategoryVO> dbCategories = new ArrayList<>();
    
    @PostConstruct
    private void initializeDatabaseCategories() {
        try {
            if (categoryService != null) {
                dbCategories = categoryService.getAllCategories();
                log.info("데이터베이스에서 카테고리 {} 개 로드 완료", dbCategories.size());
            } else {
                log.warn("CategoryService가 아직 초기화되지 않았습니다. 기본 카테고리를 사용합니다.");
            }
        } catch (Exception e) {
            log.error("데이터베이스 카테고리 로드 실패, 기본 카테고리 사용", e);
        }
    }
    
    // 모든 카테고리 목록 반환 (데이터베이스 우선, 실패 시 기본값)
    public List<String> getAllCategories() {
        try {
            // CategoryService가 사용 가능할 때만 데이터베이스에서 조회
            if (categoryService != null) {
                List<CategoryVO> currentCategories = categoryService.getAllCategories();
                List<String> categoryNames = new ArrayList<>();
                for (CategoryVO category : currentCategories) {
                    categoryNames.add(category.getCategoryName());
                }
                return categoryNames;
            } else {
                log.warn("CategoryService가 없어서 기본 카테고리 반환");
                return new ArrayList<>(SEARCH_KEYWORDS.keySet());
            }
        } catch (Exception e) {
            log.warn("데이터베이스 카테고리 조회 실패, 기본 카테고리 반환", e);
            return new ArrayList<>(SEARCH_KEYWORDS.keySet());
        }
    }
    
    // 데이터베이스 카테고리 객체 목록 반환
    public List<CategoryVO> getAllCategoryObjects() {
        try {
            if (categoryService != null) {
                return categoryService.getAllCategories();
            } else {
                log.warn("CategoryService가 없어서 빈 목록 반환");
                return new ArrayList<>();
            }
        } catch (Exception e) {
            log.error("카테고리 객체 목록 조회 실패", e);
            return new ArrayList<>();
        }
    }
    
    // 카테고리별 검색 키워드 반환
    public String getSearchKeyword(String category) {
        return SEARCH_KEYWORDS.getOrDefault(category, category);
    }
    
    // 카테고리별 매칭 키워드 목록 반환
    public List<String> getMatchingKeywords(String category) {
        return MATCHING_KEYWORDS.getOrDefault(category, Arrays.asList(category.toLowerCase()));
    }
    
    
    // 카테고리 정보를 JSON 형태로 반환 (프론트엔드용)
    public Map<String, Object> getCategoryConfig() {
        Map<String, Object> config = new HashMap<>();
        config.put("searchKeywords", SEARCH_KEYWORDS);
        config.put("matchingKeywords", MATCHING_KEYWORDS);
        config.put("categories", getAllCategories());
        
        // 데이터베이스 카테고리 정보도 포함
        try {
            if (categoryService != null) {
                List<CategoryVO> categoryObjects = getAllCategoryObjects();
                List<Map<String, Object>> categoryList = new ArrayList<>();
                
                for (CategoryVO category : categoryObjects) {
                    Map<String, Object> categoryInfo = new HashMap<>();
                    categoryInfo.put("id", category.getCategoryId());
                    categoryInfo.put("name", category.getCategoryName());
                    categoryInfo.put("image", category.getCategoryImage());
                    categoryList.add(categoryInfo);
                }
                
                config.put("categoryObjects", categoryList);
            } else {
                log.warn("CategoryService가 없어서 카테고리 객체 정보 제외");
            }
        } catch (Exception e) {
            log.error("카테고리 객체 정보 구성 실패", e);
        }
        
        return config;
    }
} 