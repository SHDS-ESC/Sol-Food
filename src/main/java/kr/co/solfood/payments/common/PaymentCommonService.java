package kr.co.solfood.payments.common;

import org.springframework.stereotype.Service;


@Service
public class PaymentCommonService {
    // 중복 결제 방지 (imp_uid 중복 체크)
    public boolean isAlreadyProcessed(PaymentCommonMapper paymentCommonMapper, String imp_uid) {
        return paymentCommonMapper.isAlreadyProcessed(imp_uid);
    }
    
    // imp_uid 기록
    public void saveProcessedImpUid(PaymentCommonMapper paymentCommonMapper, String imp_uid) {
        paymentCommonMapper.saveProcessedImpUid(imp_uid);
    }
    
}