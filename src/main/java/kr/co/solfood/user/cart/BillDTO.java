package kr.co.solfood.user.cart;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class BillDTO {
    private int storeId;
    private String storeName;
    private List<CartItemVO> items;
    private Map<Integer, Integer> userBill;
    
}
