package kr.co.solfood.owner.login;

import lombok.Data;

@Data
public class OwnerVO {
    private long ownerId;
    private long storeId;
    private String ownerEmail;
    private String ownerPwd;
    private String ownerTel;
    private String ownerStatus;
}