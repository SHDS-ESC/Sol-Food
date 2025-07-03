package kr.co.solfood.admin.dto;

import lombok.Data;

import java.util.List;

@Data
public class StoreStatusUpdateDTO {
    long ownerId;
    String storeStatus;
    String storeRejectReason;

    public StoreStatusUpdateDTO(long ownerId, String storeStatus, String storeRejectReason) {
        this.storeRejectReason = storeRejectReason;
        this.ownerId = ownerId;
        setStoreStatus(storeStatus);  // 직접 호출
    }

    public void setStoreStatus(String storeStatus) {
        List<String> validStatus = List.of("승인완료", "승인대기", "승인거절");
        if (validStatus.contains(storeStatus)) {
            this.storeStatus = storeStatus;
        } else {
            this.storeStatus = "승인거절";
        }
    }
}
