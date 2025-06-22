package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.ChartRequestDTO;
import kr.co.solfood.admin.dto.OwnerSearchRequestDTO;
import kr.co.solfood.user.login.UserVO;

import java.util.List;

public interface AdminHomeService {
    List<UserVO> getUsers(String query);

    List<ChartRequestDTO> userManagementChart(String date);

    List<OwnerSearchRequestDTO> getOwners(String query);
}
