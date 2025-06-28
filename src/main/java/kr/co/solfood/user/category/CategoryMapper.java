package kr.co.solfood.user.category;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;

@Mapper
public interface CategoryMapper {
    
    /**
     * 모든 카테고리 조회
     */
    List<CategoryVO> selectAllCategories();
    
    /**
     * 카테고리 ID로 조회
     */
    CategoryVO selectCategoryById(int categoryId);
    
    /**
     * 카테고리명으로 조회
     */
    CategoryVO selectCategoryByName(String categoryName);
} 