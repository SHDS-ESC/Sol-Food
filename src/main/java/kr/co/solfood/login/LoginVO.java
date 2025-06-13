package kr.co.solfood.login;

import lombok.Data;

@Data
public class LoginVO {
    private int usersId;         // PK
    private int companyId;       // FK
    private int departmentId;    // FK
    private String usersEmail;      // Unique or FK
    private String usersNickname;   // Unique or FK
    private String usersProfile;
    private String usersName;
    private int usersPoint;
    private int usersAge;
    private String usersGender;
    private String accessToken;
}
