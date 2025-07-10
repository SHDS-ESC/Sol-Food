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

    List<OwnerSearchResponseDTO> getOwners(OwnerSearchRequestDTO ownerSearchRequestDTO);

    int getOwnersCount(OwnerSearchRequestDTO ownerSearchRequestDTO);

    int updateStoreStatus(StoreStatusUpdateDTO storeStatusUpdateDTO);

    OwnerSearchResponseDTO detailStoreInfo(String ownerId);

    int updateUserStatus(UserStatusUpdateDTO userStatusUpdateDTO);

    List<PaymentSearchResponseDto> getPayments(PaymentSearchRequestDto paymentSearchRequestDto);

    int getPaymentsCount(PaymentSearchRequestDto paymentSearchRequestDto);

    List<OwnerReviewResponseDto> getOwnerReviews(OwnerReviewRequestDto ownerReviewRequestDto);

    List<CommunityResponseDto> communityResponses(CommunityRequestDto communityRequestDto);

    int getOwnerReviewsCount(OwnerReviewRequestDto ownerReviewRequestDto);

    int getCommunityResponsesCount(CommunityRequestDto communityRequestDto);

    void deleteOwnerReview(long reviewId);
}
