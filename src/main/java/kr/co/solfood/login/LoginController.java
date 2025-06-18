package kr.co.solfood.login;

import properties.KakaoProperties;
import properties.ServerProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
public class LoginController {

    @Autowired
    private LoginService service;

    @Autowired
    private KakaoProperties kakaoProperties;

    @Autowired
    private ServerProperties serverProperties;

    @GetMapping("/user/login")
    public void login(Model model) {
        model.addAttribute("apiKey", kakaoProperties.getRestApiKey());
        Map<String,String> serverMap = new HashMap<>();
        serverMap.put("ip", serverProperties.getIp());
        serverMap.put("port", serverProperties.getPort());
        model.addAttribute("serverMap", serverMap);
    }

    @Transactional
    @GetMapping("/user/kakaoLogin")
    public String kakaoLogin(@RequestParam String code, HttpSession sess) {
        LoginVO kakaoLogin = service.confirmAccessToken(code);
        service.kakaoLogin(kakaoLogin);
        sess.setAttribute("loginSession", kakaoLogin);
        return "redirect:mypage";
    }

}
