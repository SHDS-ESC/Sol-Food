package kr.co.solfood.user.store;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface MenuMapper {
    // 가게별 메뉴 목록 조회
    List<MenuVO> getMenusByStoreId(int storeId);
    
    // 메뉴 상세 조회
    MenuVO getMenuById(int menuId);
} 