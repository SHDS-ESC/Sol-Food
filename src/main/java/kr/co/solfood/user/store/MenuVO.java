package kr.co.solfood.user.store;

import lombok.Data;

@Data
public class MenuVO {
    private int menuId;           // menu_id
    private int storeId;          // store_id
    private String menuName;      // menu_name
    private int menuPrice;        // menu_price
    private String menuMainimage; // menu_mainimage
    private String menuIntro;     // menu_intro
    
    // 메뉴명을 기반으로 카테고리를 결정하는 메서드
    public String getCategory() {
        if (menuName == null) return "기타";
        
        if (menuName.contains("프리미엄")) {
            return "프리미엄";
        } else if (menuName.contains("정식")) {
            return "정식시리즈";
        } else if (menuName.contains("마요")) {
            return "마요시리즈";
        } else if (menuName.contains("카레")) {
            return "카레";
        } else if (menuName.contains("볶음밥")) {
            return "볶음밥";
        } else if (menuName.contains("덮밥")) {
            return "덮밥";
        } else if (menuName.contains("비빔밥")) {
            return "비빔밥";
        } else if (menuName.contains("도시락")) {
            return "도시락";
        } else if (menuPrice <= 2000) {
            return "실속반찬/단품";
        } else if (menuPrice <= 4000) {
            return "스낵/디저트";
        } else {
            return "신메뉴";
        }
    }
} 