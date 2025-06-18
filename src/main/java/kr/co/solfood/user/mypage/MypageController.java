package kr.co.solfood.user.mypage;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MypageController {

    @GetMapping("/user/mypage")
    public void myPage(Model model) {
    }
}
