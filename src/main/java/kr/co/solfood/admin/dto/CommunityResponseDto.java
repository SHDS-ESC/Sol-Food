package kr.co.solfood.admin.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

@Data
public class CommunityResponseDto {
    String boardId;
    String usersId;
    String usersNickname;
    String boardTitle;
    String boardViewcount;
    @JsonFormat(pattern = "yyyy-MM-dd")
    String boardDate;
    String boardStatus;
}
