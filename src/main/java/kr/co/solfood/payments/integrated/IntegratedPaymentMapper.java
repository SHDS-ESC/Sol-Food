package kr.co.solfood.payments.integrated;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface IntegratedPaymentMapper {
    
    // 통합 결제 생성
    int insertIntegratedPayment(IntegratedPaymentVO integratedPayment);
    
    // ID로 통합 결제 조회
    IntegratedPaymentVO selectIntegratedPaymentById(@Param("integratedPaymentId") int integratedPaymentId);
    
    // 발의자 ID로 통합 결제 조회
    IntegratedPaymentVO selectIntegratedPaymentByLeaderId(@Param("leaderId") long leaderId);
} 