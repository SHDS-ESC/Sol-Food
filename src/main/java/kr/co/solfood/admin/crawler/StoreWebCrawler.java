package kr.co.solfood.admin.crawler;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import kr.co.solfood.user.category.CategoryService;
import kr.co.solfood.user.store.CategoryProperties;
import kr.co.solfood.user.store.StoreService;
import kr.co.solfood.user.store.StoreVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import properties.KakaoProperties;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Component
public class StoreWebCrawler {

    @Autowired
    private StoreService storeService;
    
    @Autowired
    private CategoryProperties categoryProperties;
    
    @Autowired
    private CategoryService categoryService;
    
    @Autowired
    private KakaoProperties kakaoProperties;

    // 카카오 Local API URL
    private static final String KAKAO_LOCAL_API_URL = "https://dapi.kakao.com/v2/local/search/keyword.json";

    /**
     * 홍대입구역 주변 음식점 크롤링
     */
    public List<StoreVO> crawlHongdaeRestaurants() {
        List<StoreVO> restaurantList = new ArrayList<>();
        
        try {
            // 홍대입구역 좌표 (위도: 37.5565, 경도: 126.9241)
            double hongdaeLat = 37.5565;
            double hongdaeLng = 126.9241;
            
            // CategoryProperties에서 카테고리 목록 가져오기 ("전체" 제외)
            List<String> allCategories = categoryProperties.getAllCategories();
            List<String> categories = allCategories.stream()
                    .filter(category -> !"전체".equals(category))
                    .collect(java.util.stream.Collectors.toList());
            
            for (String category : categories) {
                log.info("크롤링 중: {} 카테고리", category);
                List<StoreVO> categoryRestaurants = searchRestaurantsByCategory(category, hongdaeLat, hongdaeLng);
                restaurantList.addAll(categoryRestaurants);
                
                // API 호출 제한을 위한 딜레이
                Thread.sleep(1000);
            }
            
            log.info("총 {}개 음식점 정보 수집 완료!", restaurantList.size());
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return restaurantList;
    }

    /**
     * 카테고리별 음식점 검색
     */
    private List<StoreVO> searchRestaurantsByCategory(String category, double lat, double lng) {
        List<StoreVO> stores = new ArrayList<>();
        
        try {
            // CategoryProperties에서 검색 키워드 가져오기
            String searchKeyword = categoryProperties.getSearchKeyword(category);
            String query = URLEncoder.encode(searchKeyword + " 음식점", "UTF-8");
            String urlString = KAKAO_LOCAL_API_URL + 
                "?query=" + query + 
                "&category_group_code=FD6" + // 음식점 카테고리 코드
                "&x=" + lng + 
                "&y=" + lat + 
                "&radius=1000" + // 1km 반경
                "&size=15"; // 최대 15개 결과
            
            URL url = new URL(urlString);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            
            // 요청 헤더 설정
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Authorization", "KakaoAK " + kakaoProperties.getRestApiKey());
            connection.setRequestProperty("Content-Type", "application/json");
            
            // 응답 확인
            int responseCode = connection.getResponseCode();
            if (responseCode == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();
                
                // JSON 파싱
                stores = parseKakaoResponse(response.toString(), category);
                
            } else {
                log.error("API 호출 실패: {}", responseCode);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return stores;
    }

    /**
     * 카카오 API 응답 JSON 파싱
     */
    private List<StoreVO> parseKakaoResponse(String jsonResponse, String category) {
        List<StoreVO> stores = new ArrayList<>();
        
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(jsonResponse);
            JsonNode documents = root.get("documents");
            
            if (documents != null && documents.isArray()) {
                for (JsonNode document : documents) {
                    StoreVO store = new StoreVO();
                    
                    // 기본 정보 설정
                    store.setStoreName(document.get("place_name").asText());
                    
                    // 카테고리 설정 - 표준화된 카테고리 사용
                    String originalCategory = document.get("category_name").asText();
                    String standardCategory = mapToStandardCategory(originalCategory, category);
                    
                    // 카테고리 ID 설정
                    Integer categoryId = categoryService.getCategoryIdByName(standardCategory);
                    store.setCategoryId(categoryId);
                    store.setStoreCategory(standardCategory);
                    
                    store.setStoreAddress(document.get("road_address_name").asText());
                    
                    // 좌표 설정
                    store.setStoreLatitude(Double.parseDouble(document.get("y").asText()));
                    store.setStoreLongitude(Double.parseDouble(document.get("x").asText()));
                    
                    // 전화번호 설정
                    String phone = document.get("phone").asText();
                    store.setStoreTel(phone.isEmpty() ? "정보없음" : phone);
                    
                    // 기본값 설정
                    store.setStoreAvgstar(0); // 초기 별점
                    store.setStoreIntro("홍대입구역 주변 " + category + " 맛집"); // 기본 소개
                    store.setStoreMainimage("/img/default-restaurant.jpg"); // 기본 이미지
                    
                    stores.add(store);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return stores;
    }

    /**
     * 카카오 API 카테고리를 표준 카테고리로 매핑
     */
    private String mapToStandardCategory(String originalCategory, String searchCategory) {
        if (originalCategory == null || originalCategory.isEmpty()) {
            return searchCategory; // 기본값으로 검색 카테고리 사용
        }
        
        // 카카오 API 카테고리를 소문자로 변환하여 분석
        String lowerCategory = originalCategory.toLowerCase();
        
        // CategoryProperties를 활용한 스마트 매핑
        List<String> allCategories = categoryProperties.getAllCategories();
        
        for (String category : allCategories) {
            if ("전체".equals(category)) continue;
            
            // 해당 카테고리의 매칭 키워드들을 확인
            List<String> matchingKeywords = categoryProperties.getMatchingKeywords(category);
            
            for (String keyword : matchingKeywords) {
                if (lowerCategory.contains(keyword.toLowerCase())) {
                    return category; // 매칭되는 표준 카테고리 반환
                }
            }
        }
        
        // 매칭되지 않으면 검색 카테고리 사용
        return searchCategory;
    }

    /**
     * 크롤링한 데이터를 데이터베이스에 저장
     */
    public void saveCrawledData() {
        try {
            log.info("홍대입구역 주변 음식점 크롤링 시작...");
            
            List<StoreVO> restaurants = crawlHongdaeRestaurants();
            
            log.info("데이터베이스 저장 시작...");
            int savedCount = 0;
            
            for (StoreVO restaurant : restaurants) {
                try {
                    // 중복 체크 (같은 이름과 주소의 가게가 있는지 확인)
                    if (!storeService.isDuplicateStore(restaurant)) {
                        // 실제 저장 로직
                        if (storeService.insertStore(restaurant)) {
                            savedCount++;
                            log.debug("저장 완료: {}", restaurant.getStoreName());
                        } else {
                            log.warn("저장 실패: {}", restaurant.getStoreName());
                        }
                    } else {
                        log.debug("중복 건너뜀: {}", restaurant.getStoreName());
                    }
                } catch (Exception e) {
                    log.error("저장 실패: {} - {}", restaurant.getStoreName(), e.getMessage());
                }
            }
            
            log.info("크롤링 완료! 총 {}개 음식점 저장됨", savedCount);
            
        } catch (Exception e) {
            log.error("크롤링 중 오류 발생: {}", e.getMessage(), e);
        }
    }

    /**
     * 특정 키워드로 음식점 검색 (추가 기능)
     */
    public List<StoreVO> searchByKeyword(String keyword, double lat, double lng, int radius) {
        List<StoreVO> stores = new ArrayList<>();
        
        try {
            // 키워드가 카테고리인지 확인하고 해당하는 검색 키워드 사용
            String searchKeyword = categoryProperties.getSearchKeyword(keyword);
            String query = URLEncoder.encode(searchKeyword, "UTF-8");
            String urlString = KAKAO_LOCAL_API_URL + 
                "?query=" + query + 
                "&category_group_code=FD6" +
                "&x=" + lng + 
                "&y=" + lat + 
                "&radius=" + radius + 
                "&size=15";
            
            URL url = new URL(urlString);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setRequestProperty("Authorization", "KakaoAK " + kakaoProperties.getRestApiKey());
            
            if (connection.getResponseCode() == 200) {
                BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                StringBuilder response = new StringBuilder();
                String line;
                
                while ((line = reader.readLine()) != null) {
                    response.append(line);
                }
                reader.close();
                
                stores = parseKakaoResponse(response.toString(), keyword);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return stores;
    }
} 