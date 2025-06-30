package kr.co.solfood.payments.charge;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.solfood.payments.common.PaymentCommonMapper;
import kr.co.solfood.user.login.UserVO;

@Service
@Transactional(rollbackFor = Exception.class)
public class ChargeServiceImpl implements ChargeService {
    private final ChargeMapper chargeMapper;

    public ChargeServiceImpl(ChargeMapper chargeMapper) {
        this.chargeMapper = chargeMapper;
    }

    @Override
    public PaymentCommonMapper getMapper() {
        return chargeMapper;
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
        int offset = (page - 1) * size;
        return chargeMapper.getChargeHistory(usersId, offset, size);
    }   

    // 취소/환불 관련 메서드 구현
    @Override
    public ChargeVO getChargeByImpUid(String impUid) {
        return chargeMapper.getChargeByImpUid(impUid);
    }

    @Override
    public void updateCharge(ChargeVO chargeVO) {
        chargeMapper.updateCharge(chargeVO);
    }

}
