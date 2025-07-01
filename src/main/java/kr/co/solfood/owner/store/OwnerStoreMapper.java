package kr.co.solfood.owner.store;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface OwnerStoreMapper {
    // 카테고리 목록 조회
    List<OwnerCategoryVO> selectAllCategory();

    // 상점 등록
    int insertStore(OwnerStoreVO vo);

    // 점주 <-> 상점 조회
    OwnerStoreVO selectStoreById(int id);

    // 상점 수정
    int updateStore(OwnerStoreVO vo);

    // 상점 삭제
    void deleteSotre(@Param("storeId") int storeId);
}
