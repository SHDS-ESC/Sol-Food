package kr.co.solfood.user.login;

import org.apache.ibatis.annotations.Mapper;

import java.time.LocalDateTime;

@Mapper
public interface LoginMapper {
    // 회원 가입
    int register(LoginVO vo);

    // DB 내의 카카오 유저 중복 여부 확인
    LoginVO kakaoLogin(long id);
}
