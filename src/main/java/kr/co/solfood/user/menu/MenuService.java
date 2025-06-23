package kr.co.solfood.user.menu;

import java.util.List;

public interface MenuService {
    
    /**
     * 특정 가게의 메뉴 목록 조회
     */
    List<MenuVO> getMenusByStoreId(Integer storeId);
    
    /**
     * 메뉴 상세 조회
     */
    MenuVO getMenuById(Integer menuId);
} 