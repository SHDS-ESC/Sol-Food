package kr.co.solfood.user.review;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ReviewVO {
    
    // === 상수 정의 ===
    public static final String STATUS_ACTIVE = "Y";
    public static final String STATUS_INACTIVE = "N";
    public static final int MIN_STAR_RATING = 1;
    public static final int MAX_STAR_RATING = 5;
    public static final int MAX_CONTENT_LENGTH = 1000;
    public static final int MAX_TITLE_LENGTH = 100;
    
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
    
    /**
     * 활성 상태인지 확인
     */
    public boolean isActive() {
        return STATUS_ACTIVE.equals(this.reviewStatus);
    }
    
    /**
     * 별점이 유효한 범위인지 확인
     */
    public boolean isValidStarRating() {
        return reviewStar != null && 
               reviewStar >= MIN_STAR_RATING && 
               reviewStar <= MAX_STAR_RATING;
    }
    
    /**
     * 리뷰 내용이 유효한지 확인
     */
    public boolean isValidContent() {
        return reviewContent != null && 
               !reviewContent.trim().isEmpty() && 
               reviewContent.length() <= MAX_CONTENT_LENGTH;
    }
    
    /**
     * 리뷰 제목이 유효한지 확인
     */
    public boolean isValidTitle() {
        return reviewTitle == null || 
               reviewTitle.length() <= MAX_TITLE_LENGTH;
    }
}
