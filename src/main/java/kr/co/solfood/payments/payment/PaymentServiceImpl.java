package kr.co.solfood.payments.payment;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.solfood.payments.common.CommonPaymentMapper;
import kr.co.solfood.user.login.UserVO;

@Service
@Transactional(rollbackFor = Exception.class)
public class PaymentServiceImpl implements PaymentService {

    private final PaymentMapper paymentMapper;

    public PaymentServiceImpl(PaymentMapper paymentMapper) {
        this.paymentMapper = paymentMapper;
    }

    @Override
    public CommonPaymentMapper getMapper() {
        return paymentMapper;
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
