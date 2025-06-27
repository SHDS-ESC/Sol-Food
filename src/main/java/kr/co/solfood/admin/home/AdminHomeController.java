package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.*;
import kr.co.solfood.util.PageMaker;
import lombok.extern.log4j.Log4j2;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

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

    @GetMapping("")
    public void home() {
    }

    @GetMapping("/user-management")
    public String userManagement(Model model) {
        UserSearchRequestDTO userSearchRequestDTO = new UserSearchRequestDTO();
        userSearchRequestDTO.setCurrentPage(START_PAGE);
        userSearchRequestDTO.setPageSize(PAGE_GROUP_AMOUNT);
        PageMaker<UserSearchResponseDTO> userList = adminHomeService.getUsers(userSearchRequestDTO);
        model.addAttribute("userList", userList);
        return "admin/user-management/home";
    }

    @ResponseBody
    @GetMapping("/user-management/search")
    public PageMaker<UserSearchResponseDTO> getUsers(UserSearchRequestDTO userSearchRequestDTO, Model model) {
        return adminHomeService.getUsers(userSearchRequestDTO);
    }

    @ResponseBody
    @GetMapping("/user-management/chart")
    public List<ChartRequestDTO> getChartData(@RequestParam("date") String date) {
        return adminHomeService.userManagementChart(date);
    }

    @GetMapping("/owner-management")
    public String ownerManagement(Model model) {
        OwnerSearchDTO ownerSearchDTO = new OwnerSearchDTO();
        ownerSearchDTO.setCurrentPage(START_PAGE);
        ownerSearchDTO.setPageSize(PAGE_GROUP_AMOUNT);
        PageMaker<OwnerSearchResponseDTO> ownerList = adminHomeService.getOwners(ownerSearchDTO);
        model.addAttribute("ownerList", ownerList);
        return "admin/owner-management/home";
    }

    @ResponseBody
    @GetMapping("/owner-management/search")
    public PageMaker<OwnerSearchResponseDTO> getOwners(OwnerSearchDTO ownerSearchRequestDTO) {
        return adminHomeService.getOwners(ownerSearchRequestDTO);
    }

    @GetMapping("/payment-management")
    public String paymentManagement() {
        return "admin/payment-management/home";
    }

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
