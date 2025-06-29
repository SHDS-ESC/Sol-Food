package kr.co.solfood.admin.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
public class OwnerStatusUpdateDTO {
    long ownerId;
    String ownerStatus;

    public OwnerStatusUpdateDTO(long ownerId, String ownerStatus) {
        this.ownerId = ownerId;
        setOwnerStatus(ownerStatus);  // 직접 호출
    }

    public void setOwnerStatus(String ownerStatus) {
        List<String> validStatus = List.of("승인완료", "승인대기", "승인거절");
        if (validStatus.contains(ownerStatus)) {
            this.ownerStatus = ownerStatus;
        } else {
            this.ownerStatus = "승인거절";
        }
    }
}
