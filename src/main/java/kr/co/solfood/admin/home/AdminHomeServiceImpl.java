package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.*;
import kr.co.solfood.util.CustomException;
import kr.co.solfood.util.ErrorCode;
import kr.co.solfood.util.PageMaker;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AdminHomeServiceImpl implements AdminHomeService {

    private final AdminMapper adminMapper;

    public AdminHomeServiceImpl(AdminMapper adminMapper) {
        this.adminMapper = adminMapper;
    }

    @Override
    public PageMaker<UserSearchResponseDTO> getUsers(UserSearchRequestDTO userSearchRequestDTO) {
        List<UserSearchResponseDTO> userSearchResponseDTO = adminMapper.getUsers(userSearchRequestDTO);
        int size = adminMapper.getUsersCount(userSearchRequestDTO);

        if (userSearchResponseDTO == null) {
            throw new CustomException(ErrorCode.UNDEFINED_SEARCH);
        }
        return new PageMaker<>(userSearchResponseDTO, size, userSearchRequestDTO.getPageSize(), userSearchRequestDTO.getCurrentPage());
    }

    @Override
    public PageMaker<OwnerSearchResponseDTO> getOwners(OwnerSearchDTO ownerSearchRequestDTO) {
        List<OwnerSearchResponseDTO> ownerSearchResponseDTO = adminMapper.getOwners(ownerSearchRequestDTO);
        int size = adminMapper.getOwnersCount(ownerSearchRequestDTO);

        if (ownerSearchRequestDTO == null) {
            throw new CustomException(ErrorCode.UNDEFINED_SEARCH);
        }
        return new PageMaker<>(ownerSearchResponseDTO, size, ownerSearchRequestDTO.getPageSize(), ownerSearchRequestDTO.getCurrentPage());
    }

    @Override
    public List<ChartRequestDTO> userManagementChart(String date) {
        if(date == null || date.isEmpty()) {
            throw new CustomException(ErrorCode.INCORRECT_DATE_FORMAT);
        }

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
    @Transactional
    public void updateStoreStatus(StoreStatusUpdateDTO storeStatusUpdateDTO) {
        // 1) ID 검증
        if (storeStatusUpdateDTO.getOwnerId() <= 0) {
            throw new IllegalArgumentException("유효하지 않은 ownerId 입니다.");
        }

        // 3) 업데이트
        int updated = adminMapper.updateStoreStatus(storeStatusUpdateDTO);
        if (updated == 0) {
            throw new IllegalArgumentException("유효하지 않은 storeStatusUpdateDTO 입니다.");
        }
    }

    @Override
    public OwnerSearchResponseDTO detailStoreInfo(String ownerId) {
        OwnerSearchResponseDTO ownerSearchResponseDTO = adminMapper.detailStoreInfo(ownerId);
        if (ownerId == null || ownerSearchResponseDTO == null) {
            throw new CustomException(ErrorCode.UNDEFINED_SEARCH);
        }
        return ownerSearchResponseDTO;
    }
}
