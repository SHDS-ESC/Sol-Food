<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>식당 목록</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/reset.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/list.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script>
        // Context Path를 JavaScript에서 사용할 수 있도록 설정
        var contextPath = '${pageContext.request.contextPath}';

        // 카카오맵 SDK 동적 로딩
        function loadKakaoMapSDK() {
            return new Promise((resolve, reject) => {
                if (typeof kakao !== 'undefined' && kakao.maps) {
                    resolve();
                    return;
                }

                const script = document.createElement('script');
                script.type = 'text/javascript';
                script.src = '//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services&autoload=false';
                script.onload = () => {
                    kakao.maps.load(() => {
                        resolve();
                    });
                };
                script.onerror = () => {
                    reject();
                };
                document.head.appendChild(script);
            });
        }

        // 페이지 로드 후 SDK 로딩
        window.kakaoMapSDKPromise = loadKakaoMapSDK();
    </script>
</head>
<body>
<div class="wrap">
    <%@ include file="../include/header.jsp" %>
    <div class="content store-list">
        <div class="map-tab-box">
            <button id="mapBtn" class="map-tab" onclick="showMap()">지도</button>
            <button id="listBtn" class="map-tab active" onclick="showList()">목록</button>
            <div class="map-tab-bar"></div>
        </div>

        <div class="map-category-container" id="mapCategoryContainer">
            <div class="map-category-scroll" id="mapCategoryScroll">
                <!-- 전체 카테고리 버튼 (항상 첫 번째) -->
                <button class="map-category-btn active" onclick="selectMapCategory(this, '전체')">전체</button>

                <!-- 실제 카테고리들 -->
                <c:forEach items="${categories}" var="category" varStatus="status">
                    <button class="map-category-btn"
                            onclick="selectMapCategory(this, '${category.categoryName}')">${category.categoryName}</button>
                </c:forEach>
            </div>
        </div>

        <div id="mapContainer" class="map-container">
            <div id="map" class="map-view" style="display:none"></div>
        </div>

        <div class="sticky-top-group">
            <div class="category-container">
                <!-- 카테고리 그리드 영역은 id만 남기고 forEach 제거 -->
                <div class="category-grid" id="mainCategoryGrid"></div>
                <div class="category-grid category-grid-extended" id="extendedCategories"></div>
            </div>
        </div>
        <div class="scroll-list-area">
            <div class="scroll-list-header">
                <div class="sort-dropdown">
                    <button class="sort-selected" onclick="toggleSortDropdown()">

                        <span id="sortSelectedText">정렬</span>
                        <i class="bi bi-chevron-down"></i>
                    </button>
                    <div class="sort-dropdown-menu" id="sortDropdownMenu">
                        <div class="sort-option" data-value="star">별점순</div>
                        <div class="sort-option" data-value="like">찜 많은순</div>
                        <div class="sort-option" data-value="id">최신순</div>
                    </div>
                </div>
                <div class="search-bar">
                    <input type="text" id="searchInput" class="form-control" placeholder="검색">
                    <button id="searchBtn" class="btn btn-primary" onclick="performSearch()">
                        <i class="bi bi-search"></i>
                    </button>
                </div>

            </div>

            <div id="listContainer" class="list-container">
                <div class="store-grid" id="storeGrid">
                    <!-- 초기 데이터는 JavaScript에서 동적으로 로드 -->
                </div>
                <button id="loadMoreBtn" class="more-btn" style="width:100%;margin:4px auto;display:none;"
                        onclick="loadMoreStores()">더보기
                </button>
            </div>
        </div>
    </div>
    <%@ include file="../include/footer.jsp" %>
    </div>
</div>


    <script src="<c:url value='/js/urlConstants.js' />?v=${pageContext.session.creationTime}"></script>
    <script>
        // UrlConstants 로딩 확인
        if (typeof UrlConstants === 'undefined') {
            console.error('UrlConstants 로딩 실패');
            alert('스크립트 로딩 오류가 발생했습니다. 페이지를 새로고침해주세요.');
        }
    </script>
    <script src="<c:url value='/js/common-utils.js' />?v=${pageContext.session.creationTime}"></script>
    <script src="<c:url value='/js/cart.js' />?v=${pageContext.session.creationTime}"></script>
    <script src="<c:url value='/js/store.js' />?v=${pageContext.session.creationTime}"></script>
    <script src="<c:url value='/js/darkmode.js' />"></script>

    <script>
    // 페이지 로드 시 장바구니 개수 조회
    document.addEventListener('DOMContentLoaded', function() {
        // 로그인된 사용자인 경우에만 장바구니 개수 조회
        <c:if test="${not empty sessionScope.userLoginSession}">
            fetchCartCount();
        </c:if>
    });

    // 장바구니 개수 조회 함수
    function fetchCartCount() {
        fetch(UrlConstants.Builder.fullUrl(UrlConstants.API.CART_COUNT))
            .then(response => response.json())
            .then(data => {
                const count = data.count || 0;
                SolFoodUtils.updateBadge('.cart-nav-badge', count);
            })
            .catch(error => {
                console.log('장바구니 개수 조회 실패 (로그인하지 않은 경우 등):', error);
            });
    }
    </script>
    <div id="categoriesData" style="display:none;" 
         data-categories='[
            <c:forEach items="${categories}" var="category" varStatus="status">
                {"categoryName": "${fn:escapeXml(category.categoryName)}", "categoryImage": "${fn:escapeXml(category.categoryImage)}"}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
         ]'></div>
    <script>
        // HTML 데이터 속성에서 카테고리 정보 읽기
        const categoriesDataElement = document.getElementById('categoriesData');
        if (categoriesDataElement) {
            try {
                window.allCategories = JSON.parse(categoriesDataElement.getAttribute('data-categories'));
            } catch (e) {
                console.error('카테고리 데이터 파싱 실패:', e);
                window.allCategories = [];
            }
        } else {
            window.allCategories = [];
        }
    </script>
</body>
</html>
