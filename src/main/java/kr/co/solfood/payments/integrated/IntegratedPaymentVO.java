package kr.co.solfood.payments.integrated;

import java.sql.Timestamp;

import lombok.Data;

/**
 * 통합 결제 테이블 VO
 */
@Data
public class IntegratedPaymentVO {
    private int integratedpaymentId;               // PK
    private int storeId;                           // Store FK

    private long integratedpaymentLeaderId;        // 결제 발의자 ID
    private int integratedpaymentAmount;          // 총 결제 금액
    private int integratedpaymentPeople;          // 총 결제 인원
    private String integratedpaymentStatus;       // 총 결제 상태

    private Timestamp integratedpaymentCreatedAt;
    private Timestamp integratedpaymentUpdatedAt;

    @Override
    public String toString() {
        return "IntegratedPaymentVO{" +
                "integratedpaymentId=" + integratedpaymentId +
                ", storeId=" + storeId +
                ", integratedpaymentLeaderId=" + integratedpaymentLeaderId +
                ", integratedpaymentAmount=" + integratedpaymentAmount +
                ", integratedpaymentPeople=" + integratedpaymentPeople +
                ", integratedpaymentStatus='" + integratedpaymentStatus + '\'' +
                ", integratedpaymentCreatedAt=" + integratedpaymentCreatedAt +
                ", integratedpaymentUpdatedAt=" + integratedpaymentUpdatedAt +
                '}';
    }
}
