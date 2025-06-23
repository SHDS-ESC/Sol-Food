package kr.co.solfood.user.menu;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MenuServiceImpl implements MenuService {
    
    @Autowired
    private MenuMapper menuMapper;
    
    @Override
    public List<MenuVO> getMenusByStoreId(Integer storeId) {
        return menuMapper.getMenusByStoreId(storeId);
    }
    
    @Override
    public MenuVO getMenuById(Integer menuId) {
        return menuMapper.getMenuById(menuId);
    }
} 