package kr.co.solfood.user.login;

import lombok.Data;

@Data
public class SearchPwdRequest {
    private String usersEmail; // 이메일
    private String usersName; // 이름 
    private String usersPwd; // 임시 비밀번호 저장용 필드 추가
}
