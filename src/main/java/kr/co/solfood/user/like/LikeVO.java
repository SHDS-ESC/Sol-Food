package kr.co.solfood.user.like;

import lombok.Data;

@Data
public class LikeVO {
    private int userLikesId;
    private int usersId;
    private int storeId;
}
