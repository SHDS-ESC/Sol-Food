package kr.co.solfood.user.store;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface StoreMapper {
    //전체 가게 목록 조회
    List<StoreVO> selectAllStore();

    //카테고리별 가게 목록 조회
    List<StoreVO> selectCategoryStore(String category);

    // 가게 ID로 가게 정보 조회
    StoreVO getStoreById(int storeId);
    
    // 검색어로 가게 검색 (가게명, 주소, 카테고리 통합 검색)
    List<StoreVO> searchStores(String keyword);
    
    // 가게명으로 검색
    List<StoreVO> searchStoresByName(String storeName);
    
    // 주소로 검색
    List<StoreVO> searchStoresByAddress(String address);
    
    // 크롤링 전용 메서드들
    // 새 가게 정보 추가
    int insertStore(StoreVO store);
    
    // 중복 체크 (같은 이름과 주소의 가게 개수)
    int countByNameAndAddress(StoreVO store);

    //페이징 처리
    List<StoreVO> selectPagedStores(@Param("offset") int offset,
                                    @Param("pageSize") int pageSize);

    List<StoreVO> selectPagedCategoryStores(@Param("category") String category,
                                            @Param("offset") int offset,
                                            @Param("pageSize") int pageSize);

    long countAllStores();
    long countStoresByCategory(String category);

}