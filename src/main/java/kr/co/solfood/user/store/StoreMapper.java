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
    
    // 크롤링 전용 메서드들
    // 새 가게 정보 추가
    int insertStore(StoreVO store);
    
    // 중복 체크 (같은 이름과 주소의 가게 개수)
    int countByNameAndAddress(StoreVO store);

    //페이징 처리
    List<StoreVO> selectPagedStores(@Param("offset") int offset,
                                    @Param("pageSize") int pageSize,
                                    @Param("usersId") Long usersId);

    List<StoreVO> selectPagedCategoryStores(@Param("category") String category,
                                            @Param("offset") int offset,
                                            @Param("pageSize") int pageSize,
                                            @Param("usersId") Long usersId);

    long countAllStores();
    long countStoresByCategory(String category);


}