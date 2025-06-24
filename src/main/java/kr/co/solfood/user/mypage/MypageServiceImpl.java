package kr.co.solfood.user.mypage;


import kr.co.solfood.user.login.LoginMapper;
import kr.co.solfood.user.login.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class MypageServiceImpl implements MypageService {

    @Autowired
    private MypageMapper mypageMapper;

    // 마이페이지 > 내정보 업데이트
    @Override
    public void updateUserInfo(UserVO userVO) {
        mypageMapper.update(userVO);
    }
}
