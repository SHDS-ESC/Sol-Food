package kr.co.solfood.owner.login;

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
@RequestMapping("/owner")
public class OwnerLoginController {

    @Autowired
    private KakaoProperties kakaoProperties;

    @Autowired
    private ServerProperties serverProperties;

    // 오너 루트 경로 - index 페이지로 리다이렉트
    @GetMapping("/")
    public String root() {
        return "redirect:/owner/index";
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

    @GetMapping("/home")
    public void home(Model model) {}


    // 오너 대시보드 메인 페이지
    @GetMapping("/index")
    public String index(Model model) {
        // 여기에 필요한 데이터를 모델에 추가할 수 있습니다
        model.addAttribute("ownerName", "관리자님");
        model.addAttribute("restaurantName", "Sol Food");
        return "owner/index";
    }
}
