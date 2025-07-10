package kr.co.solfood.user.board;

import kr.co.solfood.util.PageDTO;
import kr.co.solfood.util.PageMaker;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BoardServiceImpl implements BoardService {

    @Autowired
    private BoardMapper boardMapper;

    // 게시글 등록
    @Override
    public int save(BoardVO req) {
        return boardMapper.saveBoard(req);
    }


    // 게시글 목록
    @Override
    public PageMaker<BoardVO> getBoardList(PageDTO pageDTO) {
        List<BoardVO> list = boardMapper.getBoardList(
                pageDTO.getOffset(),
                pageDTO.getPageSize());
        return new PageMaker<>(
                list,
                list.size(),
                pageDTO.getPageSize(),
                pageDTO.getCurrentPage()) ;
    }

    // 게시글 단건 조회
    @Override
    public BoardVO getBoardDetail(int id) {
        return boardMapper.getBoardDetail(id);
    }

    // 조회수 1씩 증가
    @Override
    public void updateViewCount(int id) {
        boardMapper.updateViewCount(id);
    }

    // 게시글 수정
    @Override
    public int updateBoard(BoardVO req) {
        return boardMapper.updateBoard(req);
    }

    // 게시글 삭제
    @Override
    public void deleteBoard(int id) {
        boardMapper.deleteBoard(id);
    }


}
