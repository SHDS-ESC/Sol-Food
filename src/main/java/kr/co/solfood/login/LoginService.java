package kr.co.solfood.login;

public interface LoginService {
    LoginVO confirmAccessToken(String code);
    void kakaoLogin(LoginVO vo);
}
