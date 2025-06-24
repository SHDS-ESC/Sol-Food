package kr.co.solfood.user.mypage;

import kr.co.solfood.user.login.CompanyVO;
import kr.co.solfood.user.login.LoginService;
import kr.co.solfood.user.login.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/user/mypage")
public class MypageController {

    @Autowired
    private LoginService loginService;
    @Autowired
    private MypageService mypageService;

    @GetMapping("")
    public String myPage(Model model) {
        return "user/mypage";
    }

    // 마이페이지 > 내정보 get
    @GetMapping("/info")
    public String myPageInfo(Model model, HttpSession sess) {
        List<CompanyVO> companyList = loginService.getCompanyList();
        UserVO userVO = (UserVO) sess.getAttribute("userLoginSession");
        model.addAttribute("user", userVO);
        model.addAttribute("companyList", companyList);

        // 회원가입 진행 세션 플래그 설정 (S3 업로드 보안용)
        sess.setAttribute("joinInProgress", true);
        sess.setAttribute("uploadCount", 0);
        sess.setMaxInactiveInterval(30 * 60); // 30분 후 만료
        return "user/info";
    }

    // 마이페이지 > 내정보 post
    @PostMapping("/info")
    public String updateMyPageInfo(@ModelAttribute UserVO userVO,
                                   HttpSession sess, HttpServletRequest request) {

        // 1. 로그인한 사용자 정보 가져오기
        UserVO loginUser = (UserVO) sess.getAttribute("userLoginSession");
        if(loginUser == null){
            return "redirect:login"; // 로그인 안되어있으면 로그인 페이지로 리다이렉트
        }

        // 2. userId 설정
        userVO.setUsersId(loginUser.getUsersId());


        // 3. service update
        mypageService.updateUserInfo(userVO);

        // 회원가입 완료 후 세션 정리
        sess.removeAttribute("joinInProgress");
        sess.removeAttribute("uploadCount");

        // 수정된 로그인 세션 새로 저장
        sess.setAttribute("userLoginSession", userVO);

        // 4. 세션정보 갱신
        return "redirect:/";
    }

}
