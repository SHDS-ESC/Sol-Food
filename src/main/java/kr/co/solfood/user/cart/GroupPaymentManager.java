package kr.co.solfood.user.cart;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import kr.co.solfood.user.cart.CartConstants;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.Set;
import java.util.HashSet;
import java.util.List;
import java.util.ArrayList;
import java.util.concurrent.CopyOnWriteArrayList;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * 그룹 결제 상태 관리 및 실시간 알림 처리
 */
@Slf4j
@Component
public class GroupPaymentManager {
    

    
    // 그룹별 결제 상태 관리 (integratedPaymentId -> GroupPaymentState)
    private final Map<Integer, GroupPaymentState> groupStates = new ConcurrentHashMap<>();
    
    /**
     * 그룹 결제 상태 정보
     */
    public static class GroupPaymentState {
        private int integratedPaymentId;
        private Set<Long> participantIds;
        private Map<Long, String> paymentStatus; // userId -> status (pending, paid, failed, cancelled)
        private String groupStatus; // active, completed, cancelled
        private long leaderId;
        
        public GroupPaymentState(int integratedPaymentId, long leaderId, Set<Long> participantIds) {
            this.integratedPaymentId = integratedPaymentId;
            this.leaderId = leaderId;
            this.participantIds = new HashSet<>(participantIds);
            this.paymentStatus = new ConcurrentHashMap<>();
            this.groupStatus = "active";
            
            // 모든 참여자를 pending 상태로 초기화
            for (Long participantId : participantIds) {
                this.paymentStatus.put(participantId, "pending");
            }
        }
        
        // Getters and Setters
        public int getIntegratedPaymentId() { return integratedPaymentId; }
        public Set<Long> getParticipantIds() { return participantIds; }
        public Map<Long, String> getPaymentStatus() { return paymentStatus; }
        public String getGroupStatus() { return groupStatus; }
        public long getLeaderId() { return leaderId; }
        
        public void setGroupStatus(String groupStatus) { this.groupStatus = groupStatus; }
        
        /**
         * 모든 결제가 완료되었는지 확인
         */
        public boolean isAllPaymentsCompleted() {
            return paymentStatus.values().stream()
                    .allMatch(status -> "paid".equals(status) || CartConstants.PAYMENT_STATUS_COMPLETED.equals(status) || "free".equals(status));
        }
        
        /**
         * 결제 완료된 참여자 수 반환
         */
        public int getCompletedPaymentCount() {
            return (int) paymentStatus.values().stream()
                    .filter(status -> "paid".equals(status) || CartConstants.PAYMENT_STATUS_COMPLETED.equals(status) || "free".equals(status))
                    .count();
        }
    }
    

    
    /**
     * 그룹 결제 상태 등록
     */
    public void registerGroupPayment(int integratedPaymentId, long leaderId, Set<Long> participantIds) {
        GroupPaymentState state = new GroupPaymentState(integratedPaymentId, leaderId, participantIds);
        groupStates.put(integratedPaymentId, state);
        log.info("그룹 결제 등록: integratedPaymentId={}, leaderId={}", 
                integratedPaymentId, leaderId);
    }
    

    
    /**
     * 결제 상태 업데이트 및 알림 전송
     */
    public void updatePaymentStatus(int integratedPaymentId, long userId, String status) {
        GroupPaymentState state = groupStates.get(integratedPaymentId);
        if (state == null) {
            log.warn("그룹 결제 상태를 찾을 수 없음: integratedPaymentId={}", integratedPaymentId);
            return;
        }
        
        // 결제 상태 업데이트
        state.getPaymentStatus().put(userId, status);
        log.info("결제 상태 업데이트: integratedPaymentId={}, userId={}", 
                integratedPaymentId, userId);
        
        // 그룹 상태 확인 및 업데이트
        checkAndUpdateGroupStatus(state);
        
        // 모든 참여자에게 알림 전송
        notifyGroupParticipants(state, "payment_status_update", Map.of(
                "integratedPaymentId", integratedPaymentId,
                "userId", userId,
                "status", status,
                "completedCount", state.getCompletedPaymentCount(),
                "totalCount", state.getParticipantIds().size(),
                "groupStatus", state.getGroupStatus()
        ));
    }
    
