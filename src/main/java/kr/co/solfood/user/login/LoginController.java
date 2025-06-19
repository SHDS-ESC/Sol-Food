package kr.co.solfood.user.login;

import configuration.KakaoProperties;
import configuration.ServerProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class LoginController {

    @Autowired
    private LoginService service;

    @Autowired
    private KakaoProperties kakaoProperties;

    @Autowired
    private ServerProperties serverProperties;

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
        sess.setAttribute("user", kakaoLogin);
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
        sess.setAttribute("user", loginVO);
        return "redirect:mypage";
    }

    // 로그 아웃
    @GetMapping("/logout")
    public String logout(HttpSession sess) {
        sess.invalidate();
        return "redirect:login";
    }

    // 자체 로그인
    @PostMapping("/native-login")
    public String nativeLogin(LoginRequest req, HttpSession sess, Model model) {
        LoginVO loginVO = service.nativeLogin(req);
        if(loginVO !=null){
            sess.setAttribute("user", loginVO);

            return "redirect:mypage";
        } else {
            model.addAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "/user/login"; // 로그인 페이지로 다시 이동
        }
    }

    // 아이디 찾기
    @GetMapping("/search-id")
    public void searchId() {
    }

    // 비밀번호 찾기
    @GetMapping("/search-pwd")
    public void searchPwd() {
    }

    // 회원가입
    @GetMapping("/join")
    public String join(Model model) {
        List<CompanyVO> companyList = service.getCompanyList(); // 회사 리스트 가져오기
        model.addAttribute("companyList", companyList);
        return "/user/join";
    }

    // 회원가입 post
    @Transactional
    @PostMapping("/join")
    public String join(LoginVO kakaoAddVO, HttpSession sess) {
        LoginVO loginVO = service.register(kakaoAddVO);
        sess.setAttribute("user", loginVO);
        return "redirect:mypage";
    }

    // 부서
    @GetMapping("/company/depts")
    @ResponseBody
    public List<DepartmentVO> getDepartments(@RequestParam("companyId") int companyId) {
        System.out.println("companyId:" + companyId);
        return service.getDepartmentsByCompanyId(companyId);
    }


}
