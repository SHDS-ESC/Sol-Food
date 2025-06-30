package kr.co.solfood.user.store;

import kr.co.solfood.util.PageDTO;
import lombok.Data;

@Data
public class StoreVO extends PageDTO {
    private int storeId;           // store_id
    private int ownerId;           // owner_id (FK) - 새로 추가
    private int categoryId;        // category_id (FK)
    private String storeName;      // store_name
    private String storeAddress;   // store_address
    private double storeLatitude;  // store_latitude
    private double storeLongitude; // store_longitude
    private int storeAvgstar;      // store_avgstar
    private String storeIntro;     // store_intro
    private String storeMainimage; // store_mainimage
    private String storeTel;       // store_tel
    private String storeStatus;    // store_status - 새로 추가
    private String storeRejectReason; // store_reject_reason - 새로 추가
    
    // JOIN으로 가져오는 카테고리 정보
    private String storeCategory;  // category.category_name (alias)
    
    // 찜 상태 (DB에서 직접 가져오지 않고 애플리케이션에서 설정)
    private boolean liked;         // 현재 사용자의 찜 여부

}