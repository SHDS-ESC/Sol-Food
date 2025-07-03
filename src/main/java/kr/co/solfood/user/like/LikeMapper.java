package kr.co.solfood.user.like;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface LikeMapper {

    // 찜 등록
    int addLike(@Param("usersId") int usersId, @Param("storeId") int storeId);

    //찜 취소
    int cancelLike(@Param("usersId") int usersId, @Param("storeId") int storeId);

    //찜 존재 확인
    int existLike(@Param("usersId") int usersId, @Param("storeId") int storeId);
}
