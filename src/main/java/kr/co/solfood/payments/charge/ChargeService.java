package kr.co.solfood.payments.charge;

import java.util.List;

import kr.co.solfood.payments.common.CommonPaymentService;
import kr.co.solfood.user.login.UserVO;

public interface ChargeService extends CommonPaymentService {

    // 포인트 적립 (트랜잭션 처리)
    void updateUserPoint(UserVO user);
    // Charge 기록
    void insertCharge(ChargeVO vo);
    // Charge 내역 조회
    List<ChargeVO> getChargeHistory(long usersId, int page, int size);
    
    // 취소/환불 관련 메서드
    ChargeVO getChargeByImpUid(String impUid);
    void updateCharge(ChargeVO chargeVO);
}
