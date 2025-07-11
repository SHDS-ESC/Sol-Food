package kr.co.solfood.admin.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class PaymentDistinctResponseDto {
    // payment 테이블
    private Long paymentId;
    private Long usersId;
    private Long integratedpaymentId;
    private Integer paymentUsedPoint;
    private Integer paymentPaidAmount;
    private String paymentImpUid;
    private String paymentMerchantUid;
    private String paymentMethod;
    private String paymentPgProvider;
    private String paymentPgTid;
    private String paymentReceiptUrl;
    private String paymentStatus;
    private String paymentStatusDetail;
    private Integer paymentAmount;
    private Integer paymentCancelAmount;
    private String paymentBuyerName;
    private String paymentBuyerEmail;
    private String paymentBuyerTel;
    private String paymentFailReason;
    private String paymentCancelReason;
    private LocalDateTime paymentPaidAt;
    private LocalDateTime paymentCancelledAt;
    private LocalDateTime paymentCreatedAt;
    private LocalDateTime paymentUpdatedAt;

    // users 테이블
    private String usersName;
    private String usersNickname;
    private String usersEmail;
    private String usersProfile;
    private Integer usersPoint;
    private String usersGender;
    private String usersLoginType;
    private String usersTel;
    private String usersStatus;
    private String usersRejectedReason;
}
