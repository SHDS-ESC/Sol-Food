package kr.co.solfood.admin.dto;

import lombok.Data;

import java.util.List;

@Data
public class UserStatusUpdateDTO {
    long usersId;
    String usersStatus;
    String usersRejectReason;

    public UserStatusUpdateDTO(long usersId, String usersStatus, String usersRejectReason) {
        this.usersId = usersId;
        this.usersRejectReason = usersRejectReason;
        setUsersStatus(usersStatus);  // 직접 호출
    }

    public void setUsersStatus(String usersStatus) {
        List<String> validStatus = List.of("active", "inactive");
        if (validStatus.contains(usersStatus)) {
            this.usersStatus = usersStatus;
        } else {
            this.usersStatus = "error";
        }
    }
}
