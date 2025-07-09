package kr.co.solfood.user.cart;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class BillDTO {
    private long leaderId;               // 발의자 ID
    private int totalAmount;             // 총 주문 금액
    private int storeId;                 // 매장 ID
    private String storeName;            // 매장 이름
    private List<CartItemVO> cartItems;  // 주문 상품 목록
    private Map<Long, Integer> userBill; // 참여자별 부담 금액 (key: 참여자 ID, value: 부담 금액)
    
}
