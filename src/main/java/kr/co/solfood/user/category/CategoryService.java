package kr.co.solfood.user.category;

import java.util.List;
import java.util.Map;

public interface CategoryService {
    
    /**
     * 모든 카테고리 조회
     */
    List<CategoryVO> getAllCategories();
    
    /**
     * 카테고리 ID로 조회
     */
    CategoryVO getCategoryById(int categoryId);
    
    /**
     * 카테고리명으로 조회
     */
    CategoryVO getCategoryByName(String categoryName);
    
    /**
     * 카테고리명으로 ID 조회 (StoreVO에서 categoryId 설정용)
     */
    Integer getCategoryIdByName(String categoryName);
    
    /**
     * 카테고리 정보를 JSON 형태로 반환 (프론트엔드용)
     */
    Map<String, Object> getCategoryConfig();
} 