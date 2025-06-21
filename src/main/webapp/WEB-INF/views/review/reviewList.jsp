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
    <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services"></script>
    <script>
        // 카카오맵 SDK 로딩 상태 확인
        let kakaoMapLoaded = false;
        let kakaoMapLoading = false;
        
        // 카카오맵 SDK 로딩 확인
        function checkKakaoMapSDK() {
            return typeof kakao !== 'undefined' && kakao.maps && kakao.maps.LatLng;
        }
        
        // 카카오맵 SDK 대기
        function waitForKakaoMapSDK(callback, maxAttempts = 50) {
            let attempts = 0;
            
            function check() {
                attempts++;
                if (checkKakaoMapSDK()) {
                    console.log('카카오맵 SDK 준비 완료!');
                    kakaoMapLoaded = true;
                    callback();
                } else if (attempts < maxAttempts) {
                    setTimeout(check, 100);
                } else {
                    console.log('카카오맵 SDK 로딩 시간 초과');
                    callback(false);
                }
            }
            
            check();
        }
        
        // API 키 확인
        function checkApiKey() {
            const apiKey = '${kakaoJsKey}';
            if (!apiKey || apiKey.trim() === '') {
                console.error('카카오맵 API 키가 설정되지 않았습니다.');
                return false;
            }
            return true;
        }
    </script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Arial', sans-serif;
            background: #f5f5f5;
            height: 100vh;
            overflow: hidden;
        }
        
        .container {
            height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .fixed-header {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
            background: #fff;
        }
        
        .summary {
            background: #fff;
            padding: 24px 16px 12px 16px;
            border-bottom: 1px solid #eee;
        }
        .summary .score {
            font-size: 2.5em;
            font-weight: bold;
            color: #333;
            margin-bottom: 4px;
        }
        .summary .stars {
            color: #ffc107;
            font-size: 1.2em;
        }
        .summary .count {
            color: #888;
            font-size: 0.95em;
            margin-bottom: 10px;
        }
        .summary .bar-group {
            margin: 8px 0 0 0;
        }
        .summary .bar {
            display: flex;
            align-items: center;
            margin-bottom: 2px;
        }
        .summary .bar-label {
            width: 18px;
            font-size: 0.9em;
            color: #888;
        }
        .summary .bar-bg {
            background: #eee;
            border-radius: 4px;
            flex: 1;
            height: 8px;
            margin: 0 6px;
            overflow: hidden;
        }
        .summary .bar-fill {
            background: #ffc107;
            height: 100%;
        }
        .summary .bar-percent {
            width: 32px;
            font-size: 0.9em;
            color: #888;
            text-align: right;
        }
        
        /* 대표 메뉴 이미지 */
        .featured-menu {
            background: #fff;
            padding: 0;
            border-bottom: 1px solid #eee;
        }
        
        .menu-hero {
            position: relative;
            height: 150px;
            overflow: hidden;
        }
        
        .menu-hero-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .menu-hero-overlay {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.7));
            color: white;
            padding: 24px 16px 16px 16px;
        }
        
        .menu-hero-overlay h2 {
            font-size: 1.5em;
            margin-bottom: 4px;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
        }
        
        .menu-hero-overlay p {
            font-size: 1em;
            opacity: 0.9;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
        }
        
        .tabs {
            display: flex;
            background: #fff;
            border-bottom: 1px solid #eee;
        }
        .tab {
            flex: 1;
            text-align: center;
            padding: 12px 0;
            font-weight: bold;
            color: #333;
            border-bottom: 2px solid transparent;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .tab.active {
            color: #222;
            border-bottom: 2px solid #222;
        }
        .tab:hover {
            background: #f8f9fa;
        }
        
        .scrollable-content {
            flex: 1;
            overflow-y: auto;
            padding-top: 200px;
            background: #f5f5f5;
            transition: padding-top 0.3s ease;
        }
        
        .scrollable-content.review-mode {
            padding-top: 260px;
        }
        
        .content-section {
            display: none;
            padding: 0 0 60px 0;
        }
        
        .content-section.active {
            display: block;
        }
        
        /* 메뉴 섹션 */
        .menu-list {
            padding: 30px 20px 60px 20px;
        }
        
        .menu-item {
            background: #fff;
            margin: 16px 12px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            padding: 18px 16px;
            display: flex;
            align-items: center;
            gap: 16px;
        }
        
        .menu-image {
            width: 60px;
            height: 60px;
            border-radius: 8px;
            object-fit: cover;
            flex-shrink: 0;
        }
        
        .menu-info {
            flex: 1;
        }
        
        .menu-info h3 {
            color: #333;
            margin-bottom: 8px;
            font-size: 1.2em;
        }
        
        .menu-price {
            color: #ff6b35;
            font-weight: bold;
            font-size: 1.1em;
        }
        
        /* 지도 섹션 */
        .map-container {
            height: calc(100vh - 200px);
            width: 100%;
            position: relative;
        }
        
        #map {
            width: 100%;
            height: 100%;
        }
        
        .store-info {
            position: absolute;
            top: 20px;
            left: 20px;
            background: white;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            z-index: 1000;
            max-width: 300px;
        }
        
        .store-info h3 {
            color: #333;
            margin-bottom: 8px;
            font-size: 1.1em;
        }
        
        .store-info p {
            color: #666;
            margin: 4px 0;
            font-size: 0.9em;
        }
        
        /* 리뷰 섹션 */
        .review-list {
            padding: 30px 0 60px 0;
        }
        
        .review-card {
            background: #fff;
            margin: 16px 12px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            padding: 18px 16px 12px 16px;
            display: flex;
            flex-direction: column;
            gap: 10px;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        
        .review-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        
        .review-header {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 1em;
        }
        .review-header .username {
            font-weight: bold;
            color: #333;
        }
        .review-header .stars {
            color: #ffc107;
            font-size: 1.1em;
        }
        .review-image {
            width: 100%;
            max-width: 320px;
            margin: 0 auto;
            border-radius: 8px;
            overflow: hidden;
            background: #eee;
            text-align: center;
        }
        .review-image img {
            width: 100%;
            max-width: 320px;
            display: block;
        }
        .review-content {
            color: #444;
            font-size: 1.05em;
            margin: 8px 0;
            line-height: 1.6;
        }
        .review-menu {
            background: #eaf1ff;
            color: #2257c6;
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.95em;
            margin-bottom: 4px;
        }
        .review-actions {
            display: flex;
            gap: 16px;
            color: #888;
            font-size: 1.1em;
            margin-top: 6px;
        }
        .review-actions span {
            cursor: pointer;
            transition: color 0.2s ease;
        }
        .review-actions span:hover {
            color: #333;
        }
        .review-response {
            background: #f8f9fa;
            color: #007bff;
            border-left: 3px solid #007bff;
            padding: 8px 12px;
            border-radius: 6px;
            margin-top: 6px;
            font-size: 0.98em;
        }
        
        .no-reviews {
            padding: 40px 20px;
            text-align: center;
            color: #888;
            font-size: 1.1em;
        }
        
        /* 카테고리 필터 */
        .category-filter {
            padding: 20px 16px 10px;
            background: #fff;
            border-bottom: 1px solid #eee;
        }
        
        .category-tabs {
            display: flex;
            overflow-x: auto;
            gap: 8px;
            padding-bottom: 10px;
        }
        
        .category-tab {
            background: #f8f9fa;
            color: #666;
            border: none;
            padding: 8px 16px;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s ease;
            white-space: nowrap;
            font-size: 0.9em;
            min-width: fit-content;
        }
        
        .category-tab.active {
            background: #007bff;
            color: white;
        }
        
        .category-tab:hover {
            background: #e9ecef;
        }
        
        .category-tab.active:hover {
            background: #0056b3;
        }
        
        .menu-item.hidden {
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 고정 헤더 -->
        <div class="fixed-header">
            <!-- 상단 평점 요약 (리뷰 탭에서만 표시) -->
            <div class="summary" id="rating-summary" style="display: none;">
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
            <div class="featured-menu" id="featured-menu" style="display: block;">
                <div class="menu-hero">
                    <img src="<c:out value='${store.storeMainimage}' default='https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400&h=200&fit=crop'/>" alt="대표 메뉴" class="menu-hero-image">
                    <div class="menu-hero-overlay">
                        <h2>🍽️ <c:out value="${store.storeName}" default="맛있는 한식당"/></h2>
                        <p><c:out value="${store.storeIntro}" default="오늘의 추천 메뉴: 불고기 정식"/></p>
                    </div>
                </div>
            </div>
            
            <!-- 탭 메뉴 -->
            <div class="tabs">
                <div class="tab active" data-tab="menu">메뉴</div>
                <div class="tab" data-tab="map">지도</div>
                <div class="tab" data-tab="review">리뷰</div>
            </div>
        </div>
        
        <!-- 스크롤 가능한 콘텐츠 -->
        <div class="scrollable-content">
            <!-- 메뉴 섹션 -->
            <div class="content-section active" id="menu-section">
                <c:if test="${not empty menuList}">
                    <!-- 카테고리 필터 -->
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
                <div class="map-container">
                    <div id="map">
                        <div style="width:100%; height:100%; background:#f0f0f0; display:flex; align-items:center; justify-content:center; flex-direction:column;">
                            <div style="background:white; padding:20px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.1); text-align:center; max-width:300px;">
                                <h3 style="margin-bottom:15px; color:#333;">📍 가게 위치</h3>
                                <p style="margin:5px 0; color:#666;"><c:out value="${store.storeAddress}" default="서울특별시 강남구 테헤란로 123"/></p>
                                <p style="margin:5px 0; color:#666;">위도: <c:out value="${store.storeLatitude}" default="37.496299"/></p>
                                <p style="margin:5px 0; color:#666;">경도: <c:out value="${store.storeLongitude}" default="126.958500"/></p>
                                <div style="margin-top:15px;">
                                    <button onclick="loadKakaoMap()" style="background:#fee500; color:#000; border:none; padding:8px 16px; border-radius:5px; margin-right:10px; cursor:pointer; font-weight:bold;">카카오맵 재시도</button>
                                    <button onclick="showNaverMap()" style="background:#03c75a; color:white; border:none; padding:8px 16px; border-radius:5px; margin-right:10px; cursor:pointer;">네이버 지도</button>
                                    <button onclick="showGoogleMap()" style="background:#4285f4; color:white; border:none; padding:8px 16px; border-radius:5px; cursor:pointer;">Google 지도</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="store-info">
                        <h3>🍽️ <c:out value="${store.storeName}" default="맛있는 한식당"/></h3>
                        <p>📍 <c:out value="${store.storeAddress}" default="서울특별시 강남구 테헤란로 123"/></p>
                        <p>📞 <c:out value="${store.storeTel}" default="02-1234-5678"/></p>
                        <p>👥 최대 수용인원: <c:out value="${store.storeCapacity}" default="30"/>명</p>
                    </div>
                </div>
            </div>
            
            <!-- 리뷰 섹션 -->
            <div class="content-section" id="review-section">
                <div class="review-list">
                    <c:choose>
                        <c:when test="${empty reviewList}">
                            <div class="no-reviews">아직 등록된 리뷰가 없습니다.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="review" items="${reviewList}">
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
                                            <img src="${review.reviewImage}" alt="리뷰 사진" onerror="this.style.display='none'">
                                        </div>
                                    </c:if>
                                    <div class="review-content"><c:out value="${review.reviewContent}"/></div>
                                    <div class="review-menu">주문한 메뉴: <span><c:out value="${review.reviewStatus}"/></span></div>
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
    
    <script>
        // 카카오맵 초기화
        function initMap() {
            try {
                var container = document.getElementById('map');
                
                // 기존 내용 제거
                container.innerHTML = '';
                
                // 가게 좌표 정보 (JSP에서 전달)
                var storeLatitude = parseFloat('${store.storeLatitude}') || 37.496299;
                var storeLongitude = parseFloat('${store.storeLongitude}') || 126.958500;
                var storeName = '${store.storeName}' || '맛있는 한식당';
                
                var options = {
                    center: new kakao.maps.LatLng(storeLatitude, storeLongitude),
                    level: 3
                };
                
                var map = new kakao.maps.Map(container, options);
                
                // 마커 추가
                var markerPosition = new kakao.maps.LatLng(storeLatitude, storeLongitude);
                var marker = new kakao.maps.Marker({
                    position: markerPosition
                });
                marker.setMap(map);
                
                // 인포윈도우 추가
                var infowindow = new kakao.maps.InfoWindow({
                    content: '<div style="padding:5px;font-size:12px;">🍽️ ' + storeName + '</div>'
                });
                infowindow.open(map, marker);
                
                console.log('카카오맵 초기화 성공!');
                
            } catch (error) {
                console.error('카카오맵 초기화 실패:', error);
                showStaticMap();
            }
        }
        
        // Google Maps Embed API로 대체 지도 표시
        function showFallbackMap() {
            var container = document.getElementById('map');
            container.innerHTML = '<iframe width="100%" height="100%" frameborder="0" style="border:0" src="https://www.google.com/maps/embed/v1/place?key=AIzaSyB41DRUbKWJHPxaFjMAwdrzWzbVKartNGg&q=37.496299,126.958500&zoom=15" allowfullscreen></iframe>';
        }
        
        // 네이버 지도로 대체
        function showNaverMap() {
            var container = document.getElementById('map');
            var storeLatitude = parseFloat('${store.storeLatitude}') || 37.496299;
            var storeLongitude = parseFloat('${store.storeLongitude}') || 126.958500;
            container.innerHTML = '<iframe width="100%" height="100%" frameborder="0" style="border:0" src="https://map.naver.com/v5/entry/place/' + storeLatitude + ',' + storeLongitude + '?c=' + storeLongitude + ',' + storeLatitude + ',15,0,0,0,dh" allowfullscreen></iframe>';
        }
        
        // 정적 지도 이미지로 대체
        function showStaticMap() {
            var container = document.getElementById('map');
            var storeLatitude = parseFloat('${store.storeLatitude}') || 37.496299;
            var storeLongitude = parseFloat('${store.storeLongitude}') || 126.958500;
            var storeAddress = '${store.storeAddress}' || '서울특별시 강남구 테헤란로 123';
            
            container.innerHTML = `
                <div style="width:100%; height:100%; background:#f0f0f0; display:flex; align-items:center; justify-content:center; flex-direction:column;">
                    <div style="background:white; padding:20px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.1); text-align:center; max-width:300px;">
                        <h3 style="margin-bottom:15px; color:#333;">📍 가게 위치</h3>
                        <p style="margin:5px 0; color:#666;">` + storeAddress + `</p>
                        <p style="margin:5px 0; color:#666;">위도: ` + storeLatitude + `</p>
                        <p style="margin:5px 0; color:#666;">경도: ` + storeLongitude + `</p>
                        <div style="margin-top:15px;">
                            <button onclick="loadKakaoMap()" style="background:#fee500; color:#000; border:none; padding:8px 16px; border-radius:5px; margin-right:10px; cursor:pointer; font-weight:bold;">카카오맵 재시도</button>
                            <button onclick="showNaverMap()" style="background:#03c75a; color:white; border:none; padding:8px 16px; border-radius:5px; margin-right:10px; cursor:pointer;">네이버 지도</button>
                            <button onclick="showGoogleMap()" style="background:#4285f4; color:white; border:none; padding:8px 16px; border-radius:5px; cursor:pointer;">Google 지도</button>
                        </div>
                    </div>
                </div>
            `;
        }
        
        // Google Maps 직접 링크
        function showGoogleMap() {
            var container = document.getElementById('map');
            var storeLatitude = parseFloat('${store.storeLatitude}') || 37.496299;
            var storeLongitude = parseFloat('${store.storeLongitude}') || 126.958500;
            
            container.innerHTML = `
                <div style="width:100%; height:100%; background:#f0f0f0; display:flex; align-items:center; justify-content:center; flex-direction:column;">
                    <div style="background:white; padding:20px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.1); text-align:center; max-width:300px;">
                        <h3 style="margin-bottom:15px; color:#333;">🗺️ 지도 보기</h3>
                        <p style="margin:10px 0; color:#666;">아래 버튼을 클릭하여 지도를 확인하세요</p>
                        <div style="margin-top:15px;">
                            <a href="https://www.google.com/maps?q=` + storeLatitude + `,` + storeLongitude + `" target="_blank" style="background:#4285f4; color:white; text-decoration:none; padding:10px 20px; border-radius:5px; margin-right:10px; display:inline-block;">Google Maps 열기</a>
                            <a href="https://map.naver.com/v5/entry/place/` + storeLatitude + `,` + storeLongitude + `" target="_blank" style="background:#03c75a; color:white; text-decoration:none; padding:10px 20px; border-radius:5px; display:inline-block;">네이버 지도 열기</a>
                        </div>
                    </div>
                </div>
            `;
        }
        
        // 카카오맵 SDK 로딩 확인 및 초기화
        function loadKakaoMap() {
            if (!checkApiKey()) {
                console.log('API 키가 없어 정적 지도로 대체합니다');
                showStaticMap();
                return;
            }
            
            if (kakaoMapLoading) {
                console.log('카카오맵 이미 로딩 중...');
                return;
            }
            
            if (kakaoMapLoaded && checkKakaoMapSDK()) {
                console.log('카카오맵 SDK 이미 완전히 로딩됨');
                initMap();
            } else {
                console.log('카카오맵 SDK 로딩 시도...');
                kakaoMapLoading = true;
                
                waitForKakaoMapSDK((success) => {
                    kakaoMapLoading = false;
                    if (success) {
                        console.log('카카오맵 SDK 완전히 준비됨');
                        initMap();
                    } else {
                        console.log('카카오맵 로딩 실패, 정적 지도로 대체합니다');
                        showStaticMap();
                    }
                });
            }
        }
        
        // 카테고리 필터링 기능
        function initializeCategoryFilter() {
            const categoryTabs = document.querySelectorAll('.category-tab');
            const menuItems = document.querySelectorAll('.menu-item');
            
            categoryTabs.forEach(tab => {
                tab.addEventListener('click', function() {
                    const selectedCategory = this.getAttribute('data-category');
                    
                    // 모든 탭에서 active 클래스 제거
                    categoryTabs.forEach(t => t.classList.remove('active'));
                    // 클릭된 탭에 active 클래스 추가
                    this.classList.add('active');
                    
                    // 메뉴 아이템 필터링
                    menuItems.forEach(item => {
                        const itemCategory = item.getAttribute('data-category');
                        
                        if (selectedCategory === '전체' || itemCategory === selectedCategory) {
                            item.classList.remove('hidden');
                        } else {
                            item.classList.add('hidden');
                        }
                    });
                });
            });
        }
        
        // 페이지 로드 시 카카오맵 초기화
        window.addEventListener('load', function() {
            console.log('페이지 로드 완료, 카카오맵 초기화 시도...');
            setTimeout(loadKakaoMap, 1500);
            
            // 별점 바 차트 초기화
            initializeStarBars();
            
            // 카테고리 필터 초기화
            initializeCategoryFilter();
        });
        
        // 별점 바 차트 초기화 함수
        function initializeStarBars() {
            const barFills = document.querySelectorAll('.bar-fill');
            barFills.forEach(barFill => {
                const percentage = barFill.getAttribute('data-percentage');
                if (percentage) {
                    barFill.style.width = percentage + '%';
                }
            });
        }
        
        // 탭 클릭 이벤트
        document.querySelectorAll('.tab').forEach(tab => {
            tab.addEventListener('click', function() {
                const tabName = this.getAttribute('data-tab');
                
                // 모든 탭에서 active 클래스 제거
                document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
                // 클릭된 탭에 active 클래스 추가
                this.classList.add('active');
                
                // 모든 섹션 숨기기
                document.querySelectorAll('.content-section').forEach(section => {
                    section.classList.remove('active');
                });
                
                // 해당 섹션 보이기
                document.getElementById(tabName + '-section').classList.add('active');
                
                // 헤더 영역 변경
                const ratingSection = document.getElementById('rating-summary');
                const menuSection = document.getElementById('featured-menu');
                const scrollableContent = document.querySelector('.scrollable-content');
                
                if (tabName === 'review') {
                    // 리뷰 탭: 평점 요약 표시, 메뉴 이미지 숨김
                    ratingSection.style.display = 'block';
                    menuSection.style.display = 'none';
                    scrollableContent.classList.add('review-mode');
                    initializeStarBars(); // 별점 바 다시 초기화
                } else {
                    // 메뉴/지도 탭: 메뉴 이미지 표시, 평점 요약 숨김
                    ratingSection.style.display = 'none';
                    menuSection.style.display = 'block';
                    scrollableContent.classList.remove('review-mode');
                }
                
                // 지도 탭이 활성화되면 카카오맵 다시 초기화
                if (tabName === 'map') {
                    setTimeout(loadKakaoMap, 100);
                }
            });
        });
        
        // 스크롤 시 헤더 그림자 효과
        const scrollableContent = document.querySelector('.scrollable-content');
        const fixedHeader = document.querySelector('.fixed-header');
        
        scrollableContent.addEventListener('scroll', function() {
            if (this.scrollTop > 0) {
                fixedHeader.style.boxShadow = '0 2px 8px rgba(0,0,0,0.1)';
            } else {
                fixedHeader.style.boxShadow = 'none';
            }
        });
    </script>
</body>
</html>
