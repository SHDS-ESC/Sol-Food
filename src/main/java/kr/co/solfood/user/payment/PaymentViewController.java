package kr.co.solfood.user.payment;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PaymentViewController {

    @Value("${imp.code}")
    private String impKey;

    @GetMapping("/user/payment")
    public String paymentPage(Model model) {
        model.addAttribute("impKey", impKey);
        return "user/payment"; // /WEB-INF/views/user/payment.jsp
    }
}