package kr.co.solfood.user.payment;

import java.io.IOException;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;

@RestController
@RequestMapping("/payment")
public class PaymentController {

    @Value("${imp.api.key}")
    private String apiKey;

    @Value("${imp.api.secretkey}")
    private String apiSecret;

    private IamportClient iamportClient;

    // Bean 초기화 후 IamportClient 생성
    @PostConstruct
    public void init() {
        iamportClient = new IamportClient(apiKey, apiSecret);
    }

    @GetMapping("")
    public void payment() {;}

    // 결제 완료 후 imp_uid로 결제 정보 검증 API 호출
    @PostMapping("/verifyIamport/{imp_uid}")
    public IamportResponse<Payment> paymentByImpUid(@PathVariable("imp_uid") String imp_uid)
            throws IamportResponseException, IOException {
        // 아임포트 서버에서 결제 정보 조회
        IamportResponse<Payment> paymentResponse = iamportClient.paymentByImpUid(imp_uid);
        Payment payment = paymentResponse.getResponse();

        // TODO: payment.getAmount()와 실제 주문 금액 비교 후 DB 저장 등 추가 처리

        return paymentResponse;
    }
}
