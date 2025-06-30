package kr.co.solfood.payments.payment;

import java.util.List;

import kr.co.solfood.payments.common.PaymentCommonService;
import kr.co.solfood.user.login.UserVO;

public interface PaymentService extends PaymentCommonService {
    // 포인트 적립 (트랜잭션 처리)
    void updateUserPoint(UserVO user);
    // Payment 내역 조회
    List<PaymentVO> getPaymentHistory(long usersId, int page, int size);
}
