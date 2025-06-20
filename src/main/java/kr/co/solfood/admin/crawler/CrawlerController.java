package kr.co.solfood.admin.crawler;

import kr.co.solfood.user.store.StoreVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/crawler")
public class CrawlerController {

    @Autowired
    private StoreWebCrawler webCrawler;

    // 크롤링 관리 페이지
    @GetMapping("")
    public String crawlerPage() {
        return "admin/crawler"; // admin/crawler.jsp 페이지
    }

    // 홍대입구역 주변 음식점 크롤링 실행
    @GetMapping("/start-hongdae")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> startHongdaeCrawling() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            System.out.println("=== 홍대입구역 음식점 크롤링 시작 ===");
            
            // 비동기로 크롤링 실행
            new Thread(() -> {
                webCrawler.saveCrawledData();
            }).start();
            
            response.put("status", "success");
            response.put("message", "홍대입구역 주변 음식점 크롤링이 시작되었습니다. 콘솔을 확인해주세요.");
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "크롤링 실행 중 오류가 발생했습니다: " + e.getMessage());
            
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 특정 키워드로 음식점 크롤링 (테스트용)
    @GetMapping("/search")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> searchRestaurants(
            String keyword, 
            Double lat, 
            Double lng, 
            Integer radius) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 기본값 설정
            if (lat == null) lat = 37.5565; // 홍대입구역 위도
            if (lng == null) lng = 126.9241; // 홍대입구역 경도
            if (radius == null) radius = 1000; // 1km
            if (keyword == null) keyword = "음식점";
            
            List<StoreVO> restaurants = webCrawler.searchByKeyword(keyword, lat, lng, radius);
            
            response.put("status", "success");
            response.put("keyword", keyword);
            response.put("count", restaurants.size());
            response.put("restaurants", restaurants);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "검색 중 오류가 발생했습니다: " + e.getMessage());
            
            return ResponseEntity.badRequest().body(response);
        }
    }

    // 크롤링 상태 확인
    @GetMapping("/status")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCrawlingStatus() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 현재는 간단한 상태만 반환
            response.put("status", "ready");
            response.put("message", "크롤링 시스템이 준비되었습니다.");
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("status", "error");
            response.put("message", "상태 확인 중 오류가 발생했습니다.");
            
            return ResponseEntity.badRequest().body(response);
        }
    }
} 