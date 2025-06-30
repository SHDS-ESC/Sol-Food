package kr.co.solfood.user.cart;

import lombok.Data;
import java.util.ArrayList;
import java.util.List;

@Data
public class CartVO {
    private int storeId;
    private String storeName;
    private List<CartItemVO> items;
    
    public CartVO() {
        this.items = new ArrayList<>();
    }
    
    // 총 금액 계산
    public int getTotalAmount() {
        return items.stream()
                .mapToInt(item -> item.getMenuPrice() * item.getQuantity())
                .sum();
    }
    
    // 총 수량 계산
    public int getTotalQuantity() {
        return items.stream()
                .mapToInt(CartItemVO::getQuantity)
                .sum();
    }
    
    // 메뉴 추가 또는 수량 증가
    public void addItem(CartItemVO newItem) {
        for (CartItemVO item : items) {
            if (item.getMenuId() == newItem.getMenuId()) {
                item.setQuantity(item.getQuantity() + newItem.getQuantity());
                return;
            }
        }
        items.add(newItem);
    }
    
    // 아이템 제거 (menuId로)
    public boolean removeItem(int menuId) {
        return items.removeIf(item -> item.getMenuId() == menuId);
    }
    
    // 수량 업데이트
    public boolean updateQuantity(int menuId, int quantity) {
        for (CartItemVO item : items) {
            if (item.getMenuId() == menuId) {
                if (quantity <= 0) {
                    return removeItem(menuId);
                } else {
                    item.setQuantity(quantity);
                    return true;
                }
            }
        }
        return false;
    }
    
    // 장바구니 비우기
    public void clear() {
        items.clear();
        storeId = 0;
        storeName = null;
    }
    
    // 장바구니가 비어있는지 확인
    public boolean isEmpty() {
        return items.isEmpty();
    }
} 