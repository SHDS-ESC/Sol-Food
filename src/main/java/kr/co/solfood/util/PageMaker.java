package kr.co.solfood.util;

import lombok.Data;

import java.util.List;

@Data
public class PageMaker<T> {
    private List<T> itemList;
    private Integer pageCount;
    private int curPage;
    private long totalCount;
    private int firstPage;
    private int lastPage;
    private boolean isLastPage;
    private boolean isFirstPage;
    public PageMaker(List<T> itemList, long totalCount, Integer limit, int curPage) {
        final int pageGroupCount = 10; // 한그룹당 페이지 수
        this.itemList = itemList; // 페이지에 해당 데이터
        this.totalCount = totalCount;  //전체 data
        this.curPage = curPage; // 현재 페이지
        if (limit != null) {
            this.pageCount = (int) Math.ceil((double) totalCount / limit);// 전체 페이지 수 계산
            final int pageGroup = (int) Math.ceil((double) curPage / pageGroupCount); // 페이지 그룹 수 계산

            // 현재 페이지 그룹의 시작 페이지와 끝 페이지 계산
            this.firstPage = ((pageGroup - 1) * limit) + 1;
            this.lastPage = Math.min(pageGroup * limit, pageCount);
        }

    }

    public PageMaker() {

    }
}
