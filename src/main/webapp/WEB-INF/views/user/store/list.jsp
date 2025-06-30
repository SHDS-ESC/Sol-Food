<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <link href="<c:url value='/css/store.css' />" rel="stylesheet">
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

<div class="app-container">
    <div class="header">
        <div><strong>로고</strong></div>
        <div class="toggle-btns">
            <button id="mapBtn" class="btn btn-outline-secondary btn-sm" onclick="showMap()">지도</button>
            <button id="listBtn" class="btn btn-outline-secondary btn-sm btn-active" onclick="showList()">목록</button>
        </div>
        <div><i class="bi bi-list" style="font-size: 20px;"></i></div>
    </div>

    <div class="search-bar">
        <input type="text" id="searchInput" class="form-control" placeholder="음식점명, 주소, 카테고리를 검색해보세요">
        <button id="searchBtn" class="btn btn-primary" onclick="performSearch()">
            <i class="bi bi-search"></i>
        </button>
    </div>

    <div class="map-category-container" id="mapCategoryContainer">
        <div class="map-category-scroll" id="mapCategoryScroll">
            <!-- 전체 카테고리 버튼 (항상 첫 번째) -->
            <button class="map-category-btn active" onclick="selectMapCategory(this, '전체')">전체</button>
            
            <!-- 실제 카테고리들 -->
            <c:forEach items="${categories}" var="category" varStatus="status">
                <button class="map-category-btn" onclick="selectMapCategory(this, '${category.categoryName}')">${category.categoryName}</button>
            </c:forEach>
        </div>
    </div>

    <div class="category-container">
        <div class="category-grid" id="mainCategoryGrid">
            <!-- 전체 카테고리 버튼 (항상 첫 번째) -->
            <button class="category-item active" onclick="selectCategory(this, '전체')">
                <div class="category-icon">
                    <i class="bi bi-grid-3x3-gap" style="font-size: 24px; color: #666;"></i>
                </div>
                <span class="category-name">전체</span>
            </button>
            
            <!-- 실제 카테고리들 (4개까지) -->
            <c:forEach items="${categories}" var="category" varStatus="status" begin="0" end="3">
                <button class="category-item" onclick="selectCategory(this, '${category.categoryName}')">
                    <div class="category-icon">
                        <c:if test="${not empty category.categoryImage}">
                            <img src="${category.categoryImage}" alt="${category.categoryName}" onerror="this.style.display='none';">
                        </c:if>
                    </div>
                    <span class="category-name">${category.categoryName}</span>
                </button>
            </c:forEach>
        </div>
        
        <div class="category-grid">
            <!-- 실제 카테고리들 (4-7번째) -->
            <c:forEach items="${categories}" var="category" varStatus="status" begin="4" end="7">
                <button class="category-item" onclick="selectCategory(this, '${category.categoryName}')">
                    <div class="category-icon">
                        <c:if test="${not empty category.categoryImage}">
                            <img src="${category.categoryImage}" alt="${category.categoryName}" onerror="this.style.display='none';">
                        </c:if>
                    </div>
                    <span class="category-name">${category.categoryName}</span>
                </button>
            </c:forEach>
            <c:if test="${fn:length(categories) > 8}">
                <button class="category-item" onclick="toggleMoreCategories()">
                    <div class="category-icon"></div>
                    <span class="category-name" id="moreText">더보기</span>
                </button>
            </c:if>
        </div>
        
        <c:if test="${fn:length(categories) > 8}">
            <div class="category-grid category-grid-extended" id="extendedCategories">
                <!-- 나머지 카테고리들 (8번째부터) -->
                <c:forEach items="${categories}" var="category" varStatus="status" begin="8">
                    <button class="category-item" onclick="selectCategory(this, '${category.categoryName}')">
                        <div class="category-icon">
                            <c:if test="${not empty category.categoryImage}">
                                <img src="${category.categoryImage}" alt="${category.categoryName}" onerror="this.style.display='none';">
                            </c:if>
                        </div>
                        <span class="category-name">${category.categoryName}</span>
                    </button>
                </c:forEach>
            </div>
        </c:if>
    </div>

    <div id="mapContainer" class="map-container">
        <div id="map" class="map-view" style="width:100%;height:100%;"></div>
    </div>

    <div id="listContainer" class="list-container">
        <div class="store-grid" id="storeGrid">
            <!-- 초기 데이터는 JavaScript에서 동적으로 로드 -->
        </div>
        <button id="loadMoreBtn" class="more-btn" style="width:100%;margin:20px auto;display:none;" onclick="loadMoreStores()">더보기</button>
    </div>

<div class="bottom-nav">
    <a href="/solfood/"><i class="bi bi-house"></i>홈</a>
    <a href="/solfood/user/cart" class="cart-nav-item">
        <i class="bi bi-bag"></i>장바구니
        <span class="cart-nav-badge">0</span>
    </a>
    <a href="#"><i class="bi bi-calendar2-week"></i>캘린더</a>
    <a href="/solfood/user/mypage/like"><i class="bi bi-heart-fill"></i>찜</a>
    <a href="/solfood/user/mypage"><i class="bi bi-person-circle"></i>마이</a>
</div>

    <script>
        // Context Path를 JavaScript에서 사용할 수 있도록 설정
        var contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="<c:url value='/js/urlConstants.js' />?v=${pageContext.session.creationTime}"></script>
    <script>
        // UrlConstants 로딩 확인
        if (typeof UrlConstants === 'undefined') {
            console.error('UrlConstants 로딩 실패');
            alert('스크립트 로딩 오류가 발생했습니다. 페이지를 새로고침해주세요.');
        }
    </script>
<script src="<c:url value='/js/cart.js' />?v=${pageContext.session.creationTime}"></script>
<script src="<c:url value='/js/store.js' />?v=${pageContext.session.creationTime}"></script>

</body>
</html>
