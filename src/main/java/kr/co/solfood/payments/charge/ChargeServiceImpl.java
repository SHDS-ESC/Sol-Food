package kr.co.solfood.payments.charge;

import kr.co.solfood.payments.common.PaymentCommonService;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.solfood.user.login.UserVO;

@Service
@Transactional(rollbackFor = Exception.class)
public class ChargeServiceImpl implements ChargeService {

    private final PaymentCommonService paymentCommonService;
    private final ChargeMapper chargeMapper;

    public ChargeServiceImpl(PaymentCommonService paymentCommonService, ChargeMapper chargeMapper) {
        this.paymentCommonService = paymentCommonService;
        this.chargeMapper = chargeMapper;
    }

    // 중복 충전 방지 (imp_uid 중복 체크)
    @Override
    public boolean isAlreadyProcessed(String imp_uid) {
        return paymentCommonService.isAlreadyProcessed(chargeMapper, imp_uid);
    }

    // imp_uid 기록
    @Override
    public void saveProcessedImpUid(String imp_uid) {
        paymentCommonService.saveProcessedImpUid(chargeMapper, imp_uid);
    }

    // 포인트 적립 (트랜잭션 처리)
    @Override
    public void updateUserPoint(UserVO user) {
        chargeMapper.updateUserPoint(user);
    }

    @Override
    public void insertCharge(ChargeVO vo) {
        chargeMapper.insertCharge(vo);
    }

    @Override
    public List<ChargeVO> getChargeHistory(long usersId, int page, int size) {
        return chargeMapper.getChargeHistory(usersId, page, size);
    }

}
