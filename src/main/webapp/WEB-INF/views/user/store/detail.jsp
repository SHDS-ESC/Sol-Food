<%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 25. 6. 17.
  Time: 오후 8:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>가게 리뷰</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- 외부 CSS 파일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storedetail.css">
    
    <!-- 카카오맵 SDK -->
    <script>
        // JSP에서 JavaScript로 데이터 전달
        window.kakaoJsKey = '${kakaoJsKey}';
        window.storeLatitude = parseFloat('${store.storeLatitude}');
        window.storeLongitude = parseFloat('${store.storeLongitude}');
        window.storeName = '${store.storeName}';
        window.storeAddress = '${store.storeAddress}';
        
        // 카카오맵 SDK 동적 로딩
        function loadKakaoMapSDK() {
            return new Promise((resolve, reject) => {
                if (typeof kakao !== 'undefined' && kakao.maps) {
                    resolve();
                    return;
                }
                
                const script = document.createElement('script');
                script.type = 'text/javascript';
                script.src = 'https://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services&autoload=false';
                script.onload = () => {
                    kakao.maps.load(() => {
                        console.log('카카오맵 SDK 로딩 완료');
                        resolve();
                    });
                };
                script.onerror = () => {
                    console.error('카카오맵 SDK 로딩 실패');
                    reject();
                };
                document.head.appendChild(script);
            });
        }
        
        // 페이지 로드 후 SDK 로딩
        window.kakaoMapSDKPromise = loadKakaoMapSDK();
    </script>
