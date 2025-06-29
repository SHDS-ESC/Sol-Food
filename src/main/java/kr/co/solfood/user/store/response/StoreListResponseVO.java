package kr.co.solfood.user.store.response;

import kr.co.solfood.user.store.StoreVO;
import java.util.List;

/**
 * 가게 목록 API 응답 VO
 */
public class StoreListResponseVO {
    private List<StoreVO> list;
    private boolean hasNext;
    private int offset;
    private int pageSize;
    private long totalCount;
    private boolean error;
    private String message;
    
    // 성공 응답 생성자
    private StoreListResponseVO(List<StoreVO> list, boolean hasNext, int offset, int pageSize, long totalCount) {
        this.list = list;
        this.hasNext = hasNext;
        this.offset = offset;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.error = false;
        this.message = null;
    }
    
    // 에러 응답 생성자
    private StoreListResponseVO(String errorMessage) {
        this.list = List.of();
        this.hasNext = false;
        this.offset = 0;
        this.pageSize = 0;
        this.totalCount = 0;
        this.error = true;
        this.message = errorMessage;
    }
    
    // 정적 팩토리 메서드
    public static StoreListResponseVO success(List<StoreVO> list, boolean hasNext, int offset, int pageSize, long totalCount) {
        return new StoreListResponseVO(list, hasNext, offset, pageSize, totalCount);
    }
    
    public static StoreListResponseVO error(String message) {
        return new StoreListResponseVO(message);
    }
    
    // Getter 메서드들
    public List<StoreVO> getList() { return list; }
    public boolean isHasNext() { return hasNext; }
    public int getOffset() { return offset; }
    public int getPageSize() { return pageSize; }
    public long getTotalCount() { return totalCount; }
    public boolean isError() { return error; }
    public String getMessage() { return message; }
} 