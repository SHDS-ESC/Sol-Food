package kr.co.solfood.admin.login;

import kr.co.solfood.util.CustomException;
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
        try {
            AdminVO adminVO = adminLoginService.login(password);
            session.setAttribute("adminLoginSession", adminVO);
            return "redirect:home";
        } catch (CustomException e) {
            return "redirect:login";
        }
    }
}
