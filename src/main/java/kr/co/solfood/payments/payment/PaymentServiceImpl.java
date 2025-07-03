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
    public List<PaymentVO> getPaymentHistory(int usersId, int page, int size) {
        int offset = (page - 1) * size;
        return paymentMapper.getPaymentHistory(usersId, offset, size);
    }

    // 통합결제ID별 결제 내역 조회
    @Override
    public List<PaymentVO> getPaymentHistoryByIntergratedpaymentId(int intergratedpaymentId, int page, int size) {
        int offset = (page - 1) * size;
        return paymentMapper.selectPaymentsByIntergratedpaymentId(intergratedpaymentId, size, offset);
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
    
}
