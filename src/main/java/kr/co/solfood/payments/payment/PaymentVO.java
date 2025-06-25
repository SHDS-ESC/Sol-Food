package kr.co.solfood.payments.payment;

import lombok.Data;

@Data
public class PaymentVO extends kr.co.solfood.payments.common.PaymentCommonVO {
    private int paymentId;              // 결제 PK
    private int storeId;                // 결제한 가게 ID
    private int usersId;                // 결제한 사용자 ID
    private int paymentPrice;           // 결제 금액
    private int paymentPeople;          // 결제 인원

    private String paymentProductName;  // 결제 상품명
    private String paymentType;         // 결제 타입(충전/구매/정기결제 등)
}
