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

}
