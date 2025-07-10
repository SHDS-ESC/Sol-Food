package kr.co.solfood.user.comment;

import lombok.Data;

import java.util.Date;

@Data
public class CommentVO {
    private int commentId; // 게시판 아이디
    private long usersId; // 사용자 아이디
    private int boardId; // 게시판 아이디
    private String commentContent; // 댓글 내용
    private Date commentDate; // 댓글 등록일
    private int commentStatus; // 댓글 상태
    private int gno; // 부모 댓글 아이디

    private String commentWriter; // 유저 닉네임
    private String commentWriterImage;   // 작성자 프로필
}
