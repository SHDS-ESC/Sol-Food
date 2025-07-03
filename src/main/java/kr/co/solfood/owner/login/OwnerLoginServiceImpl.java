package kr.co.solfood.owner.login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class OwnerLoginServiceImpl implements OwnerLoginService {

    @Autowired
    private OwnerLoginMapper mapper;


    // 회원가입
    @Override
    public OwnerVO register(OwnerVO vo) {
        int result = mapper.register(vo);
        if(result > 0){
            return vo;
        }
        return null;
    }

    // 로그인
    @Override
    public OwnerVO login(OwnerVO vo) {
        return mapper.login(vo);
    }
}
