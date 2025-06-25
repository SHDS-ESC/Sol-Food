package kr.co.solfood.payments.payment;

import kr.co.solfood.payments.common.PaymentCommonService;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.solfood.user.login.UserVO;

@Service
@Transactional(rollbackFor = Exception.class)
public class PaymentServiceImpl implements PaymentService {

    private final PaymentCommonService paymentCommonService;
    private final PaymentMapper paymentMapper;

    public PaymentServiceImpl(PaymentCommonService paymentCommonService, PaymentMapper paymentMapper) {
        this.paymentCommonService = paymentCommonService;
        this.paymentMapper = paymentMapper;
    }

    // 중복 충전 방지 (imp_uid 중복 체크)
    @Override
    public boolean isAlreadyProcessed(String imp_uid) {
        return paymentCommonService.isAlreadyProcessed(paymentMapper, imp_uid);
    }

    // imp_uid 기록
    @Override
    public void saveProcessedImpUid(String imp_uid) {
        paymentCommonService.saveProcessedImpUid(paymentMapper, imp_uid);
    }

    // 포인트 적립 (트랜잭션 처리)
    @Override
    public void updateUserPoint(UserVO user) {
        paymentMapper.updateUserPoint(user);
    }

    // Payment 내역 조회
    @Override
    public List<PaymentVO> getPaymentHistory(long usersId, int page, int size) {
        return paymentMapper.getPaymentHistory(usersId, page, size);
    }
    
}
