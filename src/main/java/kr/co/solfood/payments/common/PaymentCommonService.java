package kr.co.solfood.payments.common;

import org.springframework.stereotype.Service;


@Service
public interface PaymentCommonService {
    // 중복 결제 방지 (imp_uid 중복 체크)
    public boolean isAlreadyProcessed(String imp_uid);
    
    // imp_uid 기록
    public void saveProcessedImpUid(String imp_uid);
    
}