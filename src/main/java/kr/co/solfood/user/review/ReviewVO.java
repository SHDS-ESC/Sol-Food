package kr.co.solfood.user.review;

import lombok.Data;
import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;

@Data
public class ReviewVO {
    private Integer reviewId;
    private Integer usersId;
    private Integer storeId;
    private Integer usersPaymentId;
    private Integer reviewCommentId;
    private Integer reviewStar;
    private String reviewImage;
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date reviewDate;
    private String reviewStatus;
    private String reviewTitle;
    private String reviewContent;
    private String reviewResponse;
}
