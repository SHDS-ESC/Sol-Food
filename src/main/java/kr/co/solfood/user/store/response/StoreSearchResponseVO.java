package kr.co.solfood.user.store.response;

import kr.co.solfood.user.store.StoreVO;
import java.util.List;

/**
 * 가게 검색 API 응답 VO
 */
public class StoreSearchResponseVO {
    private boolean success;
    private String keyword;
    private String searchType;
    private List<StoreVO> stores;
    private int count;
    private String message;
    
    private StoreSearchResponseVO(boolean success, String keyword, String searchType, List<StoreVO> stores, String message) {
        this.success = success;
        this.keyword = keyword;
        this.searchType = searchType;
        this.stores = stores != null ? stores : List.of();
        this.count = this.stores.size();
        this.message = message;
    }
    
    public static StoreSearchResponseVO success(String keyword, List<StoreVO> stores, String searchType) {
        return new StoreSearchResponseVO(true, keyword, searchType, stores, "검색이 완료되었습니다.");
    }
    
    public static StoreSearchResponseVO error(String keyword, String message) {
        return new StoreSearchResponseVO(false, keyword, null, null, message);
    }
    
    // Getter 메서드들
    public boolean isSuccess() { return success; }
    public String getKeyword() { return keyword; }
    public String getSearchType() { return searchType; }
    public List<StoreVO> getStores() { return stores; }
    public int getCount() { return count; }
    public String getMessage() { return message; }
} 