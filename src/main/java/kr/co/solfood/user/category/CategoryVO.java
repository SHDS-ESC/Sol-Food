package kr.co.solfood.user.category;

import lombok.Data;

@Data
public class CategoryVO {
    private int categoryId;        // category_id (PK)
    private String categoryName;   // category_name
    private String categoryImage;  // category_image
} 