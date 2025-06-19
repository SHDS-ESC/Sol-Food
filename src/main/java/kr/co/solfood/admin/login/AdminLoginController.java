package kr.co.solfood.admin.login;

import properties.KakaoProperties;
import properties.ServerProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminLoginController {

    @Autowired
    private KakaoProperties kakaoProperties;

    @Autowired
    private ServerProperties serverProperties;

    @GetMapping("/home")
    public void home(Model model) {
    }

    // 유저 로그인 페이지
    @GetMapping("/login")
    public void login(Model model) {
        model.addAttribute("apiKey", kakaoProperties.getRestApiKey());
        Map<String, String> serverMap = new HashMap<>();
        serverMap.put("ip", serverProperties.getIp());
        serverMap.put("port", serverProperties.getPort());
        model.addAttribute("serverMap", serverMap);
    }
}
