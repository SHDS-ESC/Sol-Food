package kr.co.solfood.payments.payment;

import kr.co.solfood.payments.common.CommonPaymentVO;
import lombok.Data;

/**
 * 개인 결제 테이블 VO
 */
@Data
public class PaymentVO extends CommonPaymentVO {
    private int paymentId;              // 결제 PK
    private int usersId;                // 결제한 유저 ID (FK)
    private int integratedpaymentId;    // 통합 결제 ID (FK)
    private int paymentUsedPoint;       // 결제 시 사용한 포인트
    private int paymentPaidAmount;      // 결제 시 실제 결제한 금액
    private boolean hasReview;          // 리뷰 작성 여부
}
