package kr.co.solfood.user.mypage;

import kr.co.solfood.user.login.UserVO;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface MypageMapper {
    // 마이페이지 > 내정보 업데이트
    void update(UserVO userVO);

    // 마이페이지 > 탈퇴
    int updateStatusToWithdraw(long usersId);
}
