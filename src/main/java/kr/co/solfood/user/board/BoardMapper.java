package kr.co.solfood.user.board;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface BoardMapper {
    // 게시글 등록
    int saveBoard(BoardVO vo);

    // 게시글 목록
    List<BoardVO> getBoardList(
            @Param("offset") int offset,
            @Param("pageSize") int pageSize
    );


    // 게시글 단건 조회
    BoardVO getBoardDetail(int id);

    // 게시글 조회수 증가
    void updateViewCount(int id);

    // 게시글 수정
    int updateBoard(BoardVO vo);

    // 게시글 삭제
    void deleteBoard(int id);
}
