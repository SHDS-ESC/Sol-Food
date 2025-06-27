package kr.co.solfood.admin.dto;

import kr.co.solfood.util.PageDTO;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Data
public class UserSearchResponseDTO extends PageDTO {
    private Long usersId;
    private Integer companyId;
    private Integer departmentId;
    private String usersEmail; // 이메일
    private String usersPwd; // 비밀번호
    private String usersNickname; // 닉네임
    private String usersProfile; // 프로필
    private String usersName; // 이름
    private Integer usersPoint; // 포인트
    private String usersGender;
    private String accessToken;
    private Long usersKakaoId;
    private String usersTel;
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private Date usersCreatedAt;
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private Date usersUpdatedAt;
    private String usersStatus;
    private String usersBirth;
    private String usersLoginType;
    private String companyName; // 부서 이름
    private String departmentName;
}
