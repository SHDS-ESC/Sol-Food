package kr.co.solfood.admin.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

@Data
public class OwnerReviewResponseDto {
    String reviewId;
    String usersId;
    String storeId;
    String reviewStar;
    String reviewContent;
    @JsonFormat(pattern = "yyyy-MM-dd")
    String reviewDate;
}
