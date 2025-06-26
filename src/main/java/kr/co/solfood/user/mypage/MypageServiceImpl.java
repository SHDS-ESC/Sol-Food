package kr.co.solfood.user.mypage;

import kr.co.solfood.user.login.UserVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MypageServiceImpl implements MypageService {

    @Autowired
    private MypageMapper mypageMapper;

    // 마이페이지 > 내정보 업데이트
    @Override
    public void updateUserInfo(UserVO userVO) {
        mypageMapper.update(userVO);
    }

    // 마이페이지 > 탈퇴
    @Override
    public boolean withdrawUser(long usersId) {
       int result = mypageMapper.updateStatusToWithdraw(usersId);
       return result == 1; // 1건 수정되면 성공
    }
}
