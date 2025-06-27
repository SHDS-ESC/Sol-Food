package kr.co.solfood.admin.login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import properties.KakaoProperties;
import properties.ServerProperties;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/login")
public class AdminLoginController {

    private final AdminLoginService adminLoginService;

    @Autowired
    public AdminLoginController(AdminLoginService adminLoginService, KakaoProperties kakaoProperties, ServerProperties serverProperties) {
        this.adminLoginService = adminLoginService;
    }

    // 유저 로그인 페이지
    @GetMapping("")
    public void login() {
    }

    @PostMapping("")
    public String login(@RequestParam("password") String password, HttpSession session) {
        try {
            session.setAttribute("adminLoginSession", adminLoginService.login(password));
            return "redirect:home";
        } catch (IllegalArgumentException e) {
            return "redirect:login";
        }
    }
}
