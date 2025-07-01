package kr.co.solfood.payments.common;

import org.springframework.stereotype.Service;

@Service
public class CommonPaymentServiceImpl implements CommonPaymentService {

    private final CommonPaymentMapper commonPaymentMapper;

    public CommonPaymentServiceImpl(CommonPaymentMapper commonPaymentMapper) {
        this.commonPaymentMapper = commonPaymentMapper;
    }


    @Override
    public CommonPaymentMapper getMapper() {
        return commonPaymentMapper;
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
