package kr.co.solfood.user.mypage;

import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.user.store.StoreVO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MypageMapper {
    // 마이페이지 > 내정보 업데이트
    void update(UserVO userVO);

    // 마이페이지 > 찜한 가게 목록 조회
    List<StoreVO> getLikedStores(
            @Param("usersId") Long usersId,
            @Param("offset") int offset,
            @Param("pageSize") int pageSize
    );
}
