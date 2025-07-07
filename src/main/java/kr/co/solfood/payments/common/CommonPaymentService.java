package kr.co.solfood.payments.common;

import org.springframework.stereotype.Service;


@Service
public interface CommonPaymentService {

    public CommonPaymentMapper getMapper();

    // 중복 결제 방지 (imp_uid 중복 체크)
    default public boolean isAlreadyProcessed(String imp_uid) {
        return getMapper().isAlreadyProcessed(imp_uid);
    }
    
}