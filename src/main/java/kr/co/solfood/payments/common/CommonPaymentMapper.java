package kr.co.solfood.payments.common;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface CommonPaymentMapper {
    // 중복 결제 방지 (imp_uid 중복 체크)
    boolean isAlreadyProcessed(String imp_uid);
}
