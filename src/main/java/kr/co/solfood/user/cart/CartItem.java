package kr.co.solfood.user.cart;

import kr.co.solfood.user.menu.MenuVO;
import lombok.Data;

@Data
public class CartItem {
    private MenuVO menu;
    private int quantity;

    public CartItem(MenuVO menu, int quantity) {
        this.menu = menu;
        this.quantity = quantity;
    }
}
