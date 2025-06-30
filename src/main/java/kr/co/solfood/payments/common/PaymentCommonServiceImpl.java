package kr.co.solfood.payments.common;

import org.springframework.stereotype.Service;

@Service
public class PaymentCommonServiceImpl implements PaymentCommonService {

    private final PaymentCommonMapper paymentCommonMapper;

    public PaymentCommonServiceImpl(PaymentCommonMapper paymentCommonMapper) {
        this.paymentCommonMapper = paymentCommonMapper;
    }

    @Override
    public boolean isAlreadyProcessed(String imp_uid) {
        throw new UnsupportedOperationException("isAlreadyProcessed requires domain-specific mapper. Not supported in CommonServiceImpl.");
    }

    @Override
    public void saveProcessedImpUid(String imp_uid) {
        throw new UnsupportedOperationException("saveProcessedImpUid requires domain-specific mapper. Not supported in CommonServiceImpl.");
    }

    
}
