package kr.co.solfood.user.like;


public interface LikeService {
    // 찜 추가
    boolean addLike(int usersId, int storeId);

    // 찜 삭제
    boolean cancelLike(int usersId, int storeId);

    // 찜 존재 여부 확인
    boolean existLike(int usersId, int storeId);

}
