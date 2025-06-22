package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.ChartRequestDTO;
import kr.co.solfood.admin.dto.OwnerSearchRequestDTO;
import kr.co.solfood.user.login.UserVO;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.resource.ResourceUrlProvider;

import java.util.List;

@Service
public class AdminHomeServiceImpl implements AdminHomeService {

    private final AdminMapper adminMapper;

    public AdminHomeServiceImpl(AdminMapper adminMapper) {
        this.adminMapper = adminMapper;
    }

    @Override
    public List<UserVO> getUsers(String query) {
        return adminMapper.getUsers(query);
    }

    @Override
    public List<ChartRequestDTO> userManagementChart(String date) {
        switch (date) {
            case "월간":
                return adminMapper.userManagementChartByMonths();
            case "일간":
                return adminMapper.userManagementChartByDays();
            case "연간":
            default:
                return adminMapper.userManagementChartByYears();
        }
    }

    @Override
    public List<OwnerSearchRequestDTO> getOwners(String query) {
        return adminMapper.getOwners(query);
    }

}
