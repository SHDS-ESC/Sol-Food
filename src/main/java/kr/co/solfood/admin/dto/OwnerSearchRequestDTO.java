package kr.co.solfood.admin.dto;

import kr.co.solfood.util.PageDTO;
import lombok.Data;


@Data
public class OwnerSearchRequestDTO extends PageDTO {
    String query;
}


