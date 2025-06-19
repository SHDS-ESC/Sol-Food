package kr.co.solfood.user.store;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface StoreMapper {
    //전체 가게 목록 조회
    List<StoreVO> selectAllStore();

    //카테고리별 가게 목록 조회
    List<StoreVO> selectCategoryStore(String category);
}
