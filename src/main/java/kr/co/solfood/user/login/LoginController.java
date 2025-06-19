package kr.co.solfood.user.login;

import configuration.KakaoProperties;
import configuration.ServerProperties;
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
@RequestMapping("/user")
public class LoginController {

    private final LoginService service;
    private final KakaoProperties kakaoProperties;
    private final ServerProperties serverProperties;

    @Autowired
    public LoginController(LoginService service, KakaoProperties kakaoProperties, ServerProperties serverProperties) {
        this.service = service;
        this.kakaoProperties = kakaoProperties;
        this.serverProperties = serverProperties;
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

    // 카카오 로그인
    @Transactional
    @GetMapping("/kakaoLogin")
    public String kakaoLogin(@RequestParam String code, HttpSession sess) {
        LoginVO kakaoLogin = service.confirmAccessToken(code);
        sess.setAttribute("userLoginSession", kakaoLogin);
        return service.confirmKakaoLoginWithFirst(kakaoLogin) ? "redirect:add-register" : "redirect:mypage";
    }

    // 카카오 추가 정보 페이지
    @GetMapping("/add-register")
    public void addRegister() {
    }

    // 추가 정보 받은 후 등록
    @Transactional
    @PostMapping("/add-register")
    public String addRegister(LoginVO kakaoAddVO, HttpSession sess) {
        LoginVO loginVO = service.register(kakaoAddVO);
        sess.setAttribute("userLoginSession", loginVO);
        return "redirect:mypage";
    }

    // 로그 아웃
    @GetMapping("/logout")
    public String logout(HttpSession sess) {
        sess.invalidate();
        return "redirect:login";
    }

}
