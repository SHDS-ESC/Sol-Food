package kr.co.solfood.payments.charge;

import kr.co.solfood.payments.common.CommonPaymentVO;
import lombok.Data;

@Data
public class ChargeVO extends CommonPaymentVO {
    private int chargeId;                // 충전 PK
    private int usersId;                 // 충전한 사용자 ID
}
