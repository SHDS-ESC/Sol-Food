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
    private OwnerLoginService service;

    @Autowired
    private KakaoProperties kakaoProperties;

    @Autowired
    private ServerProperties serverProperties;

    // 점주 루트 경로 - index 페이지로 리다이렉트
    @GetMapping("/")
    public String root() {
        return "redirect:/owner/index";
    }

        
    // 점주 대시보드 메인 페이지
    @GetMapping("/main")
    public String index(Model model) {
        // 여기에 필요한 데이터를 모델에 추가할 수 있습니다
//        model.addAttribute("ownerName", "관리자님");
//        model.addAttribute("restaurantName", "Sol Food");
        return "owner/main";
    }

    // 점주 회원가입 get
    @GetMapping("/register")
    public void register(){}

    // 점주 회원가입 post
    @PostMapping("/register")
    public String register(OwnerVO vo){
        service.register(vo);
        return "redirect:login";
    }

    // 점주 로그인 get
    @GetMapping("/login")
    public void login(){}

    // 점주 로그인 post
    @PostMapping("/login")
    public String login(OwnerVO vo, Model model, HttpSession sess){
        OwnerVO ownerVO = service.login(vo);
        if(ownerVO != null){
            sess.setAttribute("ownerLoginSession", ownerVO);
            return "redirect:main";
        }
        else {
            System.out.println("로그인실패");
            return "redirect:login";
        }
    }

    // 임시 페이지 get
    @GetMapping("/temp")
    public void temp(){}


}
