package kr.co.solfood.user.mypage;

import kr.co.solfood.user.login.UserVO;
import org.springframework.web.multipart.MultipartFile;

public interface MypageService {
    // 마이페이지 > 내정보 업데이트
    void updateUserInfo(UserVO userVO);
}
