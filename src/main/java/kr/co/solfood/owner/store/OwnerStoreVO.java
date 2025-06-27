package kr.co.solfood.owner.store;

import lombok.Data;

@Data
public class OwnerStoreVO {
    private int storeId; // 상점 아이디 o
    private int categoryId; // 카테고리 아이디 o
    private String storeName; // 상점명 o
    private String storeAddress; // 상점 위치 o
    private double storeLatitude; // 위도 o
    private double storeLongitude; // 경도 o
    private int storeAvgstar; // 별점
    private String storeIntro; // 상점 소개 o
    private String storeMainimage; // 상점 대표 이미지 o
    private String storeTel; // 상점 번호 o
}
