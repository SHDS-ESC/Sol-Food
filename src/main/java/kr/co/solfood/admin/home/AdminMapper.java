package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.*;
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

    int updateStoreStatus(StoreStatusUpdateDTO storeStatusUpdateDTO);

    OwnerSearchResponseDTO detailStoreInfo(String ownerId);
}
