package kr.co.solfood.admin.home;

import com.google.api.Page;
import kr.co.solfood.admin.dto.*;
import kr.co.solfood.util.CustomException;
import kr.co.solfood.util.PageDTO;
import kr.co.solfood.util.PageMaker;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/admin")
@Slf4j
public class AdminHomeController {
    private final AdminHomeService adminHomeService;
    private final AnalyticsService analyticsService;
    private final int START_PAGE = 1;
    private final int PAGE_GROUP_AMOUNT = 10;

    @Autowired
    AdminHomeController(AdminHomeService adminHomeService, AnalyticsService analyticsService) {
        this.adminHomeService = adminHomeService;
        this.analyticsService = analyticsService;
    }

    /**
     * 어드민 페이지 메인
     */
    @GetMapping("/home")
    public void home() {
    }

    /**
     * 어드민 페이지 < 사용자 관리 대시보드
     */
    @GetMapping("/user-management")
    public String userManagement(Model model) {
        try {
            UserSearchRequestDTO userSearchRequestDTO = new UserSearchRequestDTO();
            userSearchRequestDTO.setCurrentPage(START_PAGE);
            userSearchRequestDTO.setPageSize(PAGE_GROUP_AMOUNT);
            PageMaker<UserSearchResponseDTO> userList = adminHomeService.getUsers(userSearchRequestDTO);
            model.addAttribute("userList", userList);
            log.info("userList={}", userList);
        } catch (CustomException e) {
            log.info("User management initialization failed: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
        }
        return "admin/user-management/home";
    }

    /**
     * 어드민 페이지 < 사용자 관리 대시보드 > 사용자 검색
     *
     * @param userSearchRequestDTO 검색 요청 DTO
     * @param model                모델
     * @return 사용자 목록 페이지 메이커
     */
    @ResponseBody
    @GetMapping("/user-management/search")
    public PageMaker<UserSearchResponseDTO> getUsers(UserSearchRequestDTO userSearchRequestDTO, Model model) {
        try {
            return adminHomeService.getUsers(userSearchRequestDTO);
        } catch (CustomException e) {
            log.info("User search failed: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
            return new PageMaker<>();
        }
    }

    /**
     * 어드민 페이지 < 사용자 관리 대시보드 > 차트 데이터
     *
     * @param date  차트 데이터 요청 날짜
     * @param model 모델
     * @return 차트 데이터 리스트
     */
    @ResponseBody
    @GetMapping("/user-management/chart")
    public List<ChartRequestDTO> getChartData(@RequestParam("date") String date, Model model) {
        try {
            return adminHomeService.userManagementChart(date);
        } catch (CustomException e) {
            log.info("Chart data retrieval failed: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * 어드민 페이지 < 가맹점 관리 대시보드
     */
    @GetMapping("/owner-management")
    public String ownerManagement(Model model) {
        try {
            OwnerSearchRequestDTO ownerSearchRequestDTO = new OwnerSearchRequestDTO();
            ownerSearchRequestDTO.setCurrentPage(START_PAGE);
            ownerSearchRequestDTO.setPageSize(PAGE_GROUP_AMOUNT);
            PageMaker<OwnerSearchResponseDTO> ownerList = adminHomeService.getOwners(ownerSearchRequestDTO);
            model.addAttribute("ownerList", ownerList);
        } catch (CustomException e) {
            log.info("Owner management initialization failed: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
        }
        return "admin/owner-management/home";
    }

    /**
     * 어드민 페이지 < 가맹점 관리 대시보드 > 가맹점 검색
     *
     * @param ownerSearchRequestDTO 검색 요청 DTO
     * @param model                 모델
     * @return 가맹점 목록 페이지 메이커
     */
    @ResponseBody
    @GetMapping("/owner-management/search")
    public PageMaker<OwnerSearchResponseDTO> getOwners(OwnerSearchRequestDTO ownerSearchRequestDTO, Model model) {
        try {
            return adminHomeService.getOwners(ownerSearchRequestDTO);
        } catch (CustomException e) {
            log.info("Owner search failed: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
            return new PageMaker<>();
        }
    }

    /**
     * 어드민 페이지 < 결제 관리 대시보드
     */
    @GetMapping("/payment-management")
    public String paymentManagement(Model model) {
        try {
            PaymentSearchRequestDto paymentSearchRequestDto = new PaymentSearchRequestDto();
            paymentSearchRequestDto.setCurrentPage(START_PAGE);
            paymentSearchRequestDto.setPageSize(PAGE_GROUP_AMOUNT);
            PageMaker<PaymentSearchResponseDto> paymentList = adminHomeService.getPayments(paymentSearchRequestDto);
            model.addAttribute("paymentList", paymentList);
        } catch (CustomException e) {
            log.info("Payment management initialization failed: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
        }
        return "admin/payment-management/home";
    }

    /**
     * 어드민 페이지 < 점주 승인 상태 업데이트
     *
     * @param ownerId 점주 ID
     * @param status  점주 상태 (승인완료, 승인대기, 승인거절)
     */
    @ResponseBody
    @GetMapping("/owner-management/status-update")
    public String storeStatusUpdate(@RequestParam("ownerId") long ownerId, @RequestParam("status") String status, @RequestParam("storeRejectReason") String storeRejectReason) {
        try {
            adminHomeService.updateStoreStatus(new StoreStatusUpdateDTO(ownerId, status, storeRejectReason));
        } catch (IllegalArgumentException e) {
            log.info("Owner status update failed: {}", e.getMessage());
        }
        return "admin/owner-management/home";
    }

    /**
     * 유저 페이지 < 유저 상태 업데이트
     *
     * @param usersId 유저 ID
     * @param status  유저 상태 (active, inactive)
     */
    @ResponseBody
    @GetMapping("/user-management/status-update")
    public String userStatusUpdate(@RequestParam("usersId") long usersId, @RequestParam("status") String status, @RequestParam("usersRejectedReason") String usersRejectReason) {
        try {
            adminHomeService.updateUserStatus(new UserStatusUpdateDTO(usersId, status, usersRejectReason));
        } catch (IllegalArgumentException e) {
            log.info("Users status update failed: {}", e.getMessage());
        }
        return "admin/user-management/home";
    }

    /**
     * 어드민 페이지 > 지점 상세 페이지 이동
     *
     * @param ownerId
     * @return
     */
    @GetMapping("/owner-detail")
    public String detailOwnerPage(@RequestParam("ownerId") String ownerId, Model model) {
        try {
            model.addAttribute("owner", adminHomeService.detailStoreInfo(ownerId));
        } catch (CustomException e) {
            log.info("Owner detail failed: {}", e.getMessage());
            return "admin/owner-management/home";
        }
        return "admin/owner-management/detail";
    }

    @GetMapping("/active-users")
    @ResponseBody   // JSON 반환
    public List<ReportRowDto> activeUsers(
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate from,
            @RequestParam(required = false)
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            LocalDate to) {

        if (to == null) to = LocalDate.now();             // 오늘
        if (from == null) from = LocalDate.of(2025, 1, 1);    // 임의 시작일

        return analyticsService.getActiveUsersByCity(from, to);
    }

    @GetMapping("/daily-users")
    @ResponseBody
    public List<DailyUsersDto> dailyUsers(
            @RequestParam(required = false) String date) {
        LocalDate to = LocalDate.now();             // 오늘
        LocalDate from = LocalDate.of(2025, 1, 1);    // 기본값

        return analyticsService.getDailyTotalUsers(from, to);
    }

    @GetMapping("/home/boards")
    @ResponseBody
    public PageMaker<CommunityResponseDto> getCommunityResponseDtos(CommunityRequestDto communityRequestDto, Model model) {
        try {
            return adminHomeService.getCommunityResponses(communityRequestDto);
        } catch (CustomException e) {
            model.addAttribute("error", e.getMessage());
            return new PageMaker<>();
        }
    }

    @GetMapping("/home/reviews")
    @ResponseBody
    public PageMaker<OwnerReviewResponseDto> getOwnerReviewDtos(OwnerReviewRequestDto ownerReviewRequestDto, Model model) {
        try {
            return adminHomeService.getOwnerReviews(ownerReviewRequestDto);
        } catch (CustomException e) {
            model.addAttribute("error", e.getMessage());
            return new PageMaker<>();
        }
    }

    @GetMapping("/home/reviews/delete")
    @ResponseBody
    public void deleteOwnerReview(@RequestParam("reviewId") long reviewId, Model model) {
        try {
            adminHomeService.deleteOwnerReview(reviewId);
        } catch (CustomException e) {
            log.info("Owner review deletion failed: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
        }
    }

    @GetMapping("/payment-management/search")
    @ResponseBody
    public PageMaker<PaymentSearchResponseDto> getPayments(PaymentSearchRequestDto paymentSearchRequestDto, Model model) {
        try {
            System.out.println("데이트" + paymentSearchRequestDto);
            return adminHomeService.getPayments(paymentSearchRequestDto);
        } catch (CustomException e) {
            log.info("Payment search failed: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
            return new PageMaker<>();
        }
    }

    @GetMapping("/payment-management/detail")
    public String paymentDetail(@RequestParam("integratedpaymentId") String integratedpaymentId, @ModelAttribute PaymentDistinctRequestDto paymentDistinctRequestDto, Model model) {
        try {
            PageMaker<PaymentDistinctResponseDto> paymentDetail = adminHomeService.getDistinctPayments(paymentDistinctRequestDto);
            model.addAttribute("paymentDetail", paymentDetail);
            log.info("Payment detail retrieved: {}", paymentDetail);
        } catch (CustomException e) {
            log.info("Payment detail retrieval failed: {}", e.getMessage());
            model.addAttribute("error", e.getMessage());
        }
        return "admin/payment-management/detail";
    }

}
