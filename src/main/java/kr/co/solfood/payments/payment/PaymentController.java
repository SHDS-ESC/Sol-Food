package kr.co.solfood.payments.payment;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
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
import kr.co.solfood.payments.integrated.IntegratedPaymentVO;
import kr.co.solfood.payments.integrated.IntegratedPaymentService;
import kr.co.solfood.user.login.LoginService;
import kr.co.solfood.user.cart.GroupPaymentManager;

@RestController
@RequestMapping("/payments/payment")
public class PaymentController {

    private final PaymentService paymentService;
    private final IntegratedPaymentService integratedPaymentService;
    private final LoginService loginService;
    private final GroupPaymentManager groupPaymentManager;
    private final String apiKey;
    private final String apiSecret;
    private IamportClient iamportClient;

    // 생성자 주입
    public PaymentController(
        PaymentService paymentService,
        IntegratedPaymentService integratedPaymentService,
        LoginService loginService,
        GroupPaymentManager groupPaymentManager,
        @Value("${imp.api.key}") String apiKey,
        @Value("${imp.api.secretkey}") String apiSecret
    ) {
        this.paymentService = paymentService;
        this.integratedPaymentService = integratedPaymentService;
        this.loginService = loginService;
        this.groupPaymentManager = groupPaymentManager;
        this.apiKey = apiKey;
        this.apiSecret = apiSecret;
    }

    @PostConstruct
    public void init() {
        iamportClient = new IamportClient(apiKey, apiSecret);
    }

    /**
     * 발의자용 통합 결제 API
     * 세션의 사용자 정보로 진행중인 발의자 결제를 찾아서 바로 결제 처리
     */
    @PostMapping("/leader-payment/verify")
    public IamportResponse<Payment> verifyLeaderPayment(
            @RequestParam("imp_uid") String imp_uid,
            @RequestParam("amount") int requestedAmount,
            @RequestParam("merchant_uid") String merchantUid,
            HttpSession session
    ) throws IamportResponseException, IOException {
    
        IamportResponse<Payment> paymentResponse = iamportClient.paymentByImpUid(imp_uid);
        Payment payment = paymentResponse.getResponse();
    
        // 1. 결제 금액 검증 (PG사에서 실제 결제된 금액과 요청 금액 비교)
        if (payment.getAmount().intValue() != requestedAmount) {
            throw new IllegalArgumentException("결제 금액이 일치하지 않습니다. 요청: " + requestedAmount + ", 실제: " + payment.getAmount().intValue());
        }
    
        // 2. 결제 성공 여부 검증
        if (!"paid".equals(payment.getStatus())) {
            throw new IllegalStateException("결제가 완료되지 않았습니다.");
        }
    
        // 3. 중복 결제 방지
        if (paymentService.isAlreadyProcessed(imp_uid)) {
            throw new IllegalStateException("이미 처리된 결제입니다.");
        }
        
        // 3-1. merchant_uid 중복 체크
        if (paymentService.isMerchantUidAlreadyUsed(merchantUid)) {
            throw new IllegalStateException("이미 사용된 주문번호입니다: " + merchantUid);
        }
    
        // 4. 사용자 검증
        UserVO user = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (user == null) {
            throw new IllegalStateException("로그인이 필요합니다.");
        }
    
        // 5. 발의자의 진행중인 결제 찾기
        PaymentVO leaderPayment = paymentService.getLeaderPaymentByUserId(user.getUsersId());
        if (leaderPayment == null) {
            throw new IllegalStateException("진행중인 발의자 결제가 없습니다.");
        }
        
        // pending 상태인지 확인
        if (!"pending".equals(leaderPayment.getStatus())) {
            throw new IllegalStateException("결제 가능한 상태가 아닙니다.");
        }
    
        // 6. 결제 정보 업데이트
        updatePaymentWithIamportData(leaderPayment, payment, imp_uid, merchantUid);
        paymentService.updatePayment(leaderPayment);
        
        // 7. 그룹 결제 상태 업데이트 (SSE 알림용)
        groupPaymentManager.updatePaymentStatus(leaderPayment.getIntegratedpaymentId(), user.getUsersId(), "paid");
    
        return paymentResponse;
    }

    /**
     * 통합 결제 검증 API
     * Payment ID로 직접 결제 처리
     */
    @PostMapping("/verify/{paymentId}")
    public IamportResponse<Payment> verifyPayment(
            @PathVariable("paymentId") int paymentId,
            @RequestParam("imp_uid") String imp_uid,
            @RequestParam("amount") int requestedAmount,
            @RequestParam("merchant_uid") String merchantUid,
            HttpSession session
    ) throws IamportResponseException, IOException {
    
        IamportResponse<Payment> paymentResponse = iamportClient.paymentByImpUid(imp_uid);
        Payment payment = paymentResponse.getResponse();
    
        // 1. 결제 금액 검증 (PG사에서 실제 결제된 금액과 요청 금액 비교)
        if (payment.getAmount().intValue() != requestedAmount) {
            throw new IllegalArgumentException("결제 금액이 일치하지 않습니다. 요청: " + requestedAmount + ", 실제: " + payment.getAmount().intValue());
        }
    
        // 2. 결제 성공 여부 검증
        if (!"paid".equals(payment.getStatus())) {
            throw new IllegalStateException("결제가 완료되지 않았습니다.");
        }
    
        // 3. 중복 결제 방지
        if (paymentService.isAlreadyProcessed(imp_uid)) {
            throw new IllegalStateException("이미 처리된 결제입니다.");
        }
        
        // 3-1. merchant_uid 중복 체크
        if (paymentService.isMerchantUidAlreadyUsed(merchantUid)) {
            throw new IllegalStateException("이미 사용된 주문번호입니다: " + merchantUid);
        }
    
        // 4. 사용자 검증
        UserVO user = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (user == null) {
            throw new IllegalStateException("로그인이 필요합니다.");
        }
    
        // 5. Payment 정보 조회 및 검증
        PaymentVO targetPayment = paymentService.getPaymentById(paymentId);
        if (targetPayment == null) {
            throw new IllegalStateException("결제 정보를 찾을 수 없습니다.");
        }
        
        // 본인의 결제인지 확인
        if (targetPayment.getUsersId() != user.getUsersId()) {
            throw new IllegalStateException("본인의 결제가 아닙니다.");
        }
        
        // pending 상태인지 확인
        if (!"pending".equals(targetPayment.getStatus())) {
            throw new IllegalStateException("결제 가능한 상태가 아닙니다.");
        }
    
        // 6. 결제 정보 업데이트
        updatePaymentWithIamportData(targetPayment, payment, imp_uid, merchantUid);
        paymentService.updatePayment(targetPayment);
        
        // 7. 그룹 결제 상태 업데이트 (SSE 알림용)
        groupPaymentManager.updatePaymentStatus(targetPayment.getIntegratedpaymentId(), user.getUsersId(), "paid");
    
        return paymentResponse;
    }

