package kr.co.solfood.user.comment;

import java.util.List;

public interface CommentService {
    // 댓글 등록
    int insertComment(CommentVO vo);

    // 댓글 전체 조회
    List<CommentVO> getCommentsByBoardId(int boardId);

    // 댓글 삭제 
    int deleteComment(int commentId);
}
