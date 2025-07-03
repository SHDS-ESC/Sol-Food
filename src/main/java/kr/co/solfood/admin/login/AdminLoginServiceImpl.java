package kr.co.solfood.admin.login;

import kr.co.solfood.util.CustomException;
import kr.co.solfood.util.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminLoginServiceImpl implements AdminLoginService {

    private final AdminLoginMapper adminLoginMapper;

    @Autowired
    AdminLoginServiceImpl(AdminLoginMapper adminLoginMapper) {
        this.adminLoginMapper = adminLoginMapper;
    }

    @Override
    public AdminVO login(String password) {
        AdminVO adminVO = adminLoginMapper.login(password);
        if (adminVO == null) {
            throw new CustomException(ErrorCode.PASSWORD_NOT_FOUND);
        }
        return adminVO;
    }
}
