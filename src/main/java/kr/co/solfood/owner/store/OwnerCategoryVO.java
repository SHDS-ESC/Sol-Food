package kr.co.solfood.owner.store;

import lombok.Data;

@Data
public class OwnerCategoryVO {
    private int categoryId; // 카테고리 아이디
    private String categoryName; // 카테고리 명
    private String categoryImage; // 카테고리 이미지
}
