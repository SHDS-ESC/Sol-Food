package kr.co.solfood.user.cart;

import lombok.Data;

import java.util.Date;

@Data
public class CartItemVO {
    private int cartItemId;
    private int cartId;
    private int menuId;
    private String menuName;
    private String menuImage;
    private int menuPrice;
    private int quantity;
    private int totalPrice; // menuPrice * quantity
    private Date createdAt;
    private Date updatedAt;
    
    public CartItemVO() {}
    
    public CartItemVO(int menuId, String menuName, String menuImage, int menuPrice, int quantity) {
        this.menuId = menuId;
        this.menuName = menuName;
        this.menuImage = menuImage;
        this.menuPrice = menuPrice;
        this.quantity = quantity;
    }
    
    // 총 가격 계산
    public int getTotalPrice() {
        return menuPrice * quantity;
    }
} 