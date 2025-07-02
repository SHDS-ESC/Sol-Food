package kr.co.solfood.user.cart;

import lombok.Data;

import java.util.Date;

@Data
public class CartItemVO {
//    private int cartItemId;
//    private int cartId;
    private int menuId;
    private String menuName;
    private String menuImage;
    private int menuPrice; // 기본 메뉴 가격
    private int unitPrice; // 옵션 포함 단가
    private int quantity;
    private int totalPrice; // unitPrice * quantity
    private String options; // 선택된 옵션 정보 (JSON 형태)
    private Date createdAt;
    private Date updatedAt;
    
    public CartItemVO() {}
    
    public CartItemVO(int menuId, String menuName, String menuImage, int menuPrice, int quantity) {
        this.menuId = menuId;
        this.menuName = menuName;
        this.menuImage = menuImage;
        this.menuPrice = menuPrice;
        this.unitPrice = menuPrice; // 기본적으로는 메뉴 가격과 동일
        this.quantity = quantity;
        this.options = null;
    }
    
    public CartItemVO(int menuId, String menuName, String menuImage, int menuPrice, int unitPrice, int quantity, String options) {
        this.menuId = menuId;
        this.menuName = menuName;
        this.menuImage = menuImage;
        this.menuPrice = menuPrice;
        this.unitPrice = unitPrice;
        this.quantity = quantity;
        this.options = options;
    }
    
    // 총 가격 계산 (옵션 포함 단가 기준)
    public int getTotalPrice() {
        return unitPrice * quantity;
    }
    
    // 옵션 가격만 계산
    public int getOptionsPrice() {
        return unitPrice - menuPrice;
    }
} 