package kr.co.solfood.admin.home;

import kr.co.solfood.user.login.UserVO;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        return "admin/user-management/home";
    }

    @GetMapping("/home/user-management/search")
    public String userSearch(@RequestParam String query, Model model) {
        List<UserVO> userList = adminHomeService.getUsers(query);
        System.out.println(query);
        model.addAttribute("userList", userList);
        System.out.println("리스트" + userList);
        return "admin/user-management/home";
    }

}
