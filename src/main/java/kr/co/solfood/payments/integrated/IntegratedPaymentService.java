package kr.co.solfood.payments.integrated;

import kr.co.solfood.user.cart.BillDTO;

public interface IntegratedPaymentService {
    // 통합 결제 생성
    int createIntegratedPayment(BillDTO billDTO);
    
    // 통합 결제 조회
    IntegratedPaymentVO getIntegratedPaymentById(int integratedPaymentId);
    
    // 발의자별 통합 결제 조회
    IntegratedPaymentVO getIntegratedPaymentByLeaderId(long leaderId);
    
    // 통합 결제 상태 업데이트 (개별)
    void updatePaymentStatus(int integratedPaymentId, String status);
    
    // 만료된 pending 결제 정리 (30분 이상) - 개별
    int cleanupExpiredPendingPayments();
    
    // === 더치페이 전체 관리 메서드 ===
    
    /**
     * 더치페이 전체 상태 업데이트 (통합결제 + 개별결제들)
     */
    void updateDutchPayStatus(int integratedPaymentId, String status);
    
    /**
     * 더치페이 전체 정리 (통합결제 + 개별결제들)
     */
    int cleanupExpiredDutchPayments();
    
    /**
     * 더치페이 성공 처리 (통합결제 + 개별결제들)
     */
    void processDutchPaySuccess(int integratedPaymentId);
    
    /**
     * 더치페이 실패 처리 (통합결제 + 개별결제들)
     */
    void processDutchPayFailed(int integratedPaymentId, String failReason);
    
    /**
     * 더치페이 취소 처리 (통합결제 + 개별결제들)
     */
    void processDutchPayCancelled(int integratedPaymentId, String cancelReason);
    
    /**
     * 타임아웃 기반 자동 취소 (참여자 응답 대기 시간 초과)
     */
    int processTimeoutDutchPayments(int timeoutMinutes);
    
    /**
     * 특정 더치페이의 참여자 응답 상태 확인
     */
    boolean checkDutchPayParticipantResponses(int integratedPaymentId);
} 