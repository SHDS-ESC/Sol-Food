package kr.co.solfood.user.mypage;

import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.user.store.StoreVO;
import kr.co.solfood.util.PageMaker;

public interface MypageService {
    // 마이페이지 > 내정보 업데이트
    void updateUserInfo(UserVO userVO);

    // 마이페이지 > 내 찜 목록
    PageMaker<StoreVO> getLikedStores(Long usersId, StoreVO storeVO);

    // API용 찜한 가게 목록 조회
    PageMaker<StoreVO> getLikedStoresApi(Long usersId, StoreVO storeVO);
}
