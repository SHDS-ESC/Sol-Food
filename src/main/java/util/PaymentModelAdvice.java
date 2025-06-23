package util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

// 전역적인 설정값 지정가능, but 리다이렉트에선 쿼리 스트링에 포함되므로 이렇게 처리하는게 좋지 않을 수도.
//@ControllerAdvice(basePackages = "kr.co.solfood.user")
@ControllerAdvice(assignableTypes = {PaymentModelAdvice.class} )
public class PaymentModelAdvice {
    @Value("${imp.code}")
    private String impCode;

    @ModelAttribute("impCode")
    public String impCode() {
        return impCode;
    }
}