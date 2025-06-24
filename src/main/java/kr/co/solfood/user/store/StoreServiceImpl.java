package kr.co.solfood.user.store;

import kr.co.solfood.util.PageDTO;
import kr.co.solfood.util.PageMaker;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j  // error 로깅을 위해 유지
@Service
@Primary
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
    
    @Override
    public List<StoreVO> searchStores(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllStore(); // 검색어가 없으면 전체 목록 반환
        }
        return mapper.searchStores(keyword.trim());
    }
    
    @Override
    public List<StoreVO> searchStoresByName(String storeName) {
        if (storeName == null || storeName.trim().isEmpty()) {
            return getAllStore();
        }
        return mapper.searchStoresByName(storeName.trim());
    }
    
    @Override
    public List<StoreVO> searchStoresByAddress(String address) {
        if (address == null || address.trim().isEmpty()) {
            return getAllStore();
        }
        return mapper.searchStoresByAddress(address.trim());
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

    //카테고리별 (전체 포함)
    @Override
    public PageMaker<StoreVO> getPagedCategoryStoreList(String category,
                                                        PageDTO pageDTO) {
        List<StoreVO> list = mapper.selectPagedCategoryStores(
                category,
                pageDTO.getOffset(),
                pageDTO.getPageSize()
        );
        long total = mapper.countStoresByCategory(category);

        return new PageMaker<>(list, total, pageDTO.getPageSize(),
                pageDTO.getCurrentPage());
    }

    //검색 결과 페이징
    @Override
    public PageMaker<StoreVO> getPagedSearchResults(String keyword, PageDTO pageDTO) {
        List<StoreVO> list = mapper.selectPagedSearchResults(
                keyword,
                pageDTO.getOffset(),
                pageDTO.getPageSize()
        );
        long total = mapper.countSearchResults(keyword);

        return new PageMaker<>(list, total, pageDTO.getPageSize(),
                pageDTO.getCurrentPage());
    }
}
