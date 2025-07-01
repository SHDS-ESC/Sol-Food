package kr.co.solfood.admin.home;

import kr.co.solfood.user.login.UserVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.List;

@Slf4j
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
        log.info("검색 쿼리: {}", query);
        model.addAttribute("userList", userList);
        log.info("검색 결과 수: {}", userList.size());
        return "admin/user-management/home";
    }

}
