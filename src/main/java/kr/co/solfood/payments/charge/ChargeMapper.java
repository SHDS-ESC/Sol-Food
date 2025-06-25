package kr.co.solfood.payments.charge;

import kr.co.solfood.payments.common.PaymentCommonMapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.co.solfood.user.login.UserVO;

@Mapper
public interface ChargeMapper extends PaymentCommonMapper {
    // 포인트 적립 (트랜잭션 처리)
    void updateUserPoint(UserVO user);
    // Charge 기록
    void insertCharge(ChargeVO vo);
    // Charge 내역 조회
    List<ChargeVO> getChargeHistory(long usersId, int page, int size);
}
