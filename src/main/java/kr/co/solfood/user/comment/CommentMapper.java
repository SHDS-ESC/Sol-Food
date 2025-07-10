package kr.co.solfood.user.comment;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface CommentMapper {
    // 댓글 등록
    int insertComment(CommentVO vo);

    // 댓글 전체 조회
    List<CommentVO> getCommentsByBoardId(int boardId);

    // 댓글삭제
    int deleteComment(int commentId);
}
