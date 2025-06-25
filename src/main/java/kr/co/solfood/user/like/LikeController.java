package kr.co.solfood.user.like;

import kr.co.solfood.user.login.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user/like")
public class LikeController {

    @Autowired
    private LikeService service;

    // 찜 추가
    @GetMapping("/add")
    @ResponseBody
    public Map<String, Object> addLike(HttpSession session, @RequestParam int storeId) {
        UserVO loginUser = (UserVO) session.getAttribute("userLoginSession"); // ★ 여기 key명을 반드시 일치!
        long usersId = loginUser.getUsersId();
        boolean success = service.addLike((int) usersId, storeId);
        System.out.println(success);
        Map<String, Object> result = new HashMap<>();
        result.put("result", success ? "success" : "fail" );
        return result;
    }

    // 찜 취소
    @GetMapping("/cancel")
    @ResponseBody
    public Map<String, Object> cancelLike(HttpSession session, @RequestParam int storeId) {
        UserVO loginUser = (UserVO) session.getAttribute("userLoginSession"); // 세션에서 꺼냄
        long usersId = loginUser.getUsersId();
        boolean success = service.cancelLike((int) usersId, storeId);

        Map<String, Object> result = new HashMap<>();
        result.put("result", success ? "success" : "fail");
        return result;
    }

}
