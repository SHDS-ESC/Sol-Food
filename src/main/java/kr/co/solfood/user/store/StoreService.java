package kr.co.solfood.user.store;

import kr.co.solfood.util.PageDTO;
import kr.co.solfood.util.PageMaker;

import java.util.List;

public interface StoreService {
    // 전체 가게 목록 조회
    List<StoreVO> getAllStore();

    // 카테고리별 가게 목록 조회
    List<StoreVO> getCategoryStore(String category);
    
    // 가게 상세 조회
    StoreVO getStoreById(int storeId);
    
    // 검색어로 가게 검색 (통합 검색)
    List<StoreVO> searchStores(String keyword);
    
    // 가게명으로 검색
    List<StoreVO> searchStoresByName(String storeName);
    
    // 주소로 검색
    List<StoreVO> searchStoresByAddress(String address);
    
    // 가게 등록 (관리자/크롤링용)
    boolean insertStore(StoreVO store);
    
    // 중복 가게 체크
    boolean isDuplicateStore(StoreVO store);

    //페이징 처리 - 전체('전체') 및 카테고리별 통합
    PageMaker<StoreVO> getPagedCategoryStoreList(String category, PageDTO pageDTO);

    //검색 결과 페이징 처리
    PageMaker<StoreVO> getPagedSearchResults(String keyword, PageDTO pageDTO);
}
