package kr.co.solfood.user.category;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class CategoryServiceImpl implements CategoryService {
    
    @Autowired
    private CategoryMapper categoryMapper;
    
    @Override
    public List<CategoryVO> getAllCategories() {
        try {
            List<CategoryVO> categories = categoryMapper.selectAllCategories();
            log.info("모든 카테고리 조회 완료 - 총 {}개", categories.size());
            return categories;
        } catch (Exception e) {
            log.error("모든 카테고리 조회 실패", e);
            throw new RuntimeException("카테고리 목록을 불러오는데 실패했습니다.", e);
        }
    }
    
    @Override
    public CategoryVO getCategoryById(int categoryId) {
        try {
            CategoryVO category = categoryMapper.selectCategoryById(categoryId);
            if (category == null) {
                log.warn("카테고리 ID {}에 해당하는 카테고리가 존재하지 않습니다.", categoryId);
            }
            return category;
        } catch (Exception e) {
            log.error("카테고리 ID {} 조회 실패", categoryId, e);
            throw new RuntimeException("카테고리 조회에 실패했습니다.", e);
        }
    }
    
    @Override
    public CategoryVO getCategoryByName(String categoryName) {
        try {
            CategoryVO category = categoryMapper.selectCategoryByName(categoryName);
            if (category == null) {
                log.warn("카테고리명 '{}'에 해당하는 카테고리가 존재하지 않습니다.", categoryName);
            }
            return category;
        } catch (Exception e) {
            log.error("카테고리명 '{}' 조회 실패", categoryName, e);
            throw new RuntimeException("카테고리 조회에 실패했습니다.", e);
        }
    }
    
    @Override
    public Integer getCategoryIdByName(String categoryName) {
        try {
            if (categoryName == null || categoryName.trim().isEmpty()) {
                log.warn("카테고리명이 비어있습니다. 기본 카테고리 ID(1) 반환");
                return 1; // 기본값: 전체 카테고리
            }
            
            CategoryVO category = categoryMapper.selectCategoryByName(categoryName.trim());
            if (category == null) {
                log.warn("카테고리명 '{}'에 해당하는 카테고리가 존재하지 않습니다. 기본 카테고리 ID(1) 반환", categoryName);
                return 1; // 기본값: 전체 카테고리
            }
            
            return category.getCategoryId();
        } catch (Exception e) {
            log.error("카테고리명 '{}' ID 조회 실패", categoryName, e);
            return 1; // 예외 발생 시 기본값 반환
        }
    }
} 