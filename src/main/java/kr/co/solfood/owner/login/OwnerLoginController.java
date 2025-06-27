package kr.co.solfood.owner.login;

import properties.KakaoProperties;
import properties.ServerProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/owner")
public class OwnerLoginController {

    @Autowired
    private OwnerLoginService service;

    // 점주 루트 경로 - index 페이지로 리다이렉트
    @GetMapping("/")
    public String root() {
        return "redirect:/owner/index";
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
            return "redirect:store";
        }
        else {
            return "redirect:login";
        }
    }

    // 점주 로그아웃 get
    @GetMapping("/logout")
    public String logout(HttpSession sess){
        sess.invalidate(); // 세션 종료
        return "redirect:login";
    }


}
