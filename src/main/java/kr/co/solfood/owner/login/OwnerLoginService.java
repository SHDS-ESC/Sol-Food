package kr.co.solfood.owner.login;

public interface OwnerLoginService {
    // 회원가입
    OwnerVO register(OwnerVO vo);

    // 로그인
    OwnerVO login(OwnerVO vo);
}
