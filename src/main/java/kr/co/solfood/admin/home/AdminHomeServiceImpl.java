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
    public PageMaker<OwnerSearchResponseDTO> getOwners(OwnerSearchRequestDTO ownerSearchRequestDTO) {
        List<OwnerSearchResponseDTO> ownerSearchResponseDTO = adminMapper.getOwners(ownerSearchRequestDTO);
        int size = adminMapper.getOwnersCount(ownerSearchRequestDTO);

        if (ownerSearchRequestDTO == null) {
            throw new CustomException(ErrorCode.UNDEFINED_SEARCH);
        }
        return new PageMaker<>(ownerSearchResponseDTO, size, ownerSearchRequestDTO.getPageSize(), ownerSearchRequestDTO.getCurrentPage());
    }

    @Override
    public List<ChartRequestDTO> userManagementChart(String date) {
        if (date == null || date.isEmpty()) {
            throw new CustomException(ErrorCode.INCORRECT_DATE_FORMAT);
        }

        List<ChartRequestDTO> list;
        switch (date) {
            case "월간":
                list = adminMapper.userManagementChartByMonths();
                confirmList(list);
                return list;
            case "일간":
                list = adminMapper.userManagementChartByDays();
                confirmList(list);
                return list;
            case "연간":
            default:
                list = adminMapper.userManagementChartByYears();
                confirmList(list);
                return list;
        }
    }

    private void confirmList(List<ChartRequestDTO> list){
        if (list == null) {
            throw new CustomException(ErrorCode.INCORRECT_DATE_FORMAT);
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

    @Override
    public void updateUserStatus(UserStatusUpdateDTO userStatusUpdateDTO) {
        // 업데이트
        int updated = adminMapper.updateUserStatus(userStatusUpdateDTO);
        if (updated == 0) {
            throw new IllegalArgumentException("유효하지 않은 userStatusUpdateDTO 입니다.");
        }
    }

    @Override
    public PageMaker<PaymentSearchResponseDto> getPayments(PaymentSearchRequestDto paymentSearchRequestDto) {
        List<PaymentSearchResponseDto> paymentSearchResponseDto = adminMapper.getPayments(paymentSearchRequestDto);
        int size = adminMapper.getPaymentsCount(paymentSearchRequestDto);

        if (paymentSearchResponseDto == null) {
            throw new CustomException(ErrorCode.UNDEFINED_SEARCH);
        }
        return new PageMaker<>(paymentSearchResponseDto, size, paymentSearchRequestDto.getPageSize(), paymentSearchRequestDto.getCurrentPage());
    }
}
