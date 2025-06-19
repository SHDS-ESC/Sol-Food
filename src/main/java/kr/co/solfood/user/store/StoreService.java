package kr.co.solfood.user.store;

import java.util.List;

public interface StoreService {
    // 전체 가게 목록 조회
    List<StoreVO> getAllStore();

    // 카테고리별 가게 목록 조회
    List<StoreVO> getCategoryStore(String category);

}
