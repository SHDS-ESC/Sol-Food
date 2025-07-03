package kr.co.solfood.user.like;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LikeServiceImpl implements LikeService {

    @Autowired
    private LikeMapper mapper;

    @Override
    public boolean addLike(int usersId, int storeId){
        // 이미 찜한 내역이 있는지 확인
        if(mapper.existLike(usersId, storeId) > 0) {
            return false;
        }
        // insert 실행
        int result = mapper.addLike(usersId, storeId);
        // 1건 이상 삽입되면 true 반환
        return result > 0;
    }

    @Override
    public boolean cancelLike(int usersId, int storeId){
        int result = mapper.cancelLike(usersId, storeId);
        return result > 0;
    }

    @Override
    public boolean existLike(int usersId, int storeId) {
        return mapper.existLike(usersId, storeId) > 0;
    }

}