    /**
     * 그룹 결제 취소
     */
    public void cancelGroupPayment(int integratedPaymentId, long cancelledByUserId) {
        GroupPaymentState state = groupStates.get(integratedPaymentId);
        if (state == null) {
            log.warn("그룹 결제 상태를 찾을 수 없음: integratedPaymentId={}", integratedPaymentId);
            return;
        }
        
        // 그룹 상태를 cancelled로 변경
        state.setGroupStatus("cancelled");
        log.info("그룹 결제 취소: integratedPaymentId={}, cancelledBy={}", integratedPaymentId, cancelledByUserId);
        
        // 모든 참여자에게 취소 알림 전송
        notifyGroupParticipants(state, "group_payment_cancelled", Map.of(
                "integratedPaymentId", integratedPaymentId,
                "cancelledByUserId", cancelledByUserId,
                "groupStatus", "cancelled"
        ));
    }
    
    /**
     * 그룹 결제 완료
     */
    public void completeGroupPayment(int integratedPaymentId) {
        GroupPaymentState state = groupStates.get(integratedPaymentId);
        if (state == null) {
            log.warn("그룹 결제 상태를 찾을 수 없음: integratedPaymentId={}", integratedPaymentId);
            return;
        }
        
        // 그룹 상태를 completed로 변경
        state.setGroupStatus("completed");
        log.info("그룹 결제 완료: integratedPaymentId={}", integratedPaymentId);
        
        // 모든 참여자에게 완료 알림 전송
        notifyGroupParticipants(state, "group_payment_completed", Map.of(
                "integratedPaymentId", integratedPaymentId,
                "groupStatus", "completed"
        ));
    }
    
    /**
     * 그룹 상태 확인 및 업데이트
     */
    private void checkAndUpdateGroupStatus(GroupPaymentState state) {
        if ("active".equals(state.getGroupStatus()) && state.isAllPaymentsCompleted()) {
            state.setGroupStatus("completed");
            log.info("모든 결제 완료로 그룹 상태 변경: integratedPaymentId={}", state.getIntegratedPaymentId());
            
            // 완료 알림 전송
            notifyGroupParticipants(state, "group_payment_completed", Map.of(
                    "integratedPaymentId", state.getIntegratedPaymentId(),
                    "groupStatus", "completed"
            ));
        }
    }
    
    /**
     * 그룹 참여자들에게 알림 전송 (폴링 방식이므로 로그만 출력)
     */
    private void notifyGroupParticipants(GroupPaymentState state, String eventType, Map<String, Object> data) {
        log.info("그룹 알림: eventType={}, participants={}", 
                eventType, state.getParticipantIds().size());
    }
    
    /**
     * 그룹 결제 상태 조회
     */
    public GroupPaymentState getGroupPaymentState(int integratedPaymentId) {
        return groupStates.get(integratedPaymentId);
    }
    
    /**
     * 사용자가 참여한 그룹 결제 ID 조회
     */
    public Integer getParticipantGroupPaymentId(long userId) {
        for (Map.Entry<Integer, GroupPaymentState> entry : groupStates.entrySet()) {
            if (entry.getValue().getParticipantIds().contains(userId)) {
                return entry.getKey();
            }
        }
        return null;
    }
    
    /**
     * 그룹 결제 상태 제거
     */
    public void removeGroupPayment(int integratedPaymentId) {
        groupStates.remove(integratedPaymentId);
        log.info("그룹 결제 상태 제거: integratedPaymentId={}", integratedPaymentId);
    }
    
    /**
     * 만료된 연결 정리 (폴링 방식이므로 불필요)
     */
    public void cleanupExpiredConnections() {
        log.info("폴링 방식이므로 연결 정리 불필요");
    }
} 