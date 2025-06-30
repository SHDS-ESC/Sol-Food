package kr.co.solfood.admin.home;

import kr.co.solfood.user.login.UserVO;
import org.springframework.stereotype.Service;

import java.util.List;

public interface AdminHomeService {
    List<UserVO> getUsers(String query);
}
