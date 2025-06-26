package kr.co.solfood.payments.common;

import lombok.Data;

@Data
public abstract class PaymentCommonVO {
    // 아임포트 Payment 객체에서 주로 사용하는 필드들
    protected String impUid;           // 아임포트 결제 고유번호
    protected String merchantUid;      // 가맹점 주문번호
    protected String payMethod;        // 결제수단
    protected String pgProvider;       // PG사
    protected String pgTid;            // PG사 거래번호
    protected String receiptUrl;       // 영수증 URL

    protected String status;           // 결제 상태 (paid, failed, cancelled 등)
    protected String statusDetail;     // 결제 상태 상세 (실패/취소/환불 등 상세 사유)
    protected Integer amount;          // 결제/충전 금액
    protected Integer cancelAmount;    // 환불 금액

    protected String buyerName;        // 구매자 이름
    protected String buyerEmail;       // 구매자 이메일
    protected String buyerTel;         // 구매자 연락처

    protected String failReason;       // 결제 실패 사유
    protected String cancelReason;     // 결제 취소/환불 사유

    protected java.sql.Timestamp paidAt;        // 결제 일시
    protected java.sql.Timestamp cancelledAt;   // 환불 일시
    protected java.sql.Timestamp createdAt;     // 레코드 생성일시
    protected java.sql.Timestamp updatedAt;     // 레코드 수정일시

    /**
     * 실제로 취소되었는지 확인 (1970-01-01이 아닌 경우)
     */
    public boolean isActuallyCancelled() {
        return cancelledAt != null && cancelledAt.getTime() > 0;
    }
}
