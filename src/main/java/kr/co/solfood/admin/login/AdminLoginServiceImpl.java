package kr.co.solfood.admin.login;

import kr.co.solfood.util.CustomException;
import kr.co.solfood.util.ErrorCode;
import org.springframework.stereotype.Service;

@Service
public class AdminLoginServiceImpl implements AdminLoginService {
    
    // 임시 관리자 패스워드 (실제 환경에서는 암호화된 패스워드를 DB에서 조회해야 함)
    private static final String ADMIN_PASSWORD = "admin123";
    
    @Override
    public AdminVO login(String password) throws CustomException {
        if (password == null || password.trim().isEmpty()) {
            throw new CustomException(ErrorCode.PASSWORD_NOT_FOUND);
        }
        
        if (!ADMIN_PASSWORD.equals(password)) {
            throw new CustomException(ErrorCode.UNAUTHORIZED);
        }
        
        // 인증 성공 시 AdminVO 객체 반환
        AdminVO adminVO = new AdminVO();
        adminVO.setAdminId(1L);
        adminVO.setAdminEmail("admin@solfood.co.kr");
        adminVO.setAdminStatus("ACTIVE");
        
        return adminVO;
    }
} 