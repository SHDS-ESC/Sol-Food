package kr.co.solfood.payments.charge;

import java.util.List;

import kr.co.solfood.user.login.UserVO;

public interface ChargeService {

    // 중복 충전 방지 (imp_uid 중복 체크)
    boolean isAlreadyProcessed(String imp_uid);
    // 포인트 적립 (트랜잭션 처리)
    void updateUserPoint(UserVO user);
    // imp_uid 기록
    void saveProcessedImpUid(String imp_uid);
    // Charge 기록
    void insertCharge(ChargeVO vo);
    // Charge 내역 조회
    List<ChargeVO> getChargeHistory(long usersId, int page, int size);
    
    // 취소/환불 관련 메서드
    ChargeVO getChargeByImpUid(String impUid);
    void updateCharge(ChargeVO chargeVO);
}
