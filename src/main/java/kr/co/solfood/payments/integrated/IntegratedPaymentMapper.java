package kr.co.solfood.payments.integrated;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface IntegratedPaymentMapper {
    
    // 통합 결제 생성
    int insertIntegratedPayment(IntegratedPaymentVO integratedPayment);
    
    // ID로 통합 결제 조회
    IntegratedPaymentVO selectIntegratedPaymentById(@Param("integratedPaymentId") int integratedPaymentId);
    
    // 발의자 ID로 통합 결제 조회
    IntegratedPaymentVO selectIntegratedPaymentByLeaderId(@Param("leaderId") long leaderId);
    
    // 통합 결제 상태 업데이트
    int updatePaymentStatus(@Param("integratedPaymentId") int integratedPaymentId, @Param("status") String status);
    
    // 만료된 pending 결제 정리 (30분 이상)
    int cleanupExpiredPendingPayments();
    
    // 만료된 pending 결제들 조회 (30분 이상)
    List<IntegratedPaymentVO> selectExpiredPendingPayments();
    
    // 타임아웃된 결제들 조회 (지정된 시간 이상)
    List<IntegratedPaymentVO> selectTimeoutPayments(@Param("timeoutMinutes") int timeoutMinutes);
} 