package kr.co.solfood.payments.payment;

import java.io.IOException;
import java.math.BigDecimal;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpSession;

import kr.co.solfood.user.login.UserVO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;

@RestController
@RequestMapping("/payments/payment")
public class PaymentController {

    private final PaymentService paymentService;
    private final String apiKey;
    private final String apiSecret;
    private IamportClient iamportClient;

    // 생성자 주입
    public PaymentController(
        PaymentService paymentService,
        @Value("${imp.api.key}") String apiKey,
        @Value("${imp.api.secretkey}") String apiSecret
    ) {
        this.paymentService = paymentService;
        this.apiKey = apiKey;
        this.apiSecret = apiSecret;
    }

    @PostConstruct
    public void init() {
        iamportClient = new IamportClient(apiKey, apiSecret);
    }

    @PostMapping("/verifyPayment/{imp_uid}")
    public IamportResponse<Payment> verifyPayment(
            @PathVariable("imp_uid") String imp_uid,
            @RequestParam("amount") int requestedAmount,
            @RequestParam("merchant_uid") String merchantUid,
            HttpSession session
    ) throws IamportResponseException, IOException {
    
        IamportResponse<Payment> paymentResponse = iamportClient.paymentByImpUid(imp_uid);
        Payment payment = paymentResponse.getResponse();
    
        // 1. 결제 금액 검증
        if (payment.getAmount().intValue() != requestedAmount) {
            throw new IllegalArgumentException("결제 금액이 일치하지 않습니다.");
        }
    
        // 2. 결제 성공 여부 검증
        if (!"paid".equals(payment.getStatus())) {
            throw new IllegalStateException("결제가 완료되지 않았습니다.");
        }
    
        // 3. 중복 충전 방지 (DB에서 imp_uid로 중복 체크)
        if (paymentService.isAlreadyProcessed(imp_uid)) {
            throw new IllegalStateException("이미 처리된 결제입니다.");
        }
    
        // 4. 포인트 적립 (트랜잭션 처리)
        UserVO user = (UserVO) session.getAttribute("userLoginSession");
        BigDecimal currentPoint = new BigDecimal(user.getUsersPoint());
        BigDecimal newPoint = currentPoint.add(payment.getAmount());
        user.setUsersPoint(newPoint.intValue());
        paymentService.updateUserPoint(user);
    
        // 5. imp_uid 기록 (중복 방지)
        paymentService.saveProcessedImpUid(imp_uid);
    
        // 6. 세션 업데이트
        session.setAttribute("userLoginSession", user);
    
        return paymentResponse;
    }

}
