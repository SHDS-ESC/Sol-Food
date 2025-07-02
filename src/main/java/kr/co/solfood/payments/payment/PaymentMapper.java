package kr.co.solfood.payments.payment;

import java.util.List;
import java.util.Map;

import kr.co.solfood.payments.common.CommonPaymentMapper;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import kr.co.solfood.user.login.UserVO;

@Mapper
public interface PaymentMapper extends CommonPaymentMapper {
    
    // === 기본 CRUD 작업 ===
    
    /**
     * 결제 정보 삽입
     */
    int insertPayment(PaymentVO payment);
    
    /**
     * 결제 정보 수정
     */
    int updatePayment(PaymentVO payment);
    
    /**
     * 결제 상태 업데이트
     */
    int updatePaymentStatus(@Param("paymentId") int paymentId, 
                           @Param("status") String status, 
                           @Param("statusDetail") String statusDetail,
                           @Param("paidAt") java.sql.Timestamp paidAt);
    
    /**
     * 결제 취소/환불 처리
     */
    int cancelPayment(@Param("paymentId") int paymentId, 
                     @Param("cancelReason") String cancelReason, 
                     @Param("cancelAmount") int cancelAmount);
    
    /**
     * 결제 정보 삭제 (관리자용)
     */
    int deletePayment(int paymentId);
    
    // === 조회 작업 ===
    
    /**
     * ID로 결제 정보 조회
     */
    PaymentVO selectPaymentById(int paymentId);
    
    /**
     * merchant_uid로 결제 정보 조회
     */
    PaymentVO selectPaymentByMerchantUid(String merchantUid);
    
    /**
     * imp_uid로 결제 정보 조회
     */
    PaymentVO selectPaymentByImpUid(String impUid);
    
    /**
     * 사용자별 결제 내역 조회
     */
    List<PaymentVO> selectPaymentsByUserId(@Param("usersId") int usersId, 
                                          @Param("limit") int limit, 
                                          @Param("offset") int offset);
    
    /**
     * 통합결제ID로 결제 내역 조회
     */
    List<PaymentVO> selectPaymentsByIntergratedpaymentId(@Param("intergratedpaymentId") int intergratedpaymentId, 
                                                        @Param("limit") int limit, 
                                                        @Param("offset") int offset);
    
    /**
     * 매장별 결제 내역 조회
     */
    List<PaymentVO> selectPaymentsByStoreId(@Param("storeId") int storeId, 
                                           @Param("limit") int limit, 
                                           @Param("offset") int offset);
    
    /**
     * 결제 상태별 조회
     */
    List<PaymentVO> selectPaymentsByStatus(@Param("status") String status, 
                                          @Param("limit") int limit, 
                                          @Param("offset") int offset);
    
    /**
     * 결제 타입별 조회
     */
    List<PaymentVO> selectPaymentsByType(@Param("paymentType") String paymentType, 
                                        @Param("limit") int limit, 
                                        @Param("offset") int offset);
    
    /**
     * 최근 결제 내역 조회
     */
    List<PaymentVO> selectRecentPayments(int limit);
    
    /**
     * 결제 통계 조회
     */
    Map<String, Object> selectPaymentStatistics(@Param("startDate") String startDate, 
                                               @Param("endDate") String endDate);
    
    /**
     * 결제 검증을 위한 조회
     */
    PaymentVO selectPaymentForVerification(@Param("merchantUid") String merchantUid, 
                                          @Param("impUid") String impUid, 
                                          @Param("amount") int amount);
    
    /**
     * 조건부 검색
     */
    List<PaymentVO> searchPayments(@Param("storeId") Integer storeId,
                                  @Param("paymentLeaderId") Integer paymentLeaderId,
                                  @Param("paymentType") String paymentType,
                                  @Param("status") String status,
                                  @Param("startDate") String startDate,
                                  @Param("endDate") String endDate,
                                  @Param("minAmount") Integer minAmount,
                                  @Param("maxAmount") Integer maxAmount,
                                  @Param("limit") int limit,
                                  @Param("offset") int offset);
    
    /**
     * 포인트 적립 (트랜잭션 처리)
     */
    void updateUserPoint(UserVO user);
    
    /**
     * Payment 내역 조회 (기존 메서드)
     */
    List<PaymentVO> getPaymentHistory(@Param("paymentLeaderId") long paymentLeaderId,
                                     @Param("offset") int offset,
                                     @Param("size") int size);
}
