package kr.co.solfood.admin.home;

import kr.co.solfood.admin.dto.ChartRequestDTO;
import kr.co.solfood.user.login.UserVO;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminHomeController {

    private final AdminHomeService adminHomeService;

    AdminHomeController(AdminHomeService adminHomeService) {
        this.adminHomeService = adminHomeService;
    }

    @GetMapping("/home")
    public void home(Model model) {
    }

    @GetMapping("/home/user-management")
    public String userManagement(Model model) {
        List<UserVO> userList = adminHomeService.getUsers("");
        model.addAttribute("userList", userList);
        return "admin/user-management/home";
    }

    @ResponseBody
    @GetMapping("/home/user-management/search")
    public List<UserVO> userSearch(@RequestParam String query, Model model) {
        return adminHomeService.getUsers(query);
    }

    @ResponseBody
    @GetMapping("/home/user-management/chart")
    public List<ChartRequestDTO> getChartData(@RequestParam("date") String date) {
        return adminHomeService.userManagementChart(date);
    }

}
