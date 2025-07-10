package kr.co.solfood.admin.dto;

import kr.co.solfood.util.PageDTO;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Data
public class PaymentSearchRequestDto extends PageDTO {
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime fromDate;
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime toDate;
    private String paymentMethod; // 결제 수단
    private String query; // 검색어
    private String tableType; // 테이블 타입 (충전, 결제)
    private String paymentStatus; // 결제 상태


    String[] paymentTableHeaderList = {"결제 아이디", "금액", "결제 수단", "PG사", "영수증 URL", "결제 상태"};

    String[] chargeTableHeaderList = {"충전 아이디", "금액", "결제 수단", "PG사", "영수증 URL", "충전 상태"};
}
