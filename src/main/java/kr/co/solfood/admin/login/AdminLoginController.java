package kr.co.solfood.admin.login;

import kr.co.solfood.common.constants.UrlConstants;
import kr.co.solfood.util.CustomException;
import properties.KakaoProperties;
import properties.ServerProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/login")
public class AdminLoginController {

    @Autowired
    private KakaoProperties kakaoProperties;

    @Autowired
    private ServerProperties serverProperties;

    @Autowired
    private AdminLoginService adminLoginService;

    // 유저 로그인 페이지
    @GetMapping("")
    public void login() {
    }

    @PostMapping("")
    public String login(@RequestParam("password") String password, HttpSession session) {
        try {
            session.setAttribute(UrlConstants.Session.ADMIN_LOGIN_SESSION, adminLoginService.login(password));
            return "redirect:home";
        } catch (CustomException e) {
            return "redirect:login";
        }
    }
}
