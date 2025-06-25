package kr.co.solfood.admin.login;

import kr.co.solfood.admin.home.AdminHomeService;
import org.springframework.web.bind.annotation.*;
import properties.KakaoProperties;
import properties.ServerProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminLoginController {

    private final AdminLoginService adminLoginService;

    @Autowired
    public AdminLoginController(AdminLoginService adminLoginService, KakaoProperties kakaoProperties, ServerProperties serverProperties) {
        this.adminLoginService = adminLoginService;
    }

    // 유저 로그인 페이지
    @GetMapping("/login")
    public void login() {
    }

    @PostMapping("/login")
    public String login(@RequestParam("password") String password, HttpSession session) {
        if(adminLoginService.login(password) != null) {
            session.setAttribute("adminLoginSession", adminLoginService.login(password));
            return "redirect:home";
        } else {
           return "redirect:login";
        }
    }
}
