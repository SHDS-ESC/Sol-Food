package kr.co.solfood.admin.login;

import lombok.Data;

@Data
public class AdminVO {
    private long adminId;
    private String adminEmail;
    private String adminPwd;
    private String adminTel;
    private String adminStatus;
}