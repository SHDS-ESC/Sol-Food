package util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice(basePackages = "kr.co.solfood.user")
public class PaymentModelAdvice {
    @Value("${imp.code}")
    private String impKey;

    @ModelAttribute("impKey")
    public String impKey() {
        return impKey;
    }
}