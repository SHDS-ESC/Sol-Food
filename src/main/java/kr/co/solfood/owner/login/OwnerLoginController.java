package kr.co.solfood.owner.login;

import configuration.KakaoProperties;
import configuration.ServerProperties;
import kr.co.solfood.user.login.LoginService;
import kr.co.solfood.user.login.LoginVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/owner")
public class OwnerLoginController {

    @Autowired
    private KakaoProperties kakaoProperties;

    @Autowired
    private ServerProperties serverProperties;

    // 유저 로그인 페이지
    @GetMapping("/login")
    public void login(Model model) {
        model.addAttribute("apiKey", kakaoProperties.getRestApiKey());
        Map<String,String> serverMap = new HashMap<>();
        serverMap.put("ip", serverProperties.getIp());
        serverMap.put("port", serverProperties.getPort());
        model.addAttribute("serverMap", serverMap);
    }

    @GetMapping("/home")
    public void home(Model model) {}
}
