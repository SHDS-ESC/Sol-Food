package kr.co.solfood.user.mypage;

import kr.co.solfood.user.like.LikeService;
import kr.co.solfood.user.login.CompanyVO;
import kr.co.solfood.user.login.LoginService;
import kr.co.solfood.user.login.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/user/mypage")
public class MypageController {

    @Autowired
    private LoginService loginService;

    @Autowired
    private MypageService mypageService;

    @Autowired
    private LikeService likeService;

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
        return "user/info";
    }

    // 마이페이지 > 내정보 post
    @PostMapping("/info")
    public String updateMyPageInfo(@ModelAttribute UserVO userVO,
                                   HttpSession sess) {

        // 1. 로그인한 사용자 정보 가져오기
        UserVO loginUser = (UserVO) sess.getAttribute("userLoginSession");
        if(loginUser == null){
            return "redirect:login"; // 로그인 안되어있으면 로그인 페이지로 리다이렉트
        }

        // 2. userId 설정
        userVO.setUsersId(loginUser.getUsersId());

        // 3. service update
        mypageService.updateUserInfo(userVO);

        // 4. 세션정보 갱신
        return "redirect:mypage";
    }

}
