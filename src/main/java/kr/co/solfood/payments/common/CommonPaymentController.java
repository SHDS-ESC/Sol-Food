package kr.co.solfood.payments.common;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.request.CancelData;
import com.siot.IamportRestClient.response.IamportResponse;
import com.siot.IamportRestClient.response.Payment;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import kr.co.solfood.payments.charge.ChargeVO;
import kr.co.solfood.payments.payment.PaymentVO;

@RestController
@RequestMapping("/payments/common")
public class CommonPaymentController {

    private static final Logger log = LoggerFactory.getLogger(CommonPaymentController.class);

    private final CommonPaymentMapper commonPaymentMapper;
    private final String apiKey;
    private final String apiSecret;
    private IamportClient iamportClient;

    public CommonPaymentController(
        CommonPaymentMapper commonPaymentMapper,
        @Value("${imp.api.key}") String apiKey,
        @Value("${imp.api.secretkey}") String apiSecret
    ) {
        this.commonPaymentMapper = commonPaymentMapper;
        this.apiKey = apiKey;
        this.apiSecret = apiSecret;
    }

    @PostConstruct
    public void init() {
        iamportClient = new IamportClient(apiKey, apiSecret);
    }

    /**
     * 통합 결제 취소/환불 처리
     * @param request 취소 요청 데이터 (imp_uid, cancel_amount, cancel_reason, payment_type)
     * @param session HTTP 세션
     * @return 취소 처리 결과
     */
    @PostMapping("/cancel")
    @ResponseBody
    public Map<String, Object> cancelPayment(@RequestBody Map<String, Object> request, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String impUid = (String) request.get("imp_uid");
            Integer cancelAmount = (Integer) request.get("cancel_amount"); // null이면 전액 취소
            String cancelReason = (String) request.get("cancel_reason");
            String paymentType = (String) request.get("payment_type"); // "charge" 또는 "payment"
            
            if (impUid == null) {
                response.put("success", false);
                response.put("message", "imp_uid가 필요합니다.");
                return response;
            }
            
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
                
                // 2. 결제 타입에 따라 DB 업데이트
                boolean dbUpdateSuccess = false;
                if ("charge".equals(paymentType)) {
                    // 충전 취소 시 포인트 차감
                    ChargeVO chargeInfo = commonPaymentMapper.getChargeByImpUid(impUid);
                    if (chargeInfo != null) {
                        int deductAmount = (cancelAmount != null) ? cancelAmount : chargeInfo.getAmount();
                        commonPaymentMapper.updateUserPointAfterChargeCancel(chargeInfo.getUsersId(), deductAmount);
                    }
                    dbUpdateSuccess = commonPaymentMapper.updateChargeAfterCancel(impUid, cancelAmount, cancelReason);
                } else if ("payment".equals(paymentType)) {
                    dbUpdateSuccess = commonPaymentMapper.updatePaymentAfterCancel(impUid, cancelAmount, cancelReason);
                } else {
                    // payment_type이 지정되지 않은 경우, 자동으로 타입 감지
                    ChargeVO paymentInfo = commonPaymentMapper.getAnyPaymentByImpUid(impUid);
                    if (paymentInfo != null && paymentInfo.getChargeId() > 0) {
                        // 충전 결제인 경우 포인트 차감
                        int deductAmount = (cancelAmount != null) ? cancelAmount : paymentInfo.getAmount();
                        commonPaymentMapper.updateUserPointAfterChargeCancel(paymentInfo.getUsersId(), deductAmount);
                    }
                    dbUpdateSuccess = commonPaymentMapper.updateAnyPaymentAfterCancel(impUid, cancelAmount, cancelReason);
                }
                
                if (dbUpdateSuccess) {
                    response.put("success", true);
                    response.put("message", "결제가 성공적으로 취소되었습니다.");
                    response.put("cancel_amount", cancelAmount != null ? cancelAmount : cancelledPayment.getAmount().intValue());
                } else {
                    response.put("success", false);
                    response.put("message", "DB 업데이트에 실패했습니다.");
                }
            } else {
                log.error("아임포트 결제 취소 실패: " + iamportResponse.getMessage());
                response.put("success", false);
                response.put("message", "결제 취소 실패: " + (iamportResponse.getMessage() != null ? iamportResponse.getMessage() : "알 수 없는 오류"));
            }
            
        } catch (Exception e) {
            log.error("결제 취소 처리 중 오류", e);
            response.put("success", false);
            response.put("message", "결제 취소 처리 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        return response;
    }

    /**
     * 통합 결제 취소 가능 여부 확인
     * @param impUid 아임포트 결제 고유번호
     * @param paymentType 결제 타입 ("charge" 또는 "payment")
     * @return 취소 가능 여부 및 결제 정보
     */
    @GetMapping("/cancel/check/{imp_uid}")
    @ResponseBody
    public Map<String, Object> checkCancelable(
            @PathVariable("imp_uid") String impUid,
            @RequestParam(value = "payment_type", required = false) String paymentType) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            Object paymentInfo = null;
            boolean canCancel = false;
            Integer cancelableAmount = null;
            
            if ("charge".equals(paymentType)) {
                // 충전 결제 확인
                ChargeVO chargeInfo = commonPaymentMapper.getChargeByImpUid(impUid);
                if (chargeInfo != null) {
                    canCancel = ("paid".equals(chargeInfo.getStatus()) || "completed".equals(chargeInfo.getStatus())) && !chargeInfo.isActuallyCancelled();
                    if (canCancel) {
                        cancelableAmount = chargeInfo.getAmount();
                    }
                    paymentInfo = chargeInfo;
                }
            } else if ("payment".equals(paymentType)) {
                // 일반 결제 확인
                PaymentVO paymentVO = commonPaymentMapper.getPaymentByImpUid(impUid);
                if (paymentVO != null) {
                    canCancel = ("paid".equals(paymentVO.getStatus()) || "completed".equals(paymentVO.getStatus())) && !paymentVO.isActuallyCancelled();
                    if (canCancel) {
                        cancelableAmount = paymentVO.getAmount();
                    }
                    paymentInfo = paymentVO;
                }
            } else {
                // payment_type이 지정되지 않은 경우, 둘 다 확인
                ChargeVO anyPaymentInfo = commonPaymentMapper.getAnyPaymentByImpUid(impUid);
                if (anyPaymentInfo != null) {
                    canCancel = ("paid".equals(anyPaymentInfo.getStatus()) || "completed".equals(anyPaymentInfo.getStatus())) && !anyPaymentInfo.isActuallyCancelled();
                    if (canCancel) {
                        cancelableAmount = anyPaymentInfo.getAmount();
                    }
                    paymentInfo = anyPaymentInfo;
                }
            }
            
            if (paymentInfo != null) {
                response.put("success", true);
                response.put("can_cancel", canCancel);
                response.put("payment_info", paymentInfo);
                if (canCancel) {
                    response.put("cancelable_amount", cancelableAmount);
                }
            } else {
                response.put("success", false);
                response.put("message", "해당 결제 내역을 찾을 수 없습니다.");
            }
            
        } catch (Exception e) {
            log.error("취소 가능 여부 확인 중 오류", e);
            response.put("success", false);
            response.put("message", "취소 가능 여부 확인 중 오류가 발생했습니다: " + e.getMessage());
        }
        
        return response;
    }
} 