package kr.co.solfood.payments.payment;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.solfood.payments.common.CommonPaymentMapper;
import kr.co.solfood.user.cart.BillDTO;
import kr.co.solfood.user.login.UserVO;

@Service
@Transactional(rollbackFor = Exception.class)
public class PaymentServiceImpl implements PaymentService {

    private final PaymentMapper paymentMapper;

    public PaymentServiceImpl(PaymentMapper paymentMapper) {
        this.paymentMapper = paymentMapper;
    }

    @Override
    public CommonPaymentMapper getMapper() {
        return paymentMapper;
    }

    // 포인트 적립 (트랜잭션 처리)
    @Override
    public void updateUserPoint(UserVO user) {
        paymentMapper.updateUserPoint(user);
    }

    // 사용자별 결제 내역 조회
    @Override
    public List<PaymentVO> getPaymentHistory(long usersId, int page, int size) {
        int offset = (page - 1) * size;
        return paymentMapper.getPaymentHistory(usersId, offset, size);
    }

    // 통합결제ID별 결제 내역 조회
    @Override
    public List<PaymentVO> getPaymentsByIntegratedPaymentId(int integratedPaymentId) {
        return paymentMapper.selectPaymentsByIntegratedPaymentId(integratedPaymentId);
    }

    // Payment 정보 삽입
    @Override
    public void insertPayment(PaymentVO paymentVO) {
        paymentMapper.insertPayment(paymentVO);
    }

    // Payment 정보 수정
    @Override
    public void updatePayment(PaymentVO paymentVO) {
        paymentMapper.updatePayment(paymentVO);
    }

    @Override
    public List<PaymentVO> getOngoingPaymentByUserId(long userId) {
        return paymentMapper.selectOngoingPaymentByUserId(userId);
    }

    // BillDTO를 기반으로 각 사용자별 결제 데이터 생성
    @Override
    public void createPayment(BillDTO billDTO, int integratedPaymentId) {
        Map<Long, Integer> userBill = billDTO.getUserBill();
        
        for (Map.Entry<Long, Integer> entry : userBill.entrySet()) {
            Long userId = entry.getKey();
            Integer paymentAmount = entry.getValue();
            
            PaymentVO payment = new PaymentVO();
            payment.setUsersId(userId.intValue());
            payment.setIntegratedpaymentId(integratedPaymentId);
            payment.setAmount(paymentAmount);
            payment.setStatus("pending");
            
            paymentMapper.insertPayment(payment);
        }
    }
    
    // 통합결제ID로 모든 결제 상태 업데이트
    @Override
    public void updatePaymentStatusByIntegratedPaymentId(int integratedPaymentId, String status) {
        paymentMapper.updatePaymentStatusByIntegratedPaymentId(integratedPaymentId, status);
    }
    
    // 개별 결제 상태 업데이트 (응답용)
    @Override
    public void updatePaymentStatusSimple(int paymentId, String status) {
        paymentMapper.updatePaymentStatusSimple(paymentId, status);
    }
    
    // ID로 결제 정보 조회
    @Override
    public PaymentVO getPaymentById(int paymentId) {
        return paymentMapper.selectPaymentById(paymentId);
    }
    
         // 사용자ID로 발의자 결제 조회 (진행중인 것만)
     @Override
     public PaymentVO getLeaderPaymentByUserId(long userId) {
         return paymentMapper.selectLeaderPaymentByUserId(userId);
     }
     
     // 통합결제ID로 가게ID 조회
     @Override
     public Integer getStoreIdByIntegratedPaymentId(int integratedPaymentId) {
         return paymentMapper.selectStoreIdByIntegratedPaymentId(integratedPaymentId);
     }
     
     // 결제별 리뷰 작성 여부 확인
     @Override
     public boolean hasReviewForPayment(int paymentId, long userId) {
         return paymentMapper.hasReviewForPayment(paymentId, userId);
     }
     
 }
