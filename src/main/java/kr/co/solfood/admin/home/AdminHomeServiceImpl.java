package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.*;
import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.util.PageMaker;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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
        return new PageMaker<>(ownerSearchResponseDTO,size,ownerSearchRequestDTO.getPageSize(),ownerSearchRequestDTO.getCurrentPage());
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

}
