package kr.co.solfood.admin.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class OwnerStatusUpdateDTO {
    long ownerId;
    String ownerStatus;
}
