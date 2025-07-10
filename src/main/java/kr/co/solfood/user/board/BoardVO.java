package kr.co.solfood.user.board;

import lombok.Data;

import java.util.Date;

@Data
public class BoardVO {
    private int boardId; // 게시판 아이디
    private int usersId; // 사용자 아이디
    private String boardTitle; // 제목 o
    private String boardContent; // 내용 o
    private int boardViewcount; // 조회수
    private String boardImage; // 이미지 o
    private Date boardDate; // 등록일
    private String boardStatus; // 상태

    private int commentCount; // 댓글수

    private String boardWirter;        // 작성자 닉네임 (AS board_wirter)
    private String boardWriterImage;   // 작성자 프로필 (AS board_writer_image)
}