package kr.co.solfood.util;

import lombok.Data;

@Data
public class PageDTO {
    private final int MAX_PAGE_SIZE = 50;
    private final int DEFAULT_PAGE_SIZE = 10;

    private int currentPage = 1;
    int pageSize = 10;
    int offset = 0;

    public PageDTO() {
        this.currentPage = 1;
        this.pageSize = DEFAULT_PAGE_SIZE;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = Math.max(currentPage, 1);
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize > MAX_PAGE_SIZE || pageSize <= DEFAULT_PAGE_SIZE ? DEFAULT_PAGE_SIZE : pageSize;
    }

    public int getOffset() {
        return (currentPage - 1) * pageSize;
    }
}
