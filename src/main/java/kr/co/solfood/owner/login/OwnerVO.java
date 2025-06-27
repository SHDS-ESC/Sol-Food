package kr.co.solfood.owner.login;

import lombok.Data;

@Data
public class OwnerVO {
    private int ownerId; // 점주 아이디
    private int storeId; // 상점 아이디
    private String ownerEmail; // 이메일
    private String ownerPwd; // 비밀번호
    private String ownerTel; // 전화번호
    private String ownerStatus; // 상태
}