</head>
<body class="review-page">
    <div class="container">
        <div class="fixed-header">
            <!-- 상단 평점 요약 (리뷰 탭에서만 표시) -->
            <div class="summary hide" id="rating-summary">
                <div class="score">
                    <c:choose>
                        <c:when test="${not empty avgStar}">${avgStar}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>
                </div>
                <div class="stars">
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${not empty avgStar and i <= avgStar}">★</c:when>
                            <c:otherwise>☆</c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <div class="count">
                    평가 <c:choose>
                        <c:when test="${not empty totalCount}">${totalCount}</c:when>
                        <c:otherwise>0</c:otherwise>
                    </c:choose>개
                </div>
                <div class="bar-group">
                    <c:forEach begin="1" end="5" var="i">
                        <c:set var="starLevel" value="${6 - i}"/>
                        <c:set var="starCount" value="${starCounts != null && starCounts[starLevel-1] != null ? starCounts[starLevel-1] : 0}"/>
                        <c:set var="totalCountSafe" value="${totalCount != null && totalCount > 0 ? totalCount : 1}"/>
                        <c:set var="percentage" value="${starCount * 100 / totalCountSafe}"/>
                        <div class="bar">
                            <div class="bar-label">${starLevel}</div>
                            <div class="bar-bg">
                                <div class="bar-fill" data-percentage="<c:out value='${percentage}'/>"></div>
                            </div>
                            <div class="bar-percent">
                                <fmt:formatNumber value="${percentage}" pattern="#.#"/>%
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            
            <!-- 대표 메뉴 이미지 (메뉴 탭에서만 표시) -->
            <div class="featured-menu show" id="featured-menu">
                <div class="menu-hero">
                    <img src="<c:out value='${store.storeMainimage}'/>" alt="대표 메뉴" class="menu-hero-image">
                    <div class="menu-hero-overlay">
                        <h2>🍽️ <c:out value="${store.storeName}"/></h2>
                        <p><c:out value="${store.storeIntro}"/></p>
                    </div>
                </div>
            </div>
            
            <!-- 탭 메뉴 -->
            <div class="tabs">
                <div class="tab active" data-tab="menu">메뉴</div>
                <div class="tab" data-tab="map">상세정보</div>
                <div class="tab" data-tab="review">리뷰</div>
            </div>
        </div>
        
        <!-- 스크롤 가능한 콘텐츠 -->
        <div class="scrollable-content" data-has-reviews="${not empty reviewList ? 'true' : 'false'}">
            <!-- 메뉴 섹션 -->
            <div class="content-section active" id="menu-section">
                <c:if test="${not empty menuList}">
                    <!-- 카테고리 필터(수정 예정) -->
                    <div class="category-filter">
                        <div class="category-tabs">
                            <button class="category-tab active" data-category="전체">전체</button>
                            <button class="category-tab" data-category="프리미엄">프리미엄</button>
                            <button class="category-tab" data-category="도시락">도시락</button>
                            <button class="category-tab" data-category="정식시리즈">정식시리즈</button>
                            <button class="category-tab" data-category="마요시리즈">마요시리즈</button>
                            <button class="category-tab" data-category="카레">카레</button>
                            <button class="category-tab" data-category="볶음밥">볶음밥</button>
                            <button class="category-tab" data-category="덮밥">덮밥</button>
                            <button class="category-tab" data-category="비빔밥">비빔밥</button>
                            <button class="category-tab" data-category="실속반찬/단품">실속반찬/단품</button>
                            <button class="category-tab" data-category="스낵/디저트">스낵/디저트</button>
                            <button class="category-tab" data-category="신메뉴">신메뉴</button>
                        </div>
                    </div>
                </c:if>
                
                <div class="menu-list">
                    <c:choose>
                        <c:when test="${empty menuList}">
                            <div class="no-reviews">아직 등록된 메뉴가 없습니다.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="menu" items="${menuList}">
                                <div class="menu-item" data-category="<c:out value='${menu.category}'/>">
                                    <img src="<c:out value='${menu.menuMainimage}'/>" alt="<c:out value='${menu.menuName}'/>" class="menu-image" onerror="this.src='https://images.unsplash.com/photo-1590301157890-4810ed352733?w=80&h=80&fit=crop'">
                                    <div class="menu-info">
                                        <h3><c:out value="${menu.menuName}"/></h3>
                                        <p><c:out value="${menu.menuIntro}"/></p>
                                    </div>
                                    <div class="menu-price">₩<fmt:formatNumber value="${menu.menuPrice}" type="number" groupingUsed="true"/></div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- 지도 섹션 -->
            <div class="content-section" id="map-section">
                <!-- 가게 상세 정보를 지도 위쪽으로 이동 -->
                <div class="store-info-header">
                    <h3>🍽️ <c:out value="${store.storeName}"/></h3>
                    <p>📍 <c:out value="${store.storeAddress}"/></p>
                    <p>📞 <c:out value="${store.storeTel}"/></p>
                    <c:if test="${not empty store.storeCategory}">
                        <p>🍴 카테고리: <c:out value="${store.storeCategory}"/></p>
                    </c:if>
                </div>
                
                <div class="map-container">
                    <div id="map">
                        <div style="width:100%; height:100%; background:#f0f0f0; display:flex; align-items:center; justify-content:center; flex-direction:column;">
                            <div style="background:white; padding:20px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.1); text-align:center; max-width:300px;">
                                <h3 style="margin-bottom:15px; color:#333;">📍 가게 위치</h3>
                                <p style="margin:5px 0; color:#666;"><c:out value="${store.storeAddress}"/></p>
                                <p style="margin:5px 0; color:#666;">위도: <c:out value="${store.storeLatitude}"/></p>
                                <p style="margin:5px 0; color:#666;">경도: <c:out value="${store.storeLongitude}"/></p>
                                <div style="margin-top:15px;">
                                    <button onclick="loadKakaoMap()" style="background:#fee500; color:#000; border:none; padding:8px 16px; border-radius:5px; margin-right:10px; cursor:pointer; font-weight:bold;">카카오맵 재시도</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- 리뷰 섹션 -->
            <div class="content-section" id="review-section">
                <div class="review-list">
                    <c:choose>
                        <c:when test="${empty reviewList}">
                            <div class="no-reviews">
                                <p>아직 등록된 리뷰가 없습니다.</p>
                                <small style="color:#666;">첫 번째 리뷰를 작성해보세요!</small>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="review" items="${reviewList}" varStatus="status">
                                <div class="review-card">
                                    <div class="review-header">
                                        <span class="username">User<c:out value="${review.usersId}"/></span>
                                        <span class="stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= review.reviewStar}">⭐</c:when>
                                                    <c:otherwise>☆</c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </span>
                                    </div>
                                    <c:if test="${not empty review.reviewImage}">
                                        <div class="review-image">
                                            <img src="${review.reviewImage}" alt="리뷰 사진" onerror="this.parentElement.style.display='none'">
                                        </div>
                                    </c:if>
                                    <div class="review-content"><c:out value="${review.reviewContent}"/></div>
                                    <c:if test="${not empty review.reviewResponse}">
                                        <div class="review-response">사장님 답글: <c:out value="${review.reviewResponse}"/></div>
                                    </c:if>
                                    <div class="review-actions">
                                        <span>👍</span> <span>👎</span>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 외부 JavaScript 파일 -->
    <script src="${pageContext.request.contextPath}/js/storedetail.js"></script>
</body>
</html>
