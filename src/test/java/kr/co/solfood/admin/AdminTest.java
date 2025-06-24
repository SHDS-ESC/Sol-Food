package kr.co.solfood.admin;

import kr.co.solfood.admin.dto.ChartRequestDTO;
import kr.co.solfood.admin.home.AdminHomeService;
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
import java.util.Optional;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = {config.MvcConfig.class})
@WebAppConfiguration
public class AdminTest {

    @Autowired
    AdminMapper adminMapper;

    @Autowired
    LoginMapper loginMapper;

    @Autowired
    private AdminHomeService adminHomeService;

    @Test
    @DisplayName("유저 홈 리스트 조회 (전체)테스트")
    public void getUsersListAll() {
        List<UserVO> list = adminMapper.getUsers("");
        assumeTrue(!list.isEmpty());
    }

    @Test
    @DisplayName("유저 홈 리스트 검색 (특정 쿼리)테스트")
    public void getUsersSize() {
        Optional<UserVO> list = adminMapper.getUsers("박지원").stream().findFirst();
        assertTrue(list.isPresent());
    }

    @Test
    @DisplayName("유저 홈 리스트 검색 (특정 쿼리)테스트 - 리스트 검색 결과 검증")
    public void getUsersName() {
        String name = "박지원";
        List<UserVO> list = adminMapper.getUsers(name);
        assertFalse(list.isEmpty(), "검색 결과가 비어있으면 안됩니다.");
        assertEquals(name, list.get(0).getUsersName(), "검색된 사용자의 이름이 일치해야 합니다.");
    }

    @Test
    @DisplayName("차트 데이터 조회 테스트 - 연간/월간/일간")
    public void getChartData() {
        List<ChartRequestDTO> yearList = adminHomeService.userManagementChart("연간");
        assertFalse(yearList.isEmpty(), "연간 차트 데이터가 비어있으면 안됩니다.");

        List<ChartRequestDTO> monthList = adminHomeService.userManagementChart("월간");
        assertFalse(monthList.isEmpty(), "월간 차트 데이터가 비어있으면 안됩니다.");

        List<ChartRequestDTO> dayList = adminHomeService.userManagementChart("일간");
        assertFalse(dayList.isEmpty(), "일간 차트 데이터가 비어있으면 안됩니다.");
    }
}
