package kr.co.solfood.payments.integrated;

import kr.co.solfood.user.cart.BillDTO;

public interface IntegratedPaymentService {
    // 통합 결제 생성
    int createIntegratedPayment(BillDTO billDTO);
    
    // 통합 결제 조회
    IntegratedPaymentVO getIntegratedPaymentById(int integratedPaymentId);
    
    // 발의자별 통합 결제 조회
    IntegratedPaymentVO getIntegratedPaymentByLeaderId(long leaderId);
} 