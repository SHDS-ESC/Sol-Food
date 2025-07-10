package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.*;
import kr.co.solfood.util.PageMaker;

import java.util.List;

public interface AdminHomeService {
    PageMaker<UserSearchResponseDTO> getUsers(UserSearchRequestDTO userSearchRequestDTO);

    List<ChartRequestDTO> userManagementChart(String date);

    PageMaker<OwnerSearchResponseDTO> getOwners(OwnerSearchRequestDTO ownerSearchRequestDTO);

    void updateStoreStatus(StoreStatusUpdateDTO storeStatusUpdateDTO);

    OwnerSearchResponseDTO detailStoreInfo(String ownerId);

    void updateUserStatus(UserStatusUpdateDTO userStatusUpdateDTO);

    PageMaker<PaymentSearchResponseDto> getPayments(PaymentSearchRequestDto paymentSearchRequestDto);

    PageMaker<OwnerReviewResponseDto> getOwnerReviews(OwnerReviewRequestDto ownerReviewRequestDto);

    PageMaker<CommunityResponseDto> getCommunityResponses(CommunityRequestDto communityRequestDto);

    void deleteOwnerReview(long reviewId);
}
