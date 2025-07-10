package kr.co.solfood.user.board;
import kr.co.solfood.util.PageMaker;
import kr.co.solfood.util.PageDTO;


public interface BoardService {
    // 게시글 등록
    int save(BoardVO req);

    // 게시글 목록
    PageMaker<BoardVO> getBoardList(PageDTO pageDTO);

    // 게시글 단건 조회
    BoardVO getBoardDetail(int id);

    // 조회수 1씩 증가
    void updateViewCount(int id);

    // 게시글 수정
    int updateBoard(BoardVO req);

    // 게시글 삭제
    void deleteBoard(int id);
}
