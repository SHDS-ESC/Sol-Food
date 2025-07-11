package kr.co.solfood.user.invitation;

import kr.co.solfood.common.constants.UrlConstants;
import kr.co.solfood.payments.integrated.IntegratedPaymentService;
import kr.co.solfood.payments.integrated.IntegratedPaymentVO;
import kr.co.solfood.payments.payment.PaymentService;
import kr.co.solfood.payments.payment.PaymentVO;
import kr.co.solfood.user.login.LoginService;
import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.user.store.StoreService;
import kr.co.solfood.user.store.StoreVO;
import kr.co.solfood.util.CustomException;
import kr.co.solfood.util.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/user/invitations")
public class InvitationController {

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private IntegratedPaymentService integratedPaymentService;

    @Autowired
    private LoginService loginService;
    @Autowired
    private StoreService storeService;

    /**
     * 세션에서 유효한 사용자 정보를 가져옴
     */
    private UserVO getValidatedUser(HttpSession session) {
        UserVO user = (UserVO) session.getAttribute(UrlConstants.Session.USER_LOGIN_SESSION);
        if (user == null) {
            throw new CustomException(ErrorCode.UNAUTHORIZED);
        }
        return user;
    }

    /**
     * 초대받은 결제 페이지
     */
    @GetMapping
    public String invitationPage(HttpSession session) {
        getValidatedUser(session);
        return "user/invitation-payment";
    }

    /**
     * 초대받은 결제 목록 조회 API
     */
    @GetMapping("/api")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getInvitations(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            UserVO user = getValidatedUser(session);
            long usersId = user.getUsersId();
            
            // 사용자의 진행중인 결제 조회 (만료 여부 포함)
            List<Map<String, Object>> ongoingPayments = paymentService.getOngoingPaymentByUserIdWithExpiration(usersId);
            
            if (ongoingPayments == null || ongoingPayments.isEmpty()) {
                response.put("success", true);
                response.put("invitations", new ArrayList<>());
                return ResponseEntity.ok(response);
            }
            
            List<Map<String, Object>> invitations = new ArrayList<>();
            
            for (Map<String, Object> paymentData : ongoingPayments) {
                // Map에서 데이터 추출 (안전한 타입 변환)
                Object paymentIdObj = paymentData.get("payment_id");
                Integer paymentId;
                if (paymentIdObj instanceof Integer) {
                    paymentId = (Integer) paymentIdObj;
                } else if (paymentIdObj instanceof Long) {
                    paymentId = ((Long) paymentIdObj).intValue();
                } else {
                    paymentId = null;
                }
                
                Object integratedPaymentIdObj = paymentData.get("integratedpayment_id");
                Integer integratedPaymentId;
                if (integratedPaymentIdObj instanceof Integer) {
                    integratedPaymentId = (Integer) integratedPaymentIdObj;
                } else if (integratedPaymentIdObj instanceof Long) {
                    integratedPaymentId = ((Long) integratedPaymentIdObj).intValue();
                } else {
                    integratedPaymentId = null;
                }
                Integer amount = (Integer) paymentData.get("payment_amount");
                String status = (String) paymentData.get("payment_status");
                Integer totalAmount = (Integer) paymentData.get("total_amount");
                Integer participantCount = (Integer) paymentData.get("participant_count");
                // leader_id를 안전하게 Long으로 변환
                Object leaderIdObj = paymentData.get("leader_id");
                Long leaderId;
                if (leaderIdObj instanceof Integer) {
                    leaderId = ((Integer) leaderIdObj).longValue();
                } else if (leaderIdObj instanceof Long) {
                    leaderId = (Long) leaderIdObj;
                } else if (leaderIdObj instanceof String) {
                    leaderId = Long.parseLong((String) leaderIdObj);
                } else {
                    log.error("Invalid leader_id type: {}", leaderIdObj != null ? leaderIdObj.getClass().getName() : "null");
                    leaderId = null;
                }
                java.sql.Timestamp integratedCreatedAt = (java.sql.Timestamp) paymentData.get("integrated_created_at");
                Boolean isExpired = ((Integer) paymentData.get("is_expired")) == 1;
                
                // 발의자 정보 조회
                UserVO leader = loginService.getUserById(leaderId);
                
                // 매장 정보 조회 (store_id가 있다면)
                IntegratedPaymentVO integratedPayment = integratedPaymentService.getIntegratedPaymentById(integratedPaymentId);
                StoreVO storeVO = storeService.getStoreById(integratedPayment.getStoreId());
                String storeName = storeVO.getStoreName();
                String storeAddress = storeVO.getStoreAddress();

                // 참여자 목록 조회
                List<PaymentVO> allPayments = paymentService.getPaymentsByIntegratedPaymentId(integratedPaymentId);
                List<Map<String, Object>> participants = new ArrayList<>();
                
                for (PaymentVO participantPayment : allPayments) {
                    UserVO participant = loginService.getUserById(participantPayment.getUsersId());
                    if (participant != null) {
                        Map<String, Object> participantInfo = new HashMap<>();
                        participantInfo.put("name", participant.getUsersName());
                        participantInfo.put("userId", participant.getUsersId());
                        participants.add(participantInfo);
                    }
                }
                
                // 초대 정보 구성
                Map<String, Object> invitation = new HashMap<>();
                invitation.put("paymentId", paymentId);
                invitation.put("integratedPaymentId", integratedPaymentId);
                invitation.put("amount", amount);
                invitation.put("totalAmount", totalAmount);
                invitation.put("participantCount", participantCount);
                invitation.put("status", status);
                invitation.put("isExpired", isExpired);
                
                // 날짜를 ISO 문자열로 변환
                if (integratedCreatedAt != null) {
                    String createdAt = integratedCreatedAt.toInstant().toString();
                    log.info("Payment {} created at: {}", paymentId, createdAt);
                    invitation.put("createdAt", createdAt);
                } else {
                    log.warn("Payment {} has null createdAt", paymentId);
                    invitation.put("createdAt", null);
                }
                invitation.put("storeName", storeName);
                invitation.put("storeAddress", storeAddress);
                invitation.put("leaderName", leader != null ? leader.getUsersName() : "알 수 없음");
                invitation.put("participants", participants);
                
                invitations.add(invitation);
            }
            
            response.put("success", true);
            response.put("invitations", invitations);
            
        } catch (Exception e) {
            log.error("Error getting invitations: ", e);
            response.put("success", false);
            response.put("message", "초대 목록을 불러오는데 실패했습니다: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
} 