package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.ChartRequestDTO;
import kr.co.solfood.admin.dto.OwnerSearchDTO;
import kr.co.solfood.admin.dto.OwnerSearchResponseDTO;
import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.util.PageMaker;
import org.springframework.stereotype.Service;

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
    public PageMaker<OwnerSearchResponseDTO> getOwners(OwnerSearchDTO ownerSearchRequestDTO) {
        List<OwnerSearchResponseDTO> ownerSearchResponseDTO = adminMapper.getOwners(ownerSearchRequestDTO);
        int size = adminMapper.getOwnersCount(ownerSearchRequestDTO);
        return new PageMaker<>(ownerSearchResponseDTO,size,ownerSearchRequestDTO.getPageSize(),ownerSearchRequestDTO.getCurrentPage());
    }

}
