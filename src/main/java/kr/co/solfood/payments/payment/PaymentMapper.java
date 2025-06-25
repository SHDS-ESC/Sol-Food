package kr.co.solfood.payments.payment;

import java.util.List;

import kr.co.solfood.payments.common.PaymentCommonMapper;
import org.apache.ibatis.annotations.Mapper;

import kr.co.solfood.user.login.UserVO;

@Mapper
public interface PaymentMapper extends PaymentCommonMapper {
    // 포인트 적립 (트랜잭션 처리)
    void updateUserPoint(UserVO user);
    // Payment 내역 조회
    List<PaymentVO> getPaymentHistory(long usersId, int page, int size);
}
