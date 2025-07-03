package kr.co.solfood.owner.menu;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface OwnerMenuMapper {

    // 메뉴 등록
    int insertMenu(OwnerMenuVO vo);

    // 메뉴 조회
    List<OwnerMenuVO> selectMenu(int id);

    // 메뉴 단건 조회
    OwnerMenuVO getMenuById(int menuId);

    // 메뉴 수정
    int updateMenu(OwnerMenuVO vo);

    // 메뉴 삭제
    void deleteMenu(int menuId);
}

