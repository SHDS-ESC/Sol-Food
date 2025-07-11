package kr.co.solfood.payments.integrated;

import kr.co.solfood.payments.payment.PaymentService;
import kr.co.solfood.user.cart.BillDTO;
import kr.co.solfood.user.cart.CartConstants;
import kr.co.solfood.user.cart.CartItemVO;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@Transactional(rollbackFor = Exception.class)
public class IntegratedPaymentServiceImpl implements IntegratedPaymentService {
    
    @Autowired
    private IntegratedPaymentMapper integratedPaymentMapper;
    
    @Autowired
    private PaymentService paymentService;

    // PK 반환
    @Override
    public int createIntegratedPayment(BillDTO billDTO) {
        IntegratedPaymentVO integratedPayment = new IntegratedPaymentVO();
        integratedPayment.setStoreId(billDTO.getStoreId());
        integratedPayment.setIntegratedpaymentLeaderId((int) billDTO.getLeaderId());
        integratedPayment.setIntegratedpaymentAmount(billDTO.getTotalAmount());
        integratedPayment.setIntegratedpaymentPeople(billDTO.getUserBill().size());
        integratedPayment.setIntegratedpaymentStatus("pending");
        
        integratedPaymentMapper.insertIntegratedPayment(integratedPayment);

        // 통합 결제 pk를 기준으로 메뉴 만들기
        integratedPayment.getIntegratedpaymentId();

        return integratedPayment.getIntegratedpaymentId();
    }

    // 중복 체크를 포함한 통합 결제 생성 - null 반환 시 중복 존재
    @Override
    public Integer createIntegratedPaymentWithDuplicateCheck(BillDTO billDTO) {
        // synchronized 블록으로 동시 접근 방지
        synchronized (this) {
            try {
                // 1. 먼저 진행 중인 결제가 있는지 확인
                IntegratedPaymentVO existingPayment = integratedPaymentMapper.selectOnGoingIntegratedPaymentByLeaderId(billDTO.getLeaderId());
                if (existingPayment != null) {
                    log.info("중복 결제 시도 감지: 발의자ID {}, 기존 통합결제ID {}", billDTO.getLeaderId(), existingPayment.getIntegratedpaymentId());
                    return null; // 중복 존재
                }

                // 2. 새로운 통합 결제 생성
                IntegratedPaymentVO integratedPayment = new IntegratedPaymentVO();
                integratedPayment.setStoreId(billDTO.getStoreId());
                integratedPayment.setIntegratedpaymentLeaderId((int) billDTO.getLeaderId());
                integratedPayment.setIntegratedpaymentAmount(billDTO.getTotalAmount());
                integratedPayment.setIntegratedpaymentPeople(billDTO.getUserBill().size());
                integratedPayment.setIntegratedpaymentStatus("pending");

                integratedPaymentMapper.insertIntegratedPayment(integratedPayment);

                log.info("새로운 통합 결제 생성 완료: 발의자ID {}, 통합결제ID {}", billDTO.getLeaderId(), integratedPayment.getIntegratedpaymentId());
                return integratedPayment.getIntegratedpaymentId();

            } catch (Exception e) {
                log.error("통합 결제 생성 중 오류 발생: 발의자ID {}, 오류: {}", billDTO.getLeaderId(), e.getMessage());
                throw e; // 트랜잭션 롤백을 위해 예외 재발생
            }
        }
    }

    @Override
    public void createPaymentMenu(List<CartItemVO> cartItems, int integratedPaymentId) {
        for (CartItemVO cartItem : cartItems) {
            try {
                integratedPaymentMapper.insertPaymentMenu(cartItem, integratedPaymentId);
            } catch (Exception e) {
                e.printStackTrace();
                log.error("DB INSERT ERROR: " + e.getMessage(), e);
            }
        }
    }

    @Override
    public IntegratedPaymentVO getIntegratedPaymentById(int integratedPaymentId) {
        return integratedPaymentMapper.selectIntegratedPaymentById(integratedPaymentId);
    }
    
    @Override
    public IntegratedPaymentVO getIntegratedPaymentByLeaderId(long leaderId) {
        return integratedPaymentMapper.selectIntegratedPaymentByLeaderId(leaderId);
    }

    @Override
    public IntegratedPaymentVO getOnGoingIntegratedPaymentByLeaderId(long leaderId) {
        return integratedPaymentMapper.selectOnGoingIntegratedPaymentByLeaderId(leaderId);
    }

    @Override
    public void updatePaymentStatus(int integratedPaymentId, String status) {
        integratedPaymentMapper.updatePaymentStatus(integratedPaymentId, status);
    }
    
