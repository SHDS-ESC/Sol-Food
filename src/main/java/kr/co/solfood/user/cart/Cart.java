package kr.co.solfood.user.cart;

import kr.co.solfood.user.menu.MenuVO;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class Cart {
    private List<CartItem> items = new ArrayList<>();

    public void addItem(MenuVO menu, int quantity) {
        for(CartItem item : items){
            if(item.getMenu().getMenuId() == menu.getMenuId()){
                item.setQuantity(item.getQuantity() + quantity);
                return;
            }
        }
    }
}
