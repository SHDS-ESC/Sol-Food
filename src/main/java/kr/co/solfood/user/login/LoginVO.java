package kr.co.solfood.user.login;

import lombok.Data;

@Data
public class LoginVO {
    private long usersId;
    private int companyId;
    private int departmentId;
    private String usersEmail;
    private String usersNickname;
    private String usersProfile;
    private String usersName;
    private int usersPoint;
    private String usersGender;
    private String accessToken;
    private long usersKakaoId;
    private String usersTel;
    private String usersCreatedAt;
    private String usersUpdatedAt;
    private String usersStatus;
    private String usersLoginType;
}
