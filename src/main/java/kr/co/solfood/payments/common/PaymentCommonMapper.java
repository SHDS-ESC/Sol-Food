package kr.co.solfood.payments.common;

public interface PaymentCommonMapper {
    // 중복 결제 방지 (imp_uid 중복 체크)
    boolean isAlreadyProcessed(String imp_uid);

    // imp_uid 기록
    void saveProcessedImpUid(String imp_uid);
}
