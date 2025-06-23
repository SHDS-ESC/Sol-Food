package kr.co.solfood.common.s3;

import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class RateLimitService {
    
    // 메모리 캐시 (빠른 접근용)
    private final Map<String, List<Long>> requestTracker = new ConcurrentHashMap<>();
    
    // 파일 기반 지속성 저장소
    private final String CACHE_FILE_PATH = System.getProperty("java.io.tmpdir") + "/solfood-rate-limit.cache";
    
    // 제한 설정
    private static final int MAX_REQUESTS_PER_MINUTE = 10;
    private static final long CLEANUP_INTERVAL = 5 * 60 * 1000; // 5분
    
    @PostConstruct
    public void initialize() {
        loadFromFile();
        
        // 백그라운드 정리 스레드
        Timer cleanupTimer = new Timer("RateLimit-Cleanup", true);
        cleanupTimer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                cleanupExpiredEntries();
                saveToFile();
            }
        }, CLEANUP_INTERVAL, CLEANUP_INTERVAL);
        
        System.out.println("✅ Rate Limit 서비스 초기화 완료 (파일 기반 캐시)");
    }
    
    /**
     * 🚀 개선된 Rate Limiting 검증 (파일 기반 지속성)
     */
    public boolean isRateLimited(String clientIP) {
        long now = System.currentTimeMillis();
        List<Long> requests = requestTracker.computeIfAbsent(clientIP, k -> new ArrayList<>());
        
        // 1분(60초) 이전 요청 기록 제거
        requests.removeIf(time -> now - time > 60000);
        
        // 분당 최대 요청 수 초과 시 차단
        if (requests.size() >= MAX_REQUESTS_PER_MINUTE) {
            System.out.println("🚫 Rate Limit 차단: IP " + clientIP + " (" + requests.size() + "회)");
            return true;
        }
        
        // 현재 요청 시간 기록
        requests.add(now);
        
        return false;
    }
    
    /**
     * 파일에서 Rate Limit 데이터 로드
     */
    private void loadFromFile() {
        try {
            Path path = Paths.get(CACHE_FILE_PATH);
            if (!Files.exists(path)) {
                System.out.println("Rate Limit 캐시 파일이 없음 - 새로 시작");
                return;
            }
            
            try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(CACHE_FILE_PATH))) {
                @SuppressWarnings("unchecked")
                Map<String, List<Long>> loadedData = (Map<String, List<Long>>) ois.readObject();
                
                // 만료되지 않은 데이터만 로드
                long now = System.currentTimeMillis();
                for (Map.Entry<String, List<Long>> entry : loadedData.entrySet()) {
                    List<Long> validRequests = new ArrayList<>();
                    for (Long requestTime : entry.getValue()) {
                        if (now - requestTime <= 60000) { // 1분 이내만 유효
                            validRequests.add(requestTime);
                        }
                    }
                    if (!validRequests.isEmpty()) {
                        requestTracker.put(entry.getKey(), validRequests);
                    }
                }
                
                System.out.println("✅ Rate Limit 캐시 로드 완료: " + requestTracker.size() + "개 IP");
            }
        } catch (Exception e) {
            System.err.println("⚠️ Rate Limit 캐시 로드 실패 (새로 시작): " + e.getMessage());
        }
    }
    
    /**
     * Rate Limit 데이터를 파일에 저장
     */
    private void saveToFile() {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(CACHE_FILE_PATH))) {
            Map<String, List<Long>> dataToSave = new HashMap<>();
            
            // 유효한 데이터만 저장
            long now = System.currentTimeMillis();
            for (Map.Entry<String, List<Long>> entry : requestTracker.entrySet()) {
                List<Long> validRequests = new ArrayList<>();
                for (Long requestTime : entry.getValue()) {
                    if (now - requestTime <= 60000) { // 1분 이내만 저장
                        validRequests.add(requestTime);
                    }
                }
                if (!validRequests.isEmpty()) {
                    dataToSave.put(entry.getKey(), validRequests);
                }
            }
            
            oos.writeObject(dataToSave);
            System.out.println("💾 Rate Limit 캐시 저장 완료: " + dataToSave.size() + "개 IP");
        } catch (Exception e) {
            System.err.println("❌ Rate Limit 캐시 저장 실패: " + e.getMessage());
        }
    }
    
    /**
     * 만료된 엔트리 정리
     */
    private void cleanupExpiredEntries() {
        long now = System.currentTimeMillis();
        Iterator<Map.Entry<String, List<Long>>> iterator = requestTracker.entrySet().iterator();
        
        while (iterator.hasNext()) {
            Map.Entry<String, List<Long>> entry = iterator.next();
            List<Long> requests = entry.getValue();
            
            // 만료된 요청 제거
            requests.removeIf(time -> now - time > 60000);
            
            // 빈 리스트는 엔트리 자체를 제거
            if (requests.isEmpty()) {
                iterator.remove();
            }
        }
        
        System.out.println("🧹 Rate Limit 정리 완료: " + requestTracker.size() + "개 IP 유지");
    }
} 