package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.*;
import kr.co.solfood.user.login.UserVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AdminMapper {
    List<UserSearchResponseDTO> getUsers(UserSearchRequestDTO userSearchRequestDTO);

    int getUsersCount(UserSearchRequestDTO userSearchRequestDTO);

    List<ChartRequestDTO> userManagementChartByYears();

    List<ChartRequestDTO> userManagementChartByMonths();

    List<ChartRequestDTO> userManagementChartByDays();

    List<OwnerSearchResponseDTO> getOwners(OwnerSearchDTO ownerSearchRequestDTO);

    int getOwnersCount(OwnerSearchDTO ownerSearchRequestDTO);
}
