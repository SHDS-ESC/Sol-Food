package kr.co.solfood.user.board.response;

import kr.co.solfood.user.board.BoardVO;

import java.util.List;

public class BoardListResponseVO {
    private List<BoardVO> list;
    private boolean hasNext;
    private int offset;
    private int pageSize;
    private long totalCount;
    private boolean error;
    private String message;

    // 성공 응답 생성자
    private BoardListResponseVO(List<BoardVO> list, boolean hasNext, int offset, int pageSize, long totalCount) {
        this.list = list;
        this.hasNext = hasNext;
        this.offset = offset;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.error = false;
        this.message = null;
    }

    // 에러 응답 생성자
    private BoardListResponseVO(String errorMessage){
        this.list = List.of();
        this.hasNext = false;
        this.offset = 0;
        this.pageSize = 0;
        this.totalCount = 0;
        this.error = true;
        this.message = errorMessage;
    }

    // 정적 팩토리 메서드
    public static BoardListResponseVO success(List<BoardVO> list, boolean hasNext, int offset, int pageSize, long totalCount){
        return new BoardListResponseVO(list, hasNext, offset, pageSize, totalCount);
    }

    // Getter 메서드
    public List<BoardVO> getList() {return list;}
    public boolean isHasNext() { return hasNext; }
    public int getOffset() { return offset; }
    public int getPageSize() { return pageSize; }
    public long getTotalCount() { return totalCount; }
    public boolean isError() { return error; }
    public String getMessage() { return message; }

}
