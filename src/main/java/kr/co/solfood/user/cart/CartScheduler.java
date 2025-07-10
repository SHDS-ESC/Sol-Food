package kr.co.solfood.user.cart;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.util.Map;

@Slf4j
@Component
public class CartScheduler {

    @Autowired
    private CartController cartController;

    /**
     * 매 10분마다 만료된 pending 결제 정리
     */
    @Scheduled(fixedRate = 600000) // 10분 = 600,000ms
    public void cleanupExpiredPayments() {
        try {
            log.info("만료된 결제 정리 스케줄러 시작");
            cartController.cleanupExpiredPayments();
            log.info("만료된 결제 정리 스케줄러 완료");
        } catch (Exception e) {
            log.error("만료된 결제 정리 스케줄러 오류: {}", e.getMessage());
        }
    }
    
    /**
     * 매 5분마다 타임아웃된 더치페이 자동 취소 (참여자 응답 대기)
     */
    @Scheduled(fixedRate = 300000) // 5분 = 300,000ms
    public void processTimeoutDutchPayments() {
        try {
            log.info("타임아웃 더치페이 처리 스케줄러 시작");
            int timeoutMinutes = 15;
            ResponseEntity<Map<String, Object>> response = cartController.processTimeoutDutchPayments(timeoutMinutes);
            Object value = response.getBody().get("cancelledCount");
            int cancelledCount = value != null ? ((Number)value).intValue() : 0;
            log.info("타임아웃 더치페이 처리 스케줄러 완료: {}건 취소", cancelledCount);
        } catch (Exception e) {
            log.error("타임아웃 더치페이 처리 스케줄러 오류: {}", e.getMessage());
        }
    }
} 