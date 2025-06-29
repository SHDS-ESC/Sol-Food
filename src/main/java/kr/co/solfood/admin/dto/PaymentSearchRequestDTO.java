package kr.co.solfood.admin.dto;

import kr.co.solfood.util.PageDTO;
import lombok.Data;

@Data
public class PaymentSearchRequestDTO extends PageDTO {
    String query;
    String date;
    String paymentType;
    String status;
}
