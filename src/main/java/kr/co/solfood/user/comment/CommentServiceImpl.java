package kr.co.solfood.user.comment;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CommentServiceImpl implements CommentService {
    @Autowired
    private CommentMapper commentMapper;

    // 댓글 등록
    @Override
    public int insertComment(CommentVO vo) {
        return commentMapper.insertComment(vo);
    }

    // 댓글 전체 조회
    @Override
    public List<CommentVO> getCommentsByBoardId(int boardId) {
        return commentMapper.getCommentsByBoardId(boardId);
    }

    @Override
    public int deleteComment(int commentId) {
        return commentMapper.deleteComment(commentId);
    }


}
