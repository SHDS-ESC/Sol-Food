package kr.co.solfood.user.login;

import properties.KakaoProperties;
import properties.ServerProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

@Controller
@RequestMapping("/user")
public class LoginController {

    private final LoginService service;
    private final KakaoProperties kakaoProperties;
    private final ServerProperties serverProperties;
    private static final Random rand = new Random(1234L); // 랜덤 객체

    // 랜덤 비밀번호 생성 로직
    public static String makePassword() {
        String chars = "abcdefghijklmnopqrstuvwxyz0123456789";
        int len = 8 + rand.nextInt(6); // 8~13글자
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < len; i++) {
            sb.append(chars.charAt(rand.nextInt(chars.length())));
        }
        return sb.toString();
    }

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
        UserVO kakaoLogin = service.confirmAccessToken(code);
        sess.setAttribute("userLoginSession", kakaoLogin);
        return service.confirmKakaoLoginWithFirst(kakaoLogin) ? "redirect:extra" : "redirect:/";
    }

    // 카카오 추가 정보 페이지
    @GetMapping("/extra")
    public void extra(Model model) {
        List<CompanyVO> companyList = service.getCompanyList(); // 회사 리스트 가져오기
        model.addAttribute("companyList", companyList);
    }

    // 추가 정보 받은 후 등록
    @Transactional
    @PostMapping("/extra")
    public String extra(UserVO kakaoAddVO, HttpSession sess) {
        UserVO userVo = service.register(kakaoAddVO);
        System.out.println("브이오" + kakaoAddVO);
        sess.setAttribute("userLoginSession", userVo);
        return "redirect:/";
    }

    // 로그 아웃
    @GetMapping("/logout")
    public String logout(HttpSession sess) {
        sess.invalidate();
        return "redirect:/";
    }

    // 자체 로그인
    @PostMapping("/native-login")
    public String nativeLogin(LoginRequest req, HttpSession sess, Model model) {
        UserVO userVo = service.nativeLogin(req);
        if(userVo !=null){
            sess.setAttribute("userLoginSession", userVo);
            return "redirect:/";
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
    public void searchPwd() {}

    // 비밀번호 찾기 post
    @Transactional
    @PostMapping("/search-pwd")
    public String searchPwd(SearchPwdRequest req, Model model) {
       UserVO userVo  = service.searchPwd(req);
       if(userVo != null){
           /* 임시 비밀번호 */
           String newPwd = makePassword(); // 임시 비밀번호 생성
           req.setUsersPwd(newPwd); // req vo 에 저장
           service.setNewPwd(req); // req vo 전달
           model.addAttribute("newPwd", newPwd);
       }
        return "/user/find-pwd";
    }


    // 회원가입
    @GetMapping("/join")
    public String join(Model model, HttpSession session) {
        List<CompanyVO> companyList = service.getCompanyList(); // 회사 리스트 가져오기
        model.addAttribute("companyList", companyList);
        
        // 회원가입 진행 세션 플래그 설정 (S3 업로드 보안용)
        session.setAttribute("joinInProgress", true);
        session.setAttribute("uploadCount", 0);
        session.setMaxInactiveInterval(30 * 60); // 30분 후 만료
        
        return "/user/join";
    }

    // 회원가입 post
    @Transactional
    @PostMapping("/join")
    public String join(UserVO kakaoAddVO, HttpSession sess) {
        service.register(kakaoAddVO);
        
        // 회원가입 완료 후 세션 정리
        sess.removeAttribute("joinInProgress");
        sess.removeAttribute("uploadCount");
        
        return "redirect:login";
    }

    // 부서
    @GetMapping("/company/depts")
    @ResponseBody
    public List<DepartmentVO> getDepartments(@RequestParam("companyId") int companyId) {
        return service.getDepartmentsByCompanyId(companyId);
    }


}
