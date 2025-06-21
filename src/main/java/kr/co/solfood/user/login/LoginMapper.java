package kr.co.solfood.user.login;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface LoginMapper {
    // 회원 가입
    int register(UserVO vo);

    // DB 내의 카카오 유저 중복 여부 확인
    UserVO kakaoLogin(long id);

    // 회사 리스트 가져오기
    List<CompanyVO> selectAllCompanies();

    // 회사 > 부서 리스트 가져오기
    List<DepartmentVO> getDepartmentsByCompanyId(int companyId);

    // 로그인
    UserVO selectUser(LoginRequest req);

    // 비밀번호 찾기
    UserVO searchPwd(SearchPwdRequest req);

    // 새로운 비밀번호 저장
    void setNewPwd(SearchPwdRequest req);
}
