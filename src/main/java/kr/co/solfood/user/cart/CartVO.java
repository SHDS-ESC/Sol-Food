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
    
    // 총 금액 계산 (옵션 가격 포함)
    public int getTotalAmount() {
        return items.stream()
                .mapToInt(item -> {
                    // unitPrice가 설정되어 있으면 사용, 없으면 menuPrice 사용
                    int price = (item.getUnitPrice() > 0) ? item.getUnitPrice() : item.getMenuPrice();
                    return price * item.getQuantity();
                })
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
            // 같은 메뉴이고 같은 옵션(unitPrice와 options가 동일)인 경우에만 수량 증가
            if (item.getMenuId() == newItem.getMenuId() && 
                isSameOptions(item, newItem)) {
                item.setQuantity(item.getQuantity() + newItem.getQuantity());
                return;
            }
        }
        items.add(newItem);
    }
    
    // 두 아이템의 옵션이 동일한지 확인
    private boolean isSameOptions(CartItemVO item1, CartItemVO item2) {
        // unitPrice가 다르면 다른 옵션
        int price1 = (item1.getUnitPrice() > 0) ? item1.getUnitPrice() : item1.getMenuPrice();
        int price2 = (item2.getUnitPrice() > 0) ? item2.getUnitPrice() : item2.getMenuPrice();
        
        if (price1 != price2) {
            return false;
        }
        
        // 옵션 문자열 비교
        String options1 = item1.getOptions();
        String options2 = item2.getOptions();
        
        if (options1 == null && options2 == null) {
            return true;
        }
        
        if (options1 == null || options2 == null) {
            return false;
        }
        
        return options1.equals(options2);
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