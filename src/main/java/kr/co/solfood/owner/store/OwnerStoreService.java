package kr.co.solfood.owner.store;

import java.util.List;

public interface OwnerStoreService {
    // 카테고리
    List<OwnerCategoryVO> getOwnerCategory();

    // 상점 등록
    int insertStore(OwnerStoreVO vo);

    // 점주 <-> 상점 조회
    OwnerStoreVO getOwnerStore(long id);

    // 상점 수정
    int updateStore(OwnerStoreVO vo);

    // 상점 삭제
    void deleteStore(int storeId);
}
