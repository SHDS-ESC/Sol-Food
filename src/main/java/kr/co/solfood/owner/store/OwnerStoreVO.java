package kr.co.solfood.owner.store;

import lombok.*;

/*
* 클라이언트로 받는 데이터는 원시형이 아닌 Null 처리가 가능한 랩핑형으로 넣어야함
* 대신 필수값 경우 valid 해야함
* 위와 같은 조건에의해 request 객체는 따로 만들어서 사용하는게 좋음
* 아래와 같이 공통 vo 처리시 위 조건을 지키기 어려움
*
* */
@Data
public class OwnerStoreVO {
    private int storeId; // 상점 아이디 o
    private int ownerId; // 점주
    private int categoryId; // 카테고리 아이디 o
    private String storeName; // 상점명 o
    private String storeAddress; // 상점 위치 o
    private Double storeLatitude; // 위도 o
    private Double storeLongitude; // 경도 o
    private double storeAvgstar; // 별점
    private String storeIntro; // 상점 소개 o
    private String storeMainimage; // 상점 대표 이미지 o
    private String storeTel; // 상점 번호 o
    private String storeStatus; // 가게 승인 상태
    private String storeRejectReason;
}

