package kr.co.solfood.owner.store;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OwnerStoreServiceImpl implements OwnerStoreService {

    @Autowired
    private OwnerStoreMapper ownerStoreMapper;

    // 카테고리 목록 조회
    @Override
    public List<OwnerCategoryVO> getOwnerCategory() {
        return ownerStoreMapper.selectAllCategory();
    }

    // 상점 등록
    @Override
    public int insertStore(OwnerStoreVO vo) {
        return ownerStoreMapper.insertStore(vo);
    }

    // 점주 <-> 상점 조회
    @Override
    public OwnerStoreVO getOwnerStore(int id) {
        return ownerStoreMapper.selectStoreById(id);
    }




}
