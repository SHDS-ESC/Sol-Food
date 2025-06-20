package kr.co.solfood.admin;

import kr.co.solfood.admin.home.AdminMapper;
import kr.co.solfood.user.login.LoginMapper;
import kr.co.solfood.user.login.UserVO;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = {configuration.MvcConfig.class})
@WebAppConfiguration
public class AdminTest {

    @Autowired
    AdminMapper adminMapper;

    @Autowired
    LoginMapper loginMapper;

    @Test
    @DisplayName("유저 홈 리스트 조회 (전체)테스트")
    public void getUsersListAll() {
        List<UserVO> list = adminMapper.getUsers("");
        assumeTrue(!list.isEmpty());
    }

    @Test
    @DisplayName("유저 홈 리스트 검색 (특정 쿼리)테스트 - 리스트 수 반환")
    public void getUsersSize() {
        List<UserVO> list = adminMapper.getUsers("박지원");
        assertEquals(1, list.size());
    }

    @Test
    @DisplayName("유저 홈 리스트 검색 (특정 쿼리)테스트 - 리스트 검색 결과 검증")
    public void getUsersName() {
        String name = "안민석";
        List<UserVO> list = adminMapper.getUsers(name);
        assertEquals(name, list.get(0).getUsersName());
    }

}
