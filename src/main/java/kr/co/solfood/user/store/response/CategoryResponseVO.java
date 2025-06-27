package kr.co.solfood.user.store.response;

import kr.co.solfood.user.category.CategoryVO;
import kr.co.solfood.user.store.StoreVO;
import java.util.List;

/**
 * 카테고리 API 응답 VO
 */
public class CategoryResponseVO {
    private boolean success;
    private List<CategoryVO> categories;
    private String category;
    private List<StoreVO> stores;
    private int count;
    private String message;
    
    private CategoryResponseVO(boolean success, List<CategoryVO> categories, String category, 
                             List<StoreVO> stores, String message) {
        this.success = success;
        this.categories = categories;
        this.category = category;
        this.stores = stores != null ? stores : List.of();
        this.count = this.stores.size();
        this.message = message;
    }
    
    // 카테고리 목록 응답
    public static CategoryResponseVO categoryList(List<CategoryVO> categories) {
        return new CategoryResponseVO(true, categories, null, null, null);
    }
    
    // 카테고리별 가게 목록 응답
    public static CategoryResponseVO storesByCategory(String category, List<StoreVO> stores) {
        return new CategoryResponseVO(true, null, category, stores, null);
    }
    
    public static CategoryResponseVO error(String message) {
        return new CategoryResponseVO(false, null, null, null, message);
    }
    
    // Getter 메서드들
    public boolean isSuccess() { return success; }
    public List<CategoryVO> getCategories() { return categories; }
    public String getCategory() { return category; }
    public List<StoreVO> getStores() { return stores; }
    public int getCount() { return count; }
    public String getMessage() { return message; }
} 