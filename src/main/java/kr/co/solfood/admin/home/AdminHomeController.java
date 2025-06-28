package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.*;
import kr.co.solfood.util.CustomException;
import kr.co.solfood.util.PageMaker;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collections;
import java.util.List;


@Controller
@RequestMapping("/admin/home")
@Slf4j
public class AdminHomeController {
    private final AdminHomeService adminHomeService;
    private final int START_PAGE = 1;
    private final int PAGE_GROUP_AMOUNT = 10;

    AdminHomeController(AdminHomeService adminHomeService) {
        this.adminHomeService = adminHomeService;
    }

    /**
     * 어드민 페이지 메인
     */
    @GetMapping("")
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
            OwnerSearchDTO ownerSearchDTO = new OwnerSearchDTO();
            ownerSearchDTO.setCurrentPage(START_PAGE);
            ownerSearchDTO.setPageSize(PAGE_GROUP_AMOUNT);
            PageMaker<OwnerSearchResponseDTO> ownerList = adminHomeService.getOwners(ownerSearchDTO);
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
    public PageMaker<OwnerSearchResponseDTO> getOwners(OwnerSearchDTO ownerSearchRequestDTO, Model model) {
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
    public String paymentManagement() {
        return "admin/payment-management/home";
    }

    /**
     * 어드민 페이지 < 점주 승인 상태 업데이트
     * @param ownerId 점주 ID
     * @param status   점주 상태 (승인완료, 승인대기, 승인거절)
     */
    @ResponseBody
    @GetMapping("/owner-management/status-update")
    public String OwnerStatusUpdate(@RequestParam("ownerId") long ownerId, @RequestParam("status") String status) {
        try {
            adminHomeService.updateOwnerStatus(new OwnerStatusUpdateDTO(ownerId, status));
        } catch (IllegalArgumentException e) {
            log.info("Owner status update failed: {}", e.getMessage());
        }
        return "admin/owner-management/home";
    }
}
