package kr.co.solfood.user.login;

import kr.co.solfood.common.constants.UrlConstants;
import properties.KakaoProperties;
import properties.ServerProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

@Controller
@RequestMapping("/user/login")
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


    @GetMapping("")
    public String login(Model model) {
        model.addAttribute("apiKey", kakaoProperties.getRestApiKey());
        Map<String, String> serverMap = new HashMap<>();
        serverMap.put("ip", serverProperties.getIp());
        serverMap.put("port", serverProperties.getPort());
        model.addAttribute("serverMap", serverMap);
        return "user/login/loginpage";
    }

    // 자체 로그인
    @PostMapping("/native-login")
    public String nativeLogin(LoginRequest req, HttpSession sess, Model model) {
        UserVO userVo = service.nativeLogin(req);
        if(userVo !=null){

            // 비활성화일때
            if("inactive".equals(userVo.getUsersStatus())){
                sess.setAttribute(UrlConstants.Session.USER_LOGIN_SESSION, userVo);
                return "redirect:" + UrlConstants.Common.ROOT;
            } else if ("withdraw".equals(userVo.getUsersStatus())) {
                model.addAttribute("msg", "탈퇴한 회원입니다.");
                return "user/login/loginpage"; // 로그인 페이지로 다시 이동
            }

            sess.setAttribute(UrlConstants.Session.USER_LOGIN_SESSION, userVo);
            return "redirect:" + UrlConstants.Common.ROOT;
        } else {
            model.addAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
            return "user/login/loginpage"; // 로그인 페이지로 다시 이동
        }
    }


    // 카카오 로그인
    @Transactional
    @GetMapping("/kakao-login")
    public String kakaoLogin(@RequestParam String code, HttpSession sess, Model model) {
        System.out.println("code:" + code);
        UserVO kakaoLogin = service.confirmAccessToken(code);

        // 비활성화일때
        if("inactive".equals(kakaoLogin.getUsersStatus())){
            sess.setAttribute(UrlConstants.Session.USER_LOGIN_SESSION, kakaoLogin);
            return "redirect:" + UrlConstants.Common.ROOT;
        } else if ("withdraw".equals(kakaoLogin.getUsersStatus())) {
            model.addAttribute("msg", "탈퇴한 회원입니다.");
            return "user/login/loginpage"; // 로그인 페이지로 다시 이동
        }

        sess.setAttribute(UrlConstants.Session.USER_LOGIN_SESSION, kakaoLogin);
        return service.confirmKakaoLoginWithFirst(kakaoLogin) ? "redirect:" + UrlConstants.User.LOGIN_EXTRA : "redirect:" + UrlConstants.Common.ROOT;
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
        sess.setAttribute(UrlConstants.Session.USER_LOGIN_SESSION, userVo);
        return "redirect:" + UrlConstants.Common.ROOT;
    }

    // 로그 아웃
    @GetMapping("/logout")
    public String logout(HttpSession sess) {
        sess.invalidate();
        return "redirect:" + UrlConstants.Common.ROOT;
    }


    // 아이디 찾기
    @GetMapping("/search-id")
    public String searchIdPage(Model model) {
        model.addAttribute("tabType", "id");
        return "user/login/search-pwd";
    }

    // 비밀번호 찾기 get
    @GetMapping("/search-pwd")
    public String searchPwdPage(Model model) {
        model.addAttribute("tabType", "pw");
        return "user/login/search-pwd";
    }

    // 비밀번호 찾기 post
    @PostMapping("/search-pwd")
    @ResponseBody
    public Map<String, Object> searchPwd(SearchPwdRequest req) {
        Map<String, Object> result = new HashMap<>();
        UserVO userVo  = service.searchPwd(req);
        if(userVo != null){
            String newPwd = makePassword();
            req.setUsersPwd(newPwd);
            service.setNewPwd(req);
            result.put("newPassword", newPwd);
        } else {
            result.put("newPassword", null);
        }
        return result;
    }

    

    // 회원가입
    @GetMapping("/register")
    public String join(Model model, HttpSession session) {
        List<CompanyVO> companyList = service.getCompanyList(); // 회사 리스트 가져오기
        model.addAttribute("companyList", companyList);

        // 회원가입 진행 세션 플래그 설정 (S3 업로드 보안용)
        session.setAttribute("s3InProgress", true);
        session.setAttribute("uploadCount", 0);
        session.setMaxInactiveInterval(30 * 60); // 30분 후 만료

        return "user/login/register";
    }

    // 회원가입 post
    @Transactional
    @PostMapping("/register")
    public String register(UserVO kakaoAddVO, HttpSession sess, RedirectAttributes redirectAttributes) {
        service.register(kakaoAddVO);

        // 회원가입 완료 후 세션 정리
        sess.removeAttribute("s3InProgress");
        sess.removeAttribute("uploadCount");

        redirectAttributes.addFlashAttribute("msg","회원가입이 완료되었습니다.");

        return "redirect:/user/login";
    }

    // 부서
    @GetMapping("/company/depts")
    @ResponseBody
    public List<DepartmentVO> getDepartments(@RequestParam("companyId") int companyId) {
        return service.getDepartmentsByCompanyId(companyId);
    }


}
