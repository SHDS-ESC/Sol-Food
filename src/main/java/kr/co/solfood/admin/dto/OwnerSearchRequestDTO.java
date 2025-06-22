package kr.co.solfood.admin.dto;

import lombok.Data;

@Data
public class OwnerSearchRequestDTO {
    String ownerId;
    String storeMainImage;
    String storeName;
    String ownerEmail;
    String storeCategory;
    int storeAvgStar;
    String ownerTel;
    String storeTel;
    String storeAddress;
    String storeIntro;
    String ownerStatus;
}
