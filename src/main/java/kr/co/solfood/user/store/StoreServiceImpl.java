package kr.co.solfood.user.store;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j  // error 로깅을 위해 유지
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
    @Transactional
    public boolean insertStore(StoreVO store) {
        // 중복 체크
        if (isDuplicateStore(store)) {
            return false;
        }
        
        try {
            int result = mapper.insertStore(store);
            return result > 0;
        } catch (DataAccessException e) {
            log.error("가게 정보 저장 실패: {}", store.getStoreName(), e);
            throw new StoreException(StoreConstants.ERROR_STORE_SAVE_FAILED, e);
        }
    }
    
    @Override
    public boolean isDuplicateStore(StoreVO store) {
        int count = mapper.countByNameAndAddress(store);
        return count > 0;
    }

}
