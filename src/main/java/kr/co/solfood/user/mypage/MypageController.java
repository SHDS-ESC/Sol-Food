package kr.co.solfood.user.mypage;

import kr.co.solfood.user.like.LikeService;
import kr.co.solfood.user.login.CompanyVO;
import kr.co.solfood.user.login.LoginService;
import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.util.CustomException;
import kr.co.solfood.util.ErrorCode;
import kr.co.solfood.user.store.StoreVO;
import kr.co.solfood.util.PageMaker;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
    public String myPage(Model model, HttpSession sess) {
        UserVO userVO = (UserVO) sess.getAttribute("userLoginSession");
        if(userVO == null){
            throw new CustomException(ErrorCode.UNAUTHORIZED);
        }

//
// CustomException 사용 예시 -> 비밀번호가 null 이거나 비어 있으면 ERROR ! -> kakao-login 시 에러 발생하므로 주석 처리
// 테스트 용으로 주석 남겨두고 추후 삭제할 것.
//
//        if(userVO.getUsersPwd() == null || userVO.getUsersPwd().trim().isEmpty()) {
//            throw new CustomException(ErrorCode.PASSWORD_NOT_FOUND);
//        }

        return "user/login/mypage";
    }

    // 마이페이지 > 내정보 get
    @GetMapping("/info")
    public String myPageInfo(Model model, HttpSession sess) {
        List<CompanyVO> companyList = loginService.getCompanyList();
        UserVO userVO = (UserVO) sess.getAttribute("userLoginSession");
        model.addAttribute("user", userVO);
        model.addAttribute("companyList", companyList);

        // 마이페이지 진행 세션 플래그 설정 (S3 업로드 보안용)
        sess.setAttribute("mypageInProgress", true);
        sess.setAttribute("uploadCount", 0);
        sess.setMaxInactiveInterval(30 * 60); // 30분 후 만료
        return "user/login/info";
    }

    // 마이페이지 > 내정보 post
    @PostMapping("/info")
    public String updateMyPageInfo(@ModelAttribute UserVO userVO,
                                   HttpSession sess, HttpServletRequest request) {

        // 1. 로그인한 사용자 정보 가져오기
        UserVO loginUser = (UserVO) sess.getAttribute("userLoginSession");
        if(loginUser == null){
            return "redirect:/user/login"; // 로그인 안되어있으면 로그인 페이지로 리다이렉트
        }

        // 2. userId 설정
        userVO.setUsersId(loginUser.getUsersId());

        // 3. service update
        mypageService.updateUserInfo(userVO);

        // 마이페이지 완료 후 세션 정리
        sess.removeAttribute("mypageInProgress");
        sess.removeAttribute("uploadCount");

        // 기존 세션 정보를 유지하면서 수정된 정보만 업데이트
        if(userVO.getUsersNickname() != null && !userVO.getUsersNickname().trim().isEmpty()) {
            loginUser.setUsersNickname(userVO.getUsersNickname());
        }
        if(userVO.getUsersProfile() != null && !userVO.getUsersProfile().trim().isEmpty()) {
            loginUser.setUsersProfile(userVO.getUsersProfile());
        }
        loginUser.setCompanyId(userVO.getCompanyId());
        loginUser.setDepartmentId(userVO.getDepartmentId());
        loginUser.setUsersEmail(userVO.getUsersEmail());
        loginUser.setUsersTel(userVO.getUsersTel());
        loginUser.setUsersName(userVO.getUsersName());
        loginUser.setUsersGender(userVO.getUsersGender());
        loginUser.setUsersBirth(userVO.getUsersBirth());
        sess.setAttribute("userLoginSession", loginUser);

        // 4. 세션정보 갱신
        return "redirect:/";
    }

    // 마이페이지 > 회원탈퇴 post
    @PostMapping("/withdraw")
    public String withdrawUser(HttpSession sess,RedirectAttributes redirectAttributes) {
        // 1. 로그인한 사용자 정보 가져오기
        UserVO loginUser = (UserVO) sess.getAttribute("userLoginSession");
        if(loginUser == null){
            return "redirect:/user/login";  // 로그인 안되어있으면 로그인 페이지로
        }
        // 2. DB업데이트 - status를 "탈퇴"로 변경
        boolean success = mypageService.withdrawUser(loginUser.getUsersId());

        if(success){
            // 3. 세션 무효화 (로그아웃 처리)
            sess.invalidate();
            redirectAttributes.addFlashAttribute("msg", "정상적으로 탈퇴 처리되었습니다.");
            return "redirect:/user/login";
        } else {
            redirectAttributes.addFlashAttribute("msg", "탈퇴 실패");
            return "redirect:/user/mypage/info";
        }


    }

    // 마이페이지 > 찜한 가게 목록
    @GetMapping("/like")
    public String getLikedStores(HttpSession session, StoreVO storeVO, Model model){
        //1. 세션에서 사용자 ID 가져오기
        UserVO loginUser = (UserVO) session.getAttribute("userLoginSession");
        Long usersId = loginUser.getUsersId();

        //2. 찜 목록 조회
        PageMaker<StoreVO> pageMaker = mypageService.getLikedStores(usersId, storeVO);

        //3. 모델에 데이터 추가
        model.addAttribute("pageMaker", pageMaker);
        model.addAttribute("totalCount", pageMaker.getCount());

        return "user/login/like";
    }

    // 마이페이지 > json
    @GetMapping("/like/api")
    @ResponseBody
    public Map<String, Object> getLikedStoresApi(
            HttpSession session,
            StoreVO storeVO
    ){
        UserVO loginUser = (UserVO) session.getAttribute("userLoginSession");
        Long usersId = loginUser.getUsersId();

        PageMaker<StoreVO> pageMaker = mypageService.getLikedStoresApi(usersId, storeVO);

        boolean hasNext = false;
        if( storeVO.getOffset() + storeVO.getPageSize() < pageMaker.getCount()){
            hasNext = true;
        }

        //json 형태로 결과 반환
        Map<String, Object> result = new HashMap<>();
        result.put("list", pageMaker.getList());
        result.put("totalCount", pageMaker.getCount());
        result.put("offset", storeVO.getOffset());
        result.put("pageSize", storeVO.getPageSize());
        result.put("hasNext", hasNext);

        return result;
    }

}
