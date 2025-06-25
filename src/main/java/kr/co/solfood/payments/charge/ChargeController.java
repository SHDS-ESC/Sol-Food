package kr.co.solfood.payments.charge;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

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
@RequestMapping("/payments/charge")
public class ChargeController {

    private final ChargeService chargeService;
    private final String apiKey;
    private final String apiSecret;
    private IamportClient iamportClient;

    // 생성자 주입
    public ChargeController(
        ChargeService chargeService,
        @Value("${imp.api.key}") String apiKey,
        @Value("${imp.api.secretkey}") String apiSecret
    ) {
        this.chargeService = chargeService;
        this.apiKey = apiKey;
        this.apiSecret = apiSecret;
    }

    @PostConstruct
    public void init() {
        iamportClient = new IamportClient(apiKey, apiSecret);
    }

    @PostMapping("/verifyCharge/{imp_uid}")
    public IamportResponse<Payment> verifyCharge(
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
        if (chargeService.isAlreadyProcessed(imp_uid)) {
            throw new IllegalStateException("이미 처리된 결제입니다.");
        }
    
        // 4. 포인트 적립 (트랜잭션 처리)
        UserVO user = (UserVO) session.getAttribute("userLoginSession");
        BigDecimal currentPoint = new BigDecimal(user.getUsersPoint());
        BigDecimal newPoint = currentPoint.add(payment.getAmount());
        user.setUsersPoint(newPoint.intValue());
        chargeService.updateUserPoint(user);
    
        // 5. ChargeVO 생성 및 DB 기록 (모든 필드 세팅)
        ChargeVO chargeVO = buildChargeVO(payment, user, imp_uid, merchantUid);
        chargeService.insertCharge(chargeVO);
    
        // 6. 세션 업데이트
        session.setAttribute("userLoginSession", user);
    
        return paymentResponse;
    }

    // ChargeVO 생성 로직을 별도 함수로 분리
    private ChargeVO buildChargeVO(Payment payment, UserVO user, String imp_uid, String merchantUid) {
        ChargeVO chargeVO = new ChargeVO();
        // ChargeVO 고유 필드
        chargeVO.setUsersId((int)user.getUsersId());

        // PaymentCommonVO 상속 필드
        chargeVO.setImpUid(imp_uid);
        chargeVO.setMerchantUid(merchantUid);
        chargeVO.setPayMethod(payment.getPayMethod());
        chargeVO.setPgProvider(payment.getPgProvider());
        chargeVO.setPgTid(payment.getPgTid());
        chargeVO.setReceiptUrl(payment.getReceiptUrl());
        chargeVO.setStatus(payment.getStatus());
        chargeVO.setStatusDetail(null); // 아임포트 Payment에 상세 사유가 있으면 세팅
        chargeVO.setAmount(payment.getAmount() != null ? payment.getAmount().intValue() : null);
        chargeVO.setCancelAmount(payment.getCancelAmount() != null ? payment.getCancelAmount().intValue() : null);
        chargeVO.setBuyerName(payment.getBuyerName());
        chargeVO.setBuyerEmail(payment.getBuyerEmail());
        chargeVO.setBuyerTel(payment.getBuyerTel());
        chargeVO.setFailReason(payment.getFailReason());
        chargeVO.setCancelReason(payment.getCancelReason());
        if (payment.getPaidAt() != null) {
            chargeVO.setPaidAt(new java.sql.Timestamp(payment.getPaidAt().getTime()));
        }
        if (payment.getCancelledAt() != null) {
            chargeVO.setCancelledAt(new java.sql.Timestamp(payment.getCancelledAt().getTime()));
        }
        chargeVO.setCreatedAt(java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
        chargeVO.setUpdatedAt(java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
        return chargeVO;
    }

}
