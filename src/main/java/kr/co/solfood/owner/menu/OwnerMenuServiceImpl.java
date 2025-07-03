package kr.co.solfood.owner.menu;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OwnerMenuServiceImpl implements OwnerMenuService {

    @Autowired
    private OwnerMenuMapper ownerMenuMapper;

    // 메뉴 등록
    @Override
    public int insertMenu(OwnerMenuVO vo) {
        return ownerMenuMapper.insertMenu(vo);
    }

    // 메뉴 리스트 조회
    @Override
    public List<OwnerMenuVO> selectMenu(int id) {
        return ownerMenuMapper.selectMenu(id);
    }

    // 메뉴 단건 조회
    @Override
    public OwnerMenuVO getMenuById(int menuId) {
        return ownerMenuMapper.getMenuById(menuId);
    }

    // 메뉴 수정
    @Override
    public int updateMenu(OwnerMenuVO vo) {
        return ownerMenuMapper.updateMenu(vo);
    }

    // 메뉴 삭제
    @Override
    public void deleteMenu(int menuId) {
        ownerMenuMapper.deleteMenu(menuId);
    }


}
