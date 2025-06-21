package kr.co.solfood.user.login;

import lombok.Data;

@Data
public class LoginRequest {
    private String usersEmail;
    private String usersPwd;
}
