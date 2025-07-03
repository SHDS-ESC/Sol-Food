package kr.co.solfood.user.cart;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class BillDTO {
    private long leaderId;           // 발의자 ID
    private int totalAmount;         // 총 주문 금액
    private int storeId;
    private String storeName;
    private List<CartItemVO> cartItems;
    private Map<Long, Integer> userBill;
    
}
