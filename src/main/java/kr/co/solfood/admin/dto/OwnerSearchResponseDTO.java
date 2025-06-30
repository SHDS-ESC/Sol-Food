package kr.co.solfood.admin.dto;

import kr.co.solfood.util.PageDTO;
import lombok.Data;


@Data
public class OwnerSearchResponseDTO extends PageDTO {
    String ownerId;
    String storeMainImage;
    String storeName;
    String ownerEmail;
    String categoryName;
    Integer storeAvgStar;
    String ownerTel;
    String storeTel;
    String storeAddress;
    String storeIntro;
    String storeStatus;
    String storeRejectReason;
}
