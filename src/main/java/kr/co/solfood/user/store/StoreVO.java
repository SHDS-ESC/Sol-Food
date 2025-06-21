package kr.co.solfood.user.store;

import lombok.Data;

@Data
public class StoreVO {
    private int storeId;           // store_id
    private String storeName;      // store_name
    private String storeAddress;   // store_address
    private double storeLatitude;  // store_latitude
    private double storeLongitude; // store_longitude
    private int storeAvgstar;      // store_avgstar
    private String storeIntro;     // store_intro
    private String storeMainimage; // store_mainimage
    private String storeCategory;  // store_category
    private int storeCapacity;     // store_capacity
    private String storeTel;       // store_tel
}