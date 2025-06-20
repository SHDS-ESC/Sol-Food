package kr.co.solfood.user.login;

import java.util.List;

public interface LoginService {
    // 액세스 토큰 확인 후 VO 반환
    UserVO confirmAccessToken(String code);

    // 회원 가입 루트 로그인
    UserVO register(UserVO vo);

    // 카카오 최초 로그인 확인 (소셜 로그인 전용)
    boolean confirmKakaoLoginWithFirst(UserVO vo);

    // 회사 리스트
    List<CompanyVO> getCompanyList();

    // 회사 > 부서 리스트
    List<DepartmentVO> getDepartmentsByCompanyId(int companyId);

    // 자체로그인
    UserVO nativeLogin(LoginRequest req);

    // 비밀번호 찾기
    UserVO searchPwd(SearchPwdRequest req);

    // 비밀번호 찾기 > 새로운 비밀번호 저장
    void setNewPwd(SearchPwdRequest req);
}