    // Iamport 결제 데이터로 PaymentVO 업데이트
    private void updatePaymentWithIamportData(PaymentVO paymentVO, Payment payment, String imp_uid, String merchantUid) {
        paymentVO.setImpUid(imp_uid);
        paymentVO.setMerchantUid(merchantUid);
        paymentVO.setPayMethod(payment.getPayMethod());
        paymentVO.setPgProvider(payment.getPgProvider());
        paymentVO.setPgTid(payment.getPgTid());
        paymentVO.setReceiptUrl(payment.getReceiptUrl());
        paymentVO.setStatus(payment.getStatus());
        paymentVO.setStatusDetail("결제 완료");
        
        // Iamport에서 받은 금액은 실제 PG사 결제 금액
        int actualPaidAmount = payment.getAmount().intValue();
        paymentVO.setPaymentPaidAmount(actualPaidAmount);
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
        paymentVO.setUpdatedAt(java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
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

            // 각 결제에 대한 리뷰 작성 여부 확인
            for (PaymentVO payment : history) {
                boolean hasReview = paymentService.hasReviewForPayment(payment.getPaymentId(), user.getUsersId());
                payment.setHasReview(hasReview);
            }

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

    /*
        통합결제ID로 가게ID 조회 API
    */
    @GetMapping("/storeId")
    @ResponseBody
    public Map<String, Object> getStoreIdByIntegratedPaymentId(
            @RequestParam("integratedPaymentId") int integratedPaymentId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            UserVO user = (UserVO) session.getAttribute("userLoginSession");
            if (user == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Integer storeId = paymentService.getStoreIdByIntegratedPaymentId(integratedPaymentId);

            if (storeId != null) {
                response.put("success", true);
                response.put("data", storeId);
            } else {
                response.put("success", false);
                response.put("message", "해당 결제의 가게 정보를 찾을 수 없습니다.");
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "가게 정보 조회 중 오류가 발생했습니다: " + e.getMessage());
        }
        return response;
    }

    /**
     * Payment ID로 결제 정보 조회 API (참여자용 - 같은 integratedPaymentId의 모든 payment 조회)
     */
    @GetMapping("/{paymentId}")
    @ResponseBody
    public Map<String, Object> getPaymentById(
            @PathVariable int paymentId,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            UserVO user = (UserVO) session.getAttribute("userLoginSession");
            if (user == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            PaymentVO payment = paymentService.getPaymentById(paymentId);
            if (payment == null) {
                response.put("success", false);
                response.put("message", "결제 정보를 찾을 수 없습니다.");
                return response;
            }

            // 본인의 결제인지 확인
            if (payment.getUsersId() != user.getUsersId()) {
                response.put("success", false);
                response.put("message", "본인의 결제가 아닙니다.");
                return response;
            }

            // 같은 integratedPaymentId를 가진 모든 payment 조회
            List<PaymentVO> allPayments = paymentService.getPaymentsByIntegratedPaymentId(payment.getIntegratedpaymentId());
            
            // 각 payment에 대한 사용자 정보 조회
            List<Map<String, Object>> participants = new ArrayList<>();
            for (PaymentVO participantPayment : allPayments) {
                UserVO participant = loginService.getUserById(participantPayment.getUsersId());
                if (participant != null) {
                    Map<String, Object> participantInfo = new HashMap<>();
                    participantInfo.put("usersId", participant.getUsersId());
                    participantInfo.put("usersName", participant.getUsersName());
                    participantInfo.put("usersProfile", participant.getUsersProfile());
                    participantInfo.put("companyName", participant.getCompanyName());
                    participantInfo.put("departmentName", participant.getDepartmentName());
                    participantInfo.put("paymentAmount", participantPayment.getAmount());
                    participantInfo.put("paymentStatus", participantPayment.getStatus());
                    participantInfo.put("paymentId", participantPayment.getPaymentId());
                    participants.add(participantInfo);
                }
            }

            // 통합결제 정보 조회
            IntegratedPaymentVO integratedPayment = integratedPaymentService.getIntegratedPaymentById(payment.getIntegratedpaymentId());

            response.put("success", true);
            response.put("payment", payment);
            response.put("participants", participants);
            response.put("totalAmount", integratedPayment != null ? integratedPayment.getIntegratedpaymentAmount() : 0);
            response.put("integratedPaymentId", payment.getIntegratedpaymentId());

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "결제 정보 조회에 실패했습니다: " + e.getMessage());
        }
        return response;
    }

}
