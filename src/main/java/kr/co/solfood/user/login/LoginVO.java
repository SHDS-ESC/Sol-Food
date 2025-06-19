package kr.co.solfood.user.login;

import lombok.Data;

@Data
public class LoginVO {
    private long usersId;
    private int companyId;
    private int departmentId;
    private String usersEmail; // 이메일
    private String usersPwd; // 비밀번호
    private String usersNickname; // 닉네임
    private String usersProfile; // 프로필
    private String usersName; // 이름
    private int usersPoint; // 포인트
    private String usersGender;
    private String accessToken;
    private long usersKakaoId;
    private String usersTel;
    private String usersCreatedAt;
    private String usersUpdatedAt;
    private String usersStatus;
    private String usersLoginType;
}
