package kr.co.solfood.owner.menu;

import lombok.Data;

@Data
public class OwnerMenuVO {
    private int menuId;
    private int storeId;
    private String menuName;
    private int menuPrice;
    private String menuMainimage;
    private String menuIntro;
    private String menuExtra;
}
