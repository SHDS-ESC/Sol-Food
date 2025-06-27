package kr.co.solfood.admin.login;

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
            throw new IllegalArgumentException("잘못된 비밀번호 입니다.");
        }
        return adminVO;
    }
}
