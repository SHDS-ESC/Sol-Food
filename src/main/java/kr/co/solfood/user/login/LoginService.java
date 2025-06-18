package kr.co.solfood.user.login;

public interface LoginService {
    // 액세스 토큰 확인 후 VO 반환
    LoginVO confirmAccessToken(String code);

    // 회원 가입 루트 로그인
    LoginVO register(LoginVO vo);

    // 카카오 가입 루트 로그인
    //LoginVO addRegister(LoginVO vo);

    // 카카오 최초 로그인 확인 (소셜 로그인 전용)
    boolean confirmKakaoLoginWithFirst(LoginVO vo);
}
