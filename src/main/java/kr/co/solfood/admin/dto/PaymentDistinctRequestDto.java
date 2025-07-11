package kr.co.solfood.admin.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import kr.co.solfood.util.PageDTO;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class PaymentDistinctRequestDto extends PageDTO {
    private String integratedpaymentId; // 통합 결제 아이디
}
