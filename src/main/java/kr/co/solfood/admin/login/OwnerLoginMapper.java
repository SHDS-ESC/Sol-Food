package kr.co.solfood.owner.login;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OwnerLoginMapper {
    // 회원가입
    int register(OwnerVO vo);

    // 로그인
    OwnerVO login(OwnerVO vo);

}
