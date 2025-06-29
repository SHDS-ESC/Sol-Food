package kr.co.solfood.admin.login;

public interface AdminLoginService {
    /**
     * 관리자 로그인
     * @param password 로그인 요청 DTO
     * @return 로그인 성공 시 관리자 정보, 실패 시 null
     */
    AdminVO login(String password);
}
