package kr.co.solfood.user.mypage;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.beans.factory.annotation.Value;

@Controller
public class MypageController {

    @GetMapping("/user/mypage")
    public void myPage(Model model, @Value("${imp.code}") String impCode) {
        model.addAttribute("impCode", impCode);
    }
}
