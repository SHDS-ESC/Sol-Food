package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.*;
import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.util.PageMaker;

import java.util.List;

public interface AdminHomeService {
    PageMaker<UserSearchResponseDTO> getUsers(UserSearchRequestDTO userSearchRequestDTO);

    List<ChartRequestDTO> userManagementChart(String date);

    PageMaker<OwnerSearchResponseDTO> getOwners(OwnerSearchDTO ownerSearchRequestDTO);

    void updateOwnerStatus(OwnerStatusUpdateDTO ownerStatusUpdateDTO);
}
