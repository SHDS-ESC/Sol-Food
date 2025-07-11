/**
 * 클라이언트 사이드에서 사용할 URL 상수 객체
 */
window.UrlConstants = {
    
    /**
     * Context Path 자동 감지 헬퍼 함수
     * JSP에서 contextPath 변수를 설정하면 우선 사용, 없으면 자동 감지
     */
    getContextPath: function() {
        // JSP에서 설정된 contextPath 변수 우선 사용
        if (typeof contextPath !== 'undefined' && contextPath) {
            return contextPath;
        }
        
        // 현재 URL에서 context path 추출
        const pathname = window.location.pathname;
        const pathSegments = pathname.split('/');
        
        // /solfood/... 형태라면 /solfood 반환
        if (pathSegments.length > 1 && pathSegments[1] === 'solfood') {
            return '/solfood';
        }
        
        // 기본값은 빈 문자열 (root context)
        return '';
    },
    
    /**
     * URL 빌더 헬퍼 함수들
     */
    Builder: {
        /**
         * Context Path를 포함한 완전한 URL 생성
         */
        fullUrl: function(path) {
            const contextPath = window.UrlConstants.getContextPath();
            return contextPath + path;
        },
        
        /**
         * 가게 상세 페이지 URL 생성
         */
        storeDetail: function(storeId) {
            const path = `${UrlConstants.Pages.STORE_DETAIL}?storeId=${storeId}`;
            return window.UrlConstants.Builder.fullUrl(path);
        },
        
        /**
         * 찜 추가/취소 URL 생성
         */
        likeAction: function(isAdd) {
            const path = isAdd ? UrlConstants.API.LIKE_ADD : UrlConstants.API.LIKE_CANCEL;
            return window.UrlConstants.Builder.fullUrl(path);
        }
    },
    
    /**
     * 주요 페이지 URL들
     */
    Pages: {
        STORE_LIST: '/user/store',
        STORE_DETAIL: '/user/store/detail',
        CART: '/user/cart',
        CART_PAYMENT_METHOD: '/user/cart/payment-method',
        CART_INVITE_FRIENDS: '/user/cart/invite-friends',
        CART_MAKE_BILL: '/user/cart/make-bill',
        CART_WAITING_APPROVAL: '/user/cart/waiting-approval',
        CART_PAYMENT_COMPLETE: '/user/cart/payment-complete',
        MY_PAGE: '/user/mypage',
        LIKE: '/user/like'
    },
    
    /**
     * API 엔드포인트들
     */
    API: {
        // 가게 관련
        STORE_LIST: '/user/store/api/list',
        STORE_SEARCH: '/user/store/api/search',
        STORE_DETAIL: '/user/store/api/detail',
        STORE_CATEGORY_CONFIG: '/user/store/api/category/config',
        STORE_SEARCH_BY_NAME: '/user/store/search/name',
        
        // 장바구니 관련
        CART_COUNT: '/user/cart/count',
        CART_ADD: '/user/cart/add',
        CART_ADD_WITH_OPTIONS: '/user/cart/add-with-options',
        CART_UPDATE: '/user/cart/update',
        CART_REMOVE: '/user/cart/remove',
        CART_CLEAR: '/user/cart/clear',
        CART_TOTAL: '/user/cart/total',
        CART_COMPARE_STORE: '/user/cart/compare-store',
        CART_SELECTED_FRIENDS: '/user/cart/selected-friends',
        CART_FRIENDS_API: '/user/cart/friends-api',
        CART_FRIENDS_SYNC: '/user/cart/friends/sync',
        CART_INVITE_CONFIRM: '/user/cart/invite-confirm',
        CART_GET_SELECTED_FRIENDS: '/user/cart/get-selected-friends',
        CART_CALCULATE_DUTCH_PAY: '/user/cart/calculate-dutch-pay',
        CART_SUBMIT_BILL: '/user/cart/submit-bill',
        CART_PAYMENT_STATUS_STREAM: '/user/cart/payment-status-stream',
        
        // 리뷰 관련
        REVIEW_LIST: '/user/review/api/list',
        
        // 찜 관련
        LIKE_ADD: '/user/like/add',
        LIKE_CANCEL: '/user/like/cancel'
    }
};

// CommonJS 스타일 내보내기 지원 (Node.js 환경)
if (typeof module !== 'undefined' && module.exports) {
    module.exports = window.UrlConstants;
}

// AMD 스타일 내보내기 지원 (RequireJS)
if (typeof define === 'function' && define.amd) {
    define([], function() {
        return window.UrlConstants;
    });
} 