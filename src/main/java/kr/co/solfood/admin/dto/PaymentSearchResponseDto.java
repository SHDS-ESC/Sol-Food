package kr.co.solfood.admin.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import kr.co.solfood.payments.common.CommonPaymentVO;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class PaymentSearchResponseDto {
    private String paymentId; // 결제 아이디
    private String usersName; // 결제한 유저 이름
    private long paymentPaidAmount; // 금액
    private long paymentUsedPoint; // 사용 포인트
    private String paymentMethod; // 결제 수단
    private String paymentPgProvider; // PG사
    private String paymentStatus; // 결제 상태
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime paymentCreatedAt; // 결제 생성일
    private String paymentReceiptUrl; // 영수증 URL
}
