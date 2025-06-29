/**
 * 클라이언트 사이드에서 사용할 URL 상수 객체 (단순화된 버전)
 */
window.UrlConstants = {
    
    /**
     * Context Path 자동 감지 헬퍼 함수
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
            const path = `/user/store/detail?storeId=${storeId}`;
            return window.UrlConstants.Builder.fullUrl(path);
        },
        
        /**
         * 찜 추가/취소 URL 생성
         */
        likeAction: function(isAdd) {
            const path = isAdd ? '/user/like/add' : '/user/like/cancel';
            return window.UrlConstants.Builder.fullUrl(path);
        }
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