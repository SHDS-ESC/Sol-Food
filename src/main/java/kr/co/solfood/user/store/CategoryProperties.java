package kr.co.solfood.user.store;

import lombok.Data;
import org.springframework.stereotype.Component;

import java.util.*;

@Data
@Component
public class CategoryProperties {
    
    // 카테고리별 검색 키워드 매핑
    private static final Map<String, String> SEARCH_KEYWORDS = new HashMap<>();
    
    // 카테고리별 매칭 키워드 매핑
    private static final Map<String, List<String>> MATCHING_KEYWORDS = new HashMap<>();
    
    static {
        // 검색 키워드 초기화
        SEARCH_KEYWORDS.put("전체", "음식점");
        SEARCH_KEYWORDS.put("한식", "한식당");
        SEARCH_KEYWORDS.put("카페", "카페");
        SEARCH_KEYWORDS.put("일식", "일식당");
        SEARCH_KEYWORDS.put("중식", "중식당");
        SEARCH_KEYWORDS.put("양식", "양식당");
        SEARCH_KEYWORDS.put("치킨", "치킨");
        SEARCH_KEYWORDS.put("피자", "피자");
        SEARCH_KEYWORDS.put("패스트푸드", "패스트푸드");
        SEARCH_KEYWORDS.put("분식", "분식");
        SEARCH_KEYWORDS.put("베이커리", "베이커리");
        
        // 매칭 키워드 초기화
        MATCHING_KEYWORDS.put("한식", Arrays.asList("한식", "한국", "김치", "불고기", "비빔밥", "갈비", "국밥", "찌개"));
        MATCHING_KEYWORDS.put("카페", Arrays.asList("카페", "커피", "coffee", "cafe", "스타벅스", "이디야", "투썸", "카페베네"));
        MATCHING_KEYWORDS.put("일식", Arrays.asList("일식", "초밥", "라멘", "돈까스", "우동", "일본", "사시미", "덮밥"));
        MATCHING_KEYWORDS.put("중식", Arrays.asList("중식", "중국", "짜장", "짬뽕", "탕수육", "마라", "깐풍", "볶음밥"));
        MATCHING_KEYWORDS.put("양식", Arrays.asList("양식", "스테이크", "파스타", "이탈리안", "western", "피자", "햄버거"));
        MATCHING_KEYWORDS.put("치킨", Arrays.asList("치킨", "닭", "chicken", "bbq", "굽네", "교촌", "후라이드"));
        MATCHING_KEYWORDS.put("피자", Arrays.asList("피자", "pizza", "도미노", "피자헛", "미스터피자", "파파존스"));
        MATCHING_KEYWORDS.put("패스트푸드", Arrays.asList("패스트", "버거", "햄버거", "맥도날드", "kfc", "롯데리아", "버거킹"));
        MATCHING_KEYWORDS.put("분식", Arrays.asList("분식", "떡볶이", "순대", "김밥", "튀김", "어묵", "컵밥"));
        MATCHING_KEYWORDS.put("베이커리", Arrays.asList("베이커리", "빵집", "제과", "bakery", "파리바게뜨", "뚜레쥬르", "던킨"));
    }
    
    // 모든 카테고리 목록 반환
    public List<String> getAllCategories() {
        return new ArrayList<>(SEARCH_KEYWORDS.keySet());
    }
    
    // 카테고리별 검색 키워드 반환
    public String getSearchKeyword(String category) {
        return SEARCH_KEYWORDS.getOrDefault(category, category);
    }
    
    // 카테고리별 매칭 키워드 목록 반환
    public List<String> getMatchingKeywords(String category) {
        return MATCHING_KEYWORDS.getOrDefault(category, Arrays.asList(category.toLowerCase()));
    }
    
    // 가게 카테고리가 선택된 카테고리와 매치되는지 확인
    public boolean isMatching(String storeCategory, String selectedCategory) {
        if ("전체".equals(selectedCategory)) {
            return true;
        }
        
        List<String> keywords = getMatchingKeywords(selectedCategory);
        String storeCat = storeCategory.toLowerCase();
        
        return keywords.stream()
                .anyMatch(keyword -> storeCat.contains(keyword.toLowerCase()));
    }
    
    // 카테고리 정보를 JSON 형태로 반환 (프론트엔드용)
    public Map<String, Object> getCategoryConfig() {
        Map<String, Object> config = new HashMap<>();
        config.put("searchKeywords", SEARCH_KEYWORDS);
        config.put("matchingKeywords", MATCHING_KEYWORDS);
        config.put("categories", getAllCategories());
        return config;
    }
} 