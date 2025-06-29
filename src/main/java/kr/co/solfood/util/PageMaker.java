package kr.co.solfood.util;

import lombok.Data;

import java.util.List;

@Data
public class PageMaker<T> {
    private List<T> list;
    private Integer pageCount;
    private Integer limit;
    private int curPage;
    private long count;
    private int totalPageCount;
    private int firstPage;
    private int lastPage;

    public PageMaker(List<T> list, long count, Integer limit, int curPage) {
        final int pageGroupCount = 10; // 한그룹당 페이지 수
        this.limit = limit; // 페이지당 데이터 수
        this.list = list; // 페이지에 해당 데이터
        this.count = count;  //전체 data
        this.curPage = curPage; // 현재 페이지
        if (limit != null) {
            this.pageCount = (int) Math.ceil((double) count / limit);// 전체 페이지 수 계산
            final int pageGroup = (int) Math.ceil((double) curPage / pageGroupCount); // 페이지 그룹 수 계산

            // 현재 페이지 그룹의 시작 페이지와 끝 페이지 계산
            this.firstPage = ((pageGroup - 1) * limit) + 1;
            this.lastPage = Math.min(pageGroup * limit, pageCount);
        }

    }

    public PageMaker() {

    }
}