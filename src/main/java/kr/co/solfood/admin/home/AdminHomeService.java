package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.ChartRequestDTO;
import kr.co.solfood.admin.dto.OwnerSearchDTO;
import kr.co.solfood.admin.dto.OwnerSearchResponseDTO;
import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.util.PageMaker;

import java.util.List;

public interface AdminHomeService {
    List<UserVO> getUsers(String query);

    List<ChartRequestDTO> userManagementChart(String date);

    PageMaker<OwnerSearchResponseDTO> getOwners(OwnerSearchDTO ownerSearchRequestDTO);
}
