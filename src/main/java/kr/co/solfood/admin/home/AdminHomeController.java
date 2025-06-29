package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.*;
import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.util.PageMaker;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import org.springframework.web.bind.annotation.ResponseBody;
import java.util.List;


@Controller
@RequestMapping("/admin")
public class AdminHomeController {

    private final AdminHomeService adminHomeService;

    private final int START_PAGE = 1;
    private final int PAGE_GROUP_AMOUNT = 10;

    AdminHomeController(AdminHomeService adminHomeService) {
        this.adminHomeService = adminHomeService;
    }

    @GetMapping("/home")
    public void home(Model model) {
    }

    @GetMapping("/home/user-management")
    public String userManagement(Model model) {
        UserSearchRequestDTO userSearchRequestDTO = new UserSearchRequestDTO();
        userSearchRequestDTO.setCurrentPage(START_PAGE);
        userSearchRequestDTO.setPageSize(PAGE_GROUP_AMOUNT);
        PageMaker<UserSearchResponseDTO> userList = adminHomeService.getUsers(  userSearchRequestDTO);
        model.addAttribute("userList", userList);
        return "admin/user-management/home";
    }

    @ResponseBody
    @GetMapping("/home/user-management/search")
    public PageMaker<UserSearchResponseDTO> getUsers(UserSearchRequestDTO userSearchRequestDTO, Model model) {
        return adminHomeService.getUsers(userSearchRequestDTO);
    }

    @ResponseBody
    @GetMapping("/home/user-management/chart")
    public List<ChartRequestDTO> getChartData(@RequestParam("date") String date) {
        return adminHomeService.userManagementChart(date);
    }

    @GetMapping("/home/owner-management")
    public String ownerManagement(Model model) {
        OwnerSearchDTO ownerSearchDTO = new OwnerSearchDTO();
        ownerSearchDTO.setCurrentPage(START_PAGE);
        ownerSearchDTO.setPageSize(PAGE_GROUP_AMOUNT);
        PageMaker<OwnerSearchResponseDTO> ownerList = adminHomeService.getOwners(ownerSearchDTO);
        model.addAttribute("ownerList", ownerList);
        return "admin/owner-management/home";
    }

    @ResponseBody
    @GetMapping("/home/owner-management/search")
    public PageMaker<OwnerSearchResponseDTO> getOwners(OwnerSearchDTO ownerSearchRequestDTO, Model model) {
        return adminHomeService.getOwners(ownerSearchRequestDTO);
    }

    @GetMapping("/home/payment-management")
    public String paymentManagement(Model model) {
        return "admin/payment-management/home";
    }

    @ResponseBody
    @GetMapping("/home/payment-management/status-update")
    public String OwnerStatusUpdate(@RequestParam("ownerId") long ownerId, @RequestParam("status") String status) {
        adminHomeService.updateOwnerStatus(new OwnerStatusUpdateDTO(ownerId, status));
        return "admin/payment-management/home";
    }
}
