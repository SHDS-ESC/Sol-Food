package kr.co.solfood.login;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LoginMapper {
    int regist(LoginVO vo);
    LoginVO kakaoLogin(LoginVO vo);
    void insertStudent(LoginVO vo);
    LoginVO login(LoginVO vo);
    LoginVO view(String id);
}
