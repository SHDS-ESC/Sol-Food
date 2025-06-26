package kr.co.solfood.user.mypage;


import kr.co.solfood.user.like.LikeMapper;
import kr.co.solfood.user.like.LikeService;
import kr.co.solfood.user.login.UserVO;
import kr.co.solfood.user.store.StoreVO;
import kr.co.solfood.util.PageMaker;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Service
public class MypageServiceImpl implements MypageService {

    @Autowired
    private MypageMapper mypageMapper;

    @Autowired
    private LikeMapper likeMapper;

    @Autowired
    private LikeService likeService;

    // 마이페이지 > 내정보 업데이트
    @Override
    public void updateUserInfo(UserVO userVO) {
        mypageMapper.update(userVO);
    }



    // 페이징 처리를 위한 PageMaker 생성
    public PageMaker<StoreVO> getLikedStores(Long usersId, StoreVO storeVO) {
        // 전체 찜한 가게 수 조회
        int totalCount = mypageMapper.countLikedStores(usersId);

        //페이징된 찜 목록 조회
        List<StoreVO> likedStores = mypageMapper.getLikedStores(usersId, storeVO);

        //PageMaker 생성 및 반환
        return new PageMaker<>(likedStores, totalCount, storeVO.getPageSize(),storeVO.getCurrentPage());
    }

    public PageMaker<StoreVO> getLikedStoresApi(Long usersId, StoreVO storeVO) {
        int totalCount = mypageMapper.countLikedStores(usersId);
        List<StoreVO> likedStores = mypageMapper.getLikedStores(usersId, storeVO);
        // PageMaker에 페이지 계산을 맞춰서 리턴
        return new PageMaker<>(likedStores, totalCount, storeVO.getPageSize(), storeVO.getCurrentPage());
    }

    public boolean addLike(int usersId, int storeId){
        //이미 찜한 내역이 있는지 확인
        if(likeMapper.existLike(usersId, storeId) > 0){
            return false;
        }
        //insert 실행
        int result = likeMapper.addLike(usersId, storeId);

        //1건 이상 삽입되면 true 반환
        return result > 0;
    }

    public boolean cancelLike(int usersId, int storeId){
        return likeMapper.cancelLike(usersId, storeId) > 0;
    }
}
