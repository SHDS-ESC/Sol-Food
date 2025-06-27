package kr.co.solfood.user.store;

import kr.co.solfood.util.PageDTO;
import lombok.Data;

@Data
public class StoreVO extends PageDTO {
    private int storeId;           // store_id
    private int categoryId;        // category_id (FK)
    private String storeName;      // store_name
    private String storeAddress;   // store_address
    private double storeLatitude;  // store_latitude
    private double storeLongitude; // store_longitude
    private int storeAvgstar;      // store_avgstar
    private String storeIntro;     // store_intro
    private String storeMainimage; // store_mainimage
    private String storeTel;       // store_tel
    
    // JOIN으로 가져오는 카테고리 정보
    private String storeCategory;  // category.category_name (alias)


}