package kr.co.solfood.store;

import lombok.Data;

@Data
public class StoreVO {
    private int storeId;
    private String storeName;
    private String storeAddress;
    private String storeLatitude;
    private String storeLongitude;
    private int storeAvgStar;
    private String intro;
    private String mainImage;
    private String storeCategory;
    private int storeCapacity;
    private String storeTel;
}
