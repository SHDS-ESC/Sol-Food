package kr.co.solfood.admin.home;

import kr.co.solfood.user.login.UserVO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AdminHomeServiceImpl implements  AdminHomeService {

    private final AdminMapper adminMapper;

    public AdminHomeServiceImpl(AdminMapper adminMapper) {
        this.adminMapper = adminMapper;
    }

    @Override
    public List<UserVO> getUsers(String query) {
        return adminMapper.getUsers(query);
    }
}
