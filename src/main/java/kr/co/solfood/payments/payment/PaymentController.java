package kr.co.solfood.payments.payment;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpSession;

import kr.co.solfood.common.constants.UrlConstants;
import kr.co.solfood.user.cart.CartVO;
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
    
        // 1. 결제 금액 검증 -> 혼자 결제하는 금액과 전체 결제 금액 검증 필요
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
        UserVO user = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        BigDecimal currentPoint = new BigDecimal(user.getUsersPoint());
        BigDecimal newPoint = currentPoint.add(payment.getAmount());
        user.setUsersPoint(newPoint.intValue());
        paymentService.updateUserPoint(user);
    
        // 5. CartVO를 세션에서 꺼내서 PaymentVO 생성 및 DB 기록
        CartVO cart = (CartVO) session.getAttribute(UrlConstants.Session.USER_CART);
        if (cart == null) {
            throw new IllegalStateException("장바구니 정보가 없습니다. 결제를 진행할 수 없습니다.");
        }
        PaymentVO paymentVO = buildPaymentVO(payment, user, imp_uid, merchantUid, cart);
        paymentService.insertPayment(paymentVO);
    
        // 6. 세션 업데이트
        session.setAttribute(UrlConstants.Session.USER_LOGIN_SESSION, user);
    
        return paymentResponse;
    }

    // PaymentVO 생성 로직을 별도 함수로 분리
    private PaymentVO buildPaymentVO(Payment payment, UserVO user, String imp_uid, String merchantUid, CartVO cart) {
        PaymentVO paymentVO = new PaymentVO();
        paymentVO.setUsersId((int)user.getUsersId());
        // paymentVO.setIntergratedpaymentId(통합결제ID); // 필요시
        // 결제 금액 계산 및 세팅
        int usedPoint = 0;  // 포인트 사용액 넣기
        int paidAmount = cart != null ? cart.getTotalAmount() - usedPoint : 0;
        paymentVO.setPaymentUsedPoint(usedPoint);
        paymentVO.setPaymentPaidAmount(paidAmount);
        // 결제 공통 필드
        paymentVO.setImpUid(imp_uid);
        paymentVO.setMerchantUid(merchantUid);
        paymentVO.setPayMethod(payment.getPayMethod());
        paymentVO.setPgProvider(payment.getPgProvider());
        paymentVO.setPgTid(payment.getPgTid());
        paymentVO.setReceiptUrl(payment.getReceiptUrl());
        paymentVO.setStatus(payment.getStatus());
        paymentVO.setStatusDetail(null);
        paymentVO.setAmount(payment.getAmount().intValue());
        paymentVO.setCancelAmount(payment.getCancelAmount() != null ? payment.getCancelAmount().intValue() : null);
        paymentVO.setBuyerName(payment.getBuyerName());
        paymentVO.setBuyerEmail(payment.getBuyerEmail());
        paymentVO.setBuyerTel(payment.getBuyerTel());
        paymentVO.setFailReason(payment.getFailReason());
        paymentVO.setCancelReason(payment.getCancelReason());
        if (payment.getPaidAt() != null) {
            paymentVO.setPaidAt(new java.sql.Timestamp(payment.getPaidAt().getTime()));
        }
        if (payment.getCancelledAt() != null) {
            paymentVO.setCancelledAt(new java.sql.Timestamp(payment.getCancelledAt().getTime()));
        }
        paymentVO.setCreatedAt(java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
        paymentVO.setUpdatedAt(java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
        return paymentVO;
    }

    /*
        결제 내역 조회 API
    */
    @GetMapping("/history")
    @ResponseBody
    public Map<String, Object> getPaymentHistory(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            UserVO user = (UserVO) session.getAttribute("userLoginSession");
            if (user == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }
            List<PaymentVO> history = paymentService.getPaymentHistory((int)user.getUsersId(), page, size);

            response.put("success", true);
            response.put("data", history);
            response.put("page", page);
            response.put("size", size);
            response.put("total_count", history.size());

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "" + e.getMessage());
        }
        return response;
    }

}
