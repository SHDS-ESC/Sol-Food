package kr.co.solfood.user.store;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class StoreServiceImpl implements StoreService {

    @Autowired
    private StoreMapper mapper;

    @Override
    public List<StoreVO> getAllStore() {
        return mapper.selectAllStore();
    }

    @Override
    public List<StoreVO> getCategoryStore(String category) {
        return mapper.selectCategoryStore(category);
    }
    
    @Override
    public StoreVO getStoreById(int storeId) {
        return mapper.getStoreById(storeId);
    }
    
    // 가게 등록 (관리자/크롤링용)
    @Override
    public boolean insertStore(StoreVO store) {
        try {
            int result = mapper.insertStore(store);
            return result > 0;
        } catch (Exception e) {
            System.err.println("가게 정보 저장 실패: " + e.getMessage());
            return false;
        }
    }
    
    @Override
    public boolean isDuplicateStore(StoreVO store) {
        try {
            int count = mapper.countByNameAndAddress(store);
            return count > 0;
        } catch (Exception e) {
            System.err.println("중복 체크 실패: " + e.getMessage());
            return false;
        }
    }

}
