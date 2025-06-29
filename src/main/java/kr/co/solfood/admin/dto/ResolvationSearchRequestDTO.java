package kr.co.solfood.admin.dto;

import kr.co.solfood.util.PageDTO;
import lombok.Data;

@Data
public class ResolvationSearchRequestDTO extends PageDTO {
    String query;
    String date;
    String paymentType;
    String status;
}
