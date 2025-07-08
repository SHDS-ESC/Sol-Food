package kr.co.solfood.payments.payment;

import java.util.List;

import kr.co.solfood.payments.common.CommonPaymentService;
import kr.co.solfood.user.cart.BillDTO;
import kr.co.solfood.user.login.UserVO;

public interface PaymentService extends CommonPaymentService {
    // 포인트 적립 (트랜잭션 처리)
    void updateUserPoint(UserVO user);
    // Payment 정보 삽입
    void insertPayment(PaymentVO paymentVO);
    // 사용자별 결제 내역 조회
    List<PaymentVO> getPaymentHistory(long usersId, int page, int size);
    // Payment 정보 수정
    void updatePayment(PaymentVO paymentVO);
    // 통합결제ID별 결제 내역 조회
    List<PaymentVO> getPaymentHistoryByIntergratedpaymentId(int intergratedpaymentId, int page, int size);
    // BillDTO를 기반으로 각 사용자별 결제 데이터 생성
    void createPayment(BillDTO billDTO, int integratedPaymentId);
    // 통합결제ID로 모든 결제 상태 업데이트
    void updatePaymentStatusByIntegratedPaymentId(int integratedPaymentId, String status);
}
