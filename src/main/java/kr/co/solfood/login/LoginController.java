package kr.co.solfood.login;

import configuration.KakaoProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
public class LoginController {

    @Autowired
    private LoginService service;

    @Autowired
    private KakaoProperties kakaoProperties;

    @GetMapping("/user/login")
    public void login(){}

    @GetMapping("/user/kakaoLogin")
    public String kakaoLogin(@RequestParam String code, HttpSession sess) {
        LoginVO kakaoLogin = service.confirmAccessToken(code);
        service.kakaoLogin(kakaoLogin);
        sess.setAttribute("loginSession", kakaoLogin);
        return "redirect:index";
    }

}
