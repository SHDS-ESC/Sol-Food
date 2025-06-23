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
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
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
        <input type="text" class="form-control" placeholder="검색어를 입력해주세요">
        <button class="btn btn-primary">검색</button>
    </div>

    <div class="map-category-container" id="mapCategoryContainer">
        <div class="map-category-scroll" id="mapCategoryScroll">
            <c:forEach items="${['전체', '치킨', '한식', '분식', '피자', '찜/탕', '중식', '일식', '양식', '카페', '버거', '도시락', '샐러드', '디저트', '회/해물', '국물요리', '간식', '족발/보쌈', '베이커리']}" var="category" varStatus="status">
                <button class="map-category-btn ${status.first ? 'active' : ''}" onclick="selectMapCategory(this, '${category}')">${category}</button>
            </c:forEach>
        </div>
    </div>

    <div class="category-container">
        <div class="category-grid" id="mainCategoryGrid">
            <c:forEach items="${['전체', '치킨', '한식', '분식', '피자']}" var="category" varStatus="status">
                <button class="category-item ${status.first ? 'active' : ''}" onclick="selectCategory(this, '${category}')">
                    <div class="category-icon"></div>
                    <span class="category-name">${category}</span>
                </button>
            </c:forEach>
        </div>
        
        <div class="category-grid">
            <c:forEach items="${['찜/탕', '중식', '일식', '양식']}" var="category">
                <button class="category-item" onclick="selectCategory(this, '${category}')">
                    <div class="category-icon"></div>
                    <span class="category-name">${category}</span>
                </button>
            </c:forEach>
            <button class="category-item" onclick="toggleMoreCategories()">
                <div class="category-icon"></div>
                <span class="category-name" id="moreText">더보기</span>
            </button>
        </div>
        
        <div class="category-grid category-grid-extended" id="extendedCategories">
            <c:forEach items="${['카페', '버거', '도시락', '샐러드', '디저트', '회/해물', '국물요리', '간식', '족발/보쌈', '베이커리']}" var="category">
                <button class="category-item" onclick="selectCategory(this, '${category}')">
                    <div class="category-icon"></div>
                    <span class="category-name">${category}</span>
                </button>
            </c:forEach>
        </div>
    </div>

    <div id="mapContainer" class="map-container">
        <div id="map" class="map-view" style="width:100%;height:100%;"></div>
    </div>

    <div id="listContainer" class="list-container">
        <div class="store-grid">
            <c:forEach items="${store}" var="store">
                <div class="store-card" data-category="${store.storeCategory}" onclick="goToStoreDetail('${store.storeId}')">
                    <c:choose>
                        <c:when test="${empty store.storeMainimage || store.storeMainimage eq '/img/default-restaurant.jpg'}">
                            <div class="store-img" style="background-color: #f8f9fa; display: flex; align-items: center; justify-content: center; color: #6c757d;">
                                <i class="bi bi-shop" style="font-size: 40px;"></i>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <img src="${store.storeMainimage}" alt="${store.storeName}" class="store-img"
                                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                            <div class="store-img" style="background-color: #f8f9fa; display: none; align-items: center; justify-content: center; color: #6c757d;">
                                <i class="bi bi-shop" style="font-size: 40px;"></i>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div class="store-body">
                        <div class="store-name">${store.storeName}</div>
                        <div class="store-category">${store.storeCategory}</div>
                        <c:if test="${not empty store.storeAddress}">
                            <div style="font-size: 11px; color: #666; margin-bottom: 3px;">
                                📍 <c:choose>
                                    <c:when test="${fn:length(store.storeAddress) > 15}">
                                        ${fn:substring(store.storeAddress, 0, 15)}...
                                    </c:when>
                                    <c:otherwise>
                                        ${store.storeAddress}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                        <div style="font-size: 12px;">
                            <c:choose>
                                <c:when test="${store.storeAvgstar > 0}">
                                    ⭐ ${store.storeAvgstar}점
                                </c:when>
                                <c:otherwise>
                                    ⭐ 신규매장
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <c:if test="${not empty store.storeTel && store.storeTel ne '정보없음'}">
                            <div style="font-size: 10px; color: #28a745; margin-top: 2px;">
                                📞 ${store.storeTel}
                            </div>
                        </c:if>
                        <i class="bi bi-heart like-icon"></i>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<div class="bottom-nav">
    <a href="#"><i class="bi bi-house"></i>홈</a>
    <a href="#"><i class="bi bi-list-check"></i>리스트</a>
    <a href="#"><i class="bi bi-calendar2-week"></i>캘린더</a>
    <a href="#"><i class="bi bi-heart-fill"></i>찜</a>
    <a href="#"><i class="bi bi-person-circle"></i>마이</a>
</div>

<script src="<c:url value='/js/store.js' />"></script>

</body>
</html>
