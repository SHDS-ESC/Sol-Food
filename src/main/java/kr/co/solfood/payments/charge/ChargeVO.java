package kr.co.solfood.payments.charge;

import kr.co.solfood.payments.common.PaymentCommonVO;
import lombok.Data;

@Data
public class ChargeVO extends PaymentCommonVO {
    private int chargeId;                // 충전 PK
    private int usersId;                 // 충전한 사용자 ID
}
