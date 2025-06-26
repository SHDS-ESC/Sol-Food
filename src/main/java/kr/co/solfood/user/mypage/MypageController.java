package kr.co.solfood.user.mypage;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import org.springframework.beans.factory.annotation.Value;

@RequestMapping("/user/mypage")
@Controller
public class MypageController {

    @GetMapping("")
    public void myPage() {}

    // 결제 페이지에는 impCode를 전달해야함.
    @GetMapping("/charge")
    public void charge(Model model, @Value("${imp.code}") String impCode) {
        model.addAttribute("impCode", impCode);
    }

    @GetMapping("/charge-history")
    public String chargeHistoryPage(Model model) {
        // 페이지 렌더링만 담당, 데이터는 JavaScript로 API 호출
        return "user/mypage/charge-history";
    }

}