    @Override
    public int cleanupExpiredPendingPayments() {
        return integratedPaymentMapper.cleanupExpiredPendingPayments();
    }
    
    // === 더치페이 전체 관리 메서드 구현 ===
    
    @Override
    public void updateDutchPayStatus(int integratedPaymentId, String status) {
        // 1. 통합 결제 상태 업데이트
        integratedPaymentMapper.updatePaymentStatus(integratedPaymentId, status);
        
        // 2. 개별 결제들 상태도 함께 업데이트
        paymentService.updatePaymentStatusByIntegratedPaymentId(integratedPaymentId, status);
        
        log.info("더치페이 전체 상태 업데이트 완료: 통합결제ID {}, 상태 {}", integratedPaymentId, status);
    }
    
    @Override
    public int cleanupExpiredDutchPayments() {
        // 1. 만료된 통합 결제들 찾기
        List<IntegratedPaymentVO> expiredIntegratedPayments = integratedPaymentMapper.selectExpiredPendingPayments();
        
        int totalCleaned = 0;
        
        for (IntegratedPaymentVO expiredPayment : expiredIntegratedPayments) {
            int integratedPaymentId = expiredPayment.getIntegratedpaymentId();
            
            try {
                // 2. 해당 통합결제의 개별결제들도 함께 취소 처리
                processDutchPayCancelled(integratedPaymentId, "만료로 인한 자동 취소");
                totalCleaned++;
                
                log.info("만료된 더치페이 정리 완료: 통합결제ID {}", integratedPaymentId);
            } catch (Exception e) {
                log.error("만료된 더치페이 정리 중 오류: 통합결제ID {}, 오류: {}", integratedPaymentId, e.getMessage());
            }
        }
        
        log.info("만료된 더치페이 정리 완료: 총 {}건", totalCleaned);
        return totalCleaned;
    }
    
    @Override
    public void processDutchPaySuccess(int integratedPaymentId) {
        updateDutchPayStatus(integratedPaymentId, CartConstants.PAYMENT_STATUS_COMPLETED);
        log.info("더치페이 성공 처리 완료: 통합결제ID {}", integratedPaymentId);
    }
    
    @Override
    public void processDutchPayFailed(int integratedPaymentId, String failReason) {
        updateDutchPayStatus(integratedPaymentId, CartConstants.PAYMENT_STATUS_FAILED);
        log.info("더치페이 실패 처리 완료: 통합결제ID {}, 사유: {}", integratedPaymentId, failReason);
    }
    
    @Override
    public void processDutchPayCancelled(int integratedPaymentId, String cancelReason) {
        updateDutchPayStatus(integratedPaymentId, CartConstants.PAYMENT_STATUS_CANCELLED);
        log.info("더치페이 취소 처리 완료: 통합결제ID {}, 사유: {}", integratedPaymentId, cancelReason);
    }
    
    @Override
    public int processTimeoutDutchPayments(int timeoutMinutes) {
        // 1. 타임아웃된 통합 결제들 찾기
        List<IntegratedPaymentVO> timeoutPayments = integratedPaymentMapper.selectTimeoutPayments(timeoutMinutes);
        
        int totalCancelled = 0;
        
        for (IntegratedPaymentVO timeoutPayment : timeoutPayments) {
            int integratedPaymentId = timeoutPayment.getIntegratedpaymentId();
            
            try {
                // 2. 참여자 응답 상태 확인
                if (!checkDutchPayParticipantResponses(integratedPaymentId)) {
                    // 3. 응답하지 않은 참여자가 있으면 자동 취소
                    processDutchPayCancelled(integratedPaymentId, "참여자 응답 타임아웃으로 인한 자동 취소");
                    totalCancelled++;
                    
                    log.info("타임아웃 더치페이 자동 취소 완료: 통합결제ID {}", integratedPaymentId);
                }
            } catch (Exception e) {
                log.error("타임아웃 더치페이 처리 중 오류: 통합결제ID {}, 오류: {}", integratedPaymentId, e.getMessage());
            }
        }
        
        log.info("타임아웃 더치페이 처리 완료: 총 {}건 취소", totalCancelled);
        return totalCancelled;
    }
    
    @Override
    public boolean checkDutchPayParticipantResponses(int integratedPaymentId) {
        // Payment 테이블에서 해당 통합결제의 모든 참여자 응답 상태 확인
        // TODO: PaymentService에 응답 상태 확인 메서드 추가 필요
        // 현재는 간단히 모든 참여자가 응답했다고 가정
        return true;
    }
} 