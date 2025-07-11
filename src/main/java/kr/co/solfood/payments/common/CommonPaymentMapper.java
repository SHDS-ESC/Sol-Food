package kr.co.solfood.payments.common;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.solfood.payments.charge.ChargeVO;
import kr.co.solfood.payments.payment.PaymentVO;

@Mapper
public interface CommonPaymentMapper {
    // 중복 결제 방지 (imp_uid 중복 체크)
    boolean isAlreadyProcessed(String imp_uid);
    
    // 충전 취소 후 업데이트
    boolean updateChargeAfterCancel(@Param("imp_uid") String imp_uid, 
                                   @Param("cancel_amount") Integer cancel_amount, 
                                   @Param("cancel_reason") String cancel_reason);
    
    // 결제 취소 후 업데이트
    boolean updatePaymentAfterCancel(@Param("imp_uid") String imp_uid, 
                                    @Param("cancel_amount") Integer cancel_amount, 
                                    @Param("cancel_reason") String cancel_reason);
    
    // 자동 타입 감지하여 취소 후 업데이트
    boolean updateAnyPaymentAfterCancel(@Param("imp_uid") String imp_uid, 
                                       @Param("cancel_amount") Integer cancel_amount, 
                                       @Param("cancel_reason") String cancel_reason);
    
    // 충전 정보 조회
    ChargeVO getChargeByImpUid(String imp_uid);
    
    // 결제 정보 조회
    PaymentVO getPaymentByImpUid(String imp_uid);
    
    // 자동 타입 감지하여 결제 정보 조회 (충전 우선)
    ChargeVO getAnyPaymentByImpUid(String imp_uid);
    
    // 충전 취소 시 사용자 포인트 차감
    boolean updateUserPointAfterChargeCancel(@Param("users_id") Integer users_id, 
                                            @Param("deduct_amount") int deduct_amount);
}
