package kr.co.solfood.admin.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import kr.co.solfood.util.PageDTO;
import lombok.Data;

@Data
public class PaymentSearchRequestDto extends PageDTO {
    @JsonFormat(pattern = "yyyy-MM-dd") // 시작 검색 날짜
    private String fromDate;
    @JsonFormat(pattern = "yyyy-MM-dd") // 종료 검색 날짜
    private String toDate;
    private String paymentMethod; // 결제 수단
    private String query; // 검색어
    private String tableType; // 테이블 타입 (충전, 결제)


    String[] paymentTableHeaderList = {"결제 아이디", "금액", "결제 수단", "PG사", "영수증 URL", "결제 상태"};

    String[] chargeTableHeaderList = {"충전 아이디", "금액", "결제 수단", "PG사", "영수증 URL", "충전 상태"};
}
