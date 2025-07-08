package kr.co.solfood.payments.charge;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpSession;

import kr.co.solfood.user.login.UserVO;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.request.CancelData;
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

    /**
     * 결제 취소/환불 처리
     */
    @PostMapping("/cancel")
    @ResponseBody
    public Map<String, Object> cancelPayment(@RequestBody Map<String, Object> request, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String impUid = (String) request.get("imp_uid");
            Integer cancelAmount = (Integer) request.get("cancel_amount"); // null이면 전액 취소
            String cancelReason = (String) request.get("cancel_reason");
            
            // 1. 아임포트 API로 결제 취소
            CancelData cancelData;
            if (cancelAmount != null) {
                cancelData = new CancelData(impUid, true, new BigDecimal(cancelAmount));
            } else {
                cancelData = new CancelData(impUid, true);
            }

            cancelData.setReason(cancelReason);
            
            IamportResponse<Payment> iamportResponse = iamportClient.cancelPaymentByImpUid(cancelData);
            
            if (iamportResponse.getResponse() != null) {
                Payment cancelledPayment = iamportResponse.getResponse();
                
                // 2. DB 업데이트
                ChargeVO chargeVO = chargeService.getChargeByImpUid(impUid);
                if (chargeVO != null) {
                    // 포인트 차감 (전액 취소면 전체 차감, 부분 취소면 해당 금액만 차감)
                    UserVO user = (UserVO) session.getAttribute("userLoginSession");
                    user.setUsersId(chargeVO.getUsersId());
                    
                    int deductAmount = (cancelAmount != null) ? cancelAmount : chargeVO.getAmount();
                    user.setUsersPoint(user.getUsersPoint()-deductAmount); // 음수로 차감
                    chargeService.updateUserPoint(user);
                    
                    // 충전 내역 업데이트
                    chargeVO.setCancelAmount(deductAmount);
                    chargeVO.setCancelReason(cancelReason);
                    java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
                    chargeVO.setCancelledAt(now);
                    chargeVO.setStatus("cancelled");
                    chargeVO.setUpdatedAt(now);
                    
                    chargeService.updateCharge(chargeVO);
                    
                    response.put("success", true);
                    response.put("message", "결제가 성공적으로 취소되었습니다.");
                    response.put("cancel_amount", chargeVO.getCancelAmount());
                } else {
                    response.put("success", false);
                    response.put("message", "해당 결제 내역을 찾을 수 없습니다.");
                }
            } else {
                response.put("success", false);
                response.put("message", "결제 취소 처리 중 오류가 발생했습니다.");
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "결제 취소 처리 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        return response;
    }

    /**
     * 결제 취소 가능 여부 확인
     */
    @GetMapping("/cancel/check/{imp_uid}")
    @ResponseBody
    public Map<String, Object> checkCancelable(@PathVariable String imp_uid) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            ChargeVO chargeVO = chargeService.getChargeByImpUid(imp_uid);
            
            if (chargeVO != null) {
                // 취소 가능 조건 체크 (실제로 취소되지 않은 경우)
                boolean canCancel = "paid".equals(chargeVO.getStatus()) && !chargeVO.isActuallyCancelled();
                
                response.put("success", true);
                response.put("can_cancel", canCancel);
                response.put("charge_info", chargeVO);
                
                if (canCancel) {
                    response.put("cancelable_amount", chargeVO.getAmount());
                }
            } else {
                response.put("success", false);
                response.put("message", "해당 결제 내역을 찾을 수 없습니다.");
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "취소 가능 여부 확인 중 오류가 발생했습니다: " + e.getMessage());
        }
        System.out.println(response.toString());
        return response;
    }

    /**
     * 충전 내역 조회 API
     */
    @GetMapping("/history")
    @ResponseBody
    public Map<String, Object> getChargeHistory(
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
            
            List<ChargeVO> history = chargeService.getChargeHistory(user.getUsersId(), page, size);
            
            response.put("success", true);
            response.put("data", history);
            response.put("page", page);
            response.put("size", size);
            response.put("total_count", history.size());
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "충전 내역 조회 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        return response;
    }

}
