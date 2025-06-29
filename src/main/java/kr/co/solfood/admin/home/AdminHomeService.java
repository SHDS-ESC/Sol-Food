package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.*;
import kr.co.solfood.user.store.StoreVO;
import kr.co.solfood.util.PageMaker;

import java.util.List;

public interface AdminHomeService {
    PageMaker<UserSearchResponseDTO> getUsers(UserSearchRequestDTO userSearchRequestDTO);

    List<ChartRequestDTO> userManagementChart(String date);

    PageMaker<OwnerSearchResponseDTO> getOwners(OwnerSearchDTO ownerSearchRequestDTO);

    void updateStoreStatus(StoreStatusUpdateDTO storeStatusUpdateDTO);

    OwnerSearchResponseDTO detailStoreInfo(String ownerId);
}
