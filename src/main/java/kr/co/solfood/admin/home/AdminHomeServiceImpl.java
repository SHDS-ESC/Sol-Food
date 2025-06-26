package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.*;
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
        return new PageMaker<>(userSearchResponseDTO, size, userSearchRequestDTO.getPageSize(), userSearchRequestDTO.getCurrentPage());
    }

    @Override
    public PageMaker<OwnerSearchResponseDTO> getOwners(OwnerSearchDTO ownerSearchRequestDTO) {
        List<OwnerSearchResponseDTO> ownerSearchResponseDTO = adminMapper.getOwners(ownerSearchRequestDTO);
        int size = adminMapper.getOwnersCount(ownerSearchRequestDTO);
        return new PageMaker<>(ownerSearchResponseDTO, size, ownerSearchRequestDTO.getPageSize(), ownerSearchRequestDTO.getCurrentPage());
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
    @Transactional
    public void updateOwnerStatus(OwnerStatusUpdateDTO ownerStatusUpdateDTO) {
        // 1) ID 검증
        if (ownerStatusUpdateDTO.getOwnerId() <= 0) {
            throw new IllegalArgumentException("유효하지 않은 ownerId 입니다.");
        }
        // 2) 상태 검증
        List<String> valid = List.of("승인완료", "승인대기", "승인거절");
        if (!valid.contains(ownerStatusUpdateDTO.getOwnerStatus())) {
            throw new IllegalArgumentException("유효하지 않은 ownerStatus 입니다.");
        }
        // 3) 실제 업데이트
        int updated = adminMapper.updateOwnerStatus(ownerStatusUpdateDTO);
        if (updated == 0) {
            throw new IllegalArgumentException("유효하지 않은 ownerStatus 입니다.");
        }
    }

}
