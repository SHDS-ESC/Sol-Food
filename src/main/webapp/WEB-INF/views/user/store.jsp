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
    <!-- 카카오맵 API -->
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8f9034d6cf1da650e02b54751e02fcb3&libraries=services"></script>

    <style>
        body {
            margin: 0;
            background-color: #f5d6db; /* 연분홍 배경 */
            font-family: 'Apple SD Gothic Neo', sans-serif;
        }

        .app-container {
            max-width: 430px;
            margin: 0 auto;
            background: #fff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            position: relative;
            padding-bottom: 80px; /* 하단 바 공간 */
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #ddd;
        }

        .toggle-btns {
            display: flex;
            gap: 5px;
        }

        .search-bar {
            padding: 0 15px;
            margin-top: 10px;
            display: flex;
            gap: 5px;
        }

        .category-scroll {
            overflow-x: auto;
            white-space: nowrap;
            padding: 10px 15px;
            -webkit-overflow-scrolling: touch;
            scrollbar-width: none; /* Firefox */
            -ms-overflow-style: none; /* IE and Edge */
        }
        
        .category-scroll::-webkit-scrollbar {
            display: none; /* Chrome, Safari and Opera */
        }

        .category-btn {
            border-radius: 20px;
            padding: 6px 14px;
            font-size: 13px;
            display: inline-block;
            margin-right: 8px;
            white-space: nowrap;
            cursor: pointer;
        }

        .category-btn.active {
            background-color: #0d6efd !important;
            color: white !important;
        }

        .store-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            padding: 10px 15px;
        }

        .store-card {
            border: 1px solid #ccc;
            border-radius: 10px;
            overflow: hidden;
            background: #fff;
        }

        .store-img {
            width: 100%;
            height: 120px;
            background-color: #eee;
            object-fit: cover;
        }

        .store-body {
            padding: 10px;
            font-size: 13px;
            position: relative;
        }

        .store-name {
            font-weight: bold;
            font-size: 14px;
        }

        .like-icon {
            position: absolute;
            top: 10px;
            right: 10px;
            color: #ff4d6d;
            font-size: 16px;
        }

        /* 지도 스타일 추가 */
        .map-container {
            width: 100%;
            height: calc(100vh - 200px);
            display: none;
            flex-direction: column;
        }

        .map-view {
            flex: 1;
        }

        .list-container {
            display: block;
        }

        .bottom-nav {
            position: fixed;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100%;
            max-width: 430px;
            background: #fff;
            border-top: 1px solid #ccc;
            display: flex;
            justify-content: space-around;
            padding: 10px 0;
            z-index: 1000;
        }

        .bottom-nav a {
            color: #555;
            text-decoration: none;
            font-size: 12px;
            text-align: center;
        }

        .bottom-nav i {
            font-size: 20px;
            display: block;
        }

        .btn-active {
            background-color: #0d6efd !important;
            color: white !important;
        }
        
        .loading {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .loading i {
            font-size: 30px;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* 커스텀 마커 스타일 */
        .custom-marker {
            background: #ff4d6d;
            color: white;
            padding: 4px 8px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
            border: 2px solid white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
    </style>
</head>
<body>

<div class="app-container">

    <!-- ✅ 상단 헤더 -->
    <div class="header">
        <div><strong>로고</strong></div>
        <div class="toggle-btns">
            <button id="mapBtn" class="btn btn-outline-secondary btn-sm" onclick="showMap()">지도</button>
            <button id="listBtn" class="btn btn-outline-secondary btn-sm btn-active" onclick="showList()">목록</button>
        </div>
        <div><i class="bi bi-list" style="font-size: 20px;"></i></div>
    </div>

    <!-- ✅ 검색바 -->
    <div class="search-bar">
        <input type="text" class="form-control" placeholder="검색어를 입력해주세요">
        <button class="btn btn-primary">검색</button>
    </div>

    <!-- ✅ 카테고리 버튼 (동적 로딩) -->
    <div class="category-scroll" id="categoryContainer">
        <!-- 카테고리 버튼들이 동적으로 생성됩니다 -->
    </div>

    <!-- ✅ 지도 컨테이너 -->
    <div id="mapContainer" class="map-container">
        <div id="map" class="map-view" style="width:100%;height:100%;"></div>
    </div>

    <!-- ✅ 식당 카드 리스트 -->
    <div id="listContainer" class="list-container">
                <div class="store-grid">
            <c:forEach items="${store}" var="store">
            <div class="store-card" data-category="${store.storeCategory}">
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
                    <i class="bi bi-heart like-icon"></i> <!-- 찜 기능 -->
                </div>
            </div>
            </c:forEach>
        </div>
    </div>
</div>

<!-- ✅ 하단바 -->
<div class="bottom-nav">
    <a href="#"><i class="bi bi-house"></i>홈</a>
    <a href="#"><i class="bi bi-list-check"></i>리스트</a>
    <a href="#"><i class="bi bi-calendar2-week"></i>캘린더</a>
    <a href="#"><i class="bi bi-heart-fill"></i>찜</a>
    <a href="#"><i class="bi bi-person-circle"></i>마이</a>
</div>

<script>
let map;
let currentPosition;
let placesService;
let markers = [];
let currentCategory = '전체';
let categoryConfig = null; // 카테고리 설정 저장

// 페이지 로드시 카테고리 설정 불러오기
document.addEventListener('DOMContentLoaded', function() {
    loadCategoryConfig();
});

// 카테고리 설정 로드
function loadCategoryConfig() {
    fetch('/solfood/user/api/category/config')
        .then(response => response.json())
        .then(data => {
            categoryConfig = data;
            generateCategoryButtons();
        })
        .catch(error => {
            console.error('카테고리 설정 로딩 실패:', error);
            // 실패시 기본 카테고리 사용
            generateDefaultCategories();
        });
}

// 카테고리 버튼 동적 생성
function generateCategoryButtons() {
    const container = document.getElementById('categoryContainer');
    container.innerHTML = '';
    
    if (categoryConfig && categoryConfig.categories) {
        categoryConfig.categories.forEach((category, index) => {
            const button = document.createElement('button');
            button.className = 'btn btn-outline-primary category-btn' + (index === 0 ? ' active' : '');
            button.onclick = () => searchByCategory(category);
            button.textContent = category;
            container.appendChild(button);
        });
    }
}

// 기본 카테고리 생성 (백업용)
function generateDefaultCategories() {
    const container = document.getElementById('categoryContainer');
    const defaultCategories = ['전체', '한식', '카페', '일식', '중식', '양식', '치킨', '피자', '패스트푸드', '분식', '베이커리'];
    
    container.innerHTML = '';
    defaultCategories.forEach((category, index) => {
        const button = document.createElement('button');
        button.className = 'btn btn-outline-primary category-btn' + (index === 0 ? ' active' : '');
        button.onclick = () => searchByCategory(category);
        button.textContent = category;
        container.appendChild(button);
    });
}

function showMap() {
    // 버튼 스타일 변경
    document.getElementById('mapBtn').classList.add('btn-active');
    document.getElementById('listBtn').classList.remove('btn-active');
    
    // 컨테이너 표시/숨김
    document.getElementById('mapContainer').style.display = 'flex';
    document.getElementById('listContainer').style.display = 'none';
    
    // 지도 초기화 (한번만)
    if (!map) {
        initializeMap();
    } else {
        // 지도 크기 재조정
        setTimeout(() => {
            map.relayout();
            if (currentPosition) {
                map.setCenter(currentPosition);
            }
        }, 100);
    }
}

function showList() {
    // 버튼 스타일 변경
    document.getElementById('listBtn').classList.add('btn-active');
    document.getElementById('mapBtn').classList.remove('btn-active');
    
    // 컨테이너 표시/숨김
    document.getElementById('listContainer').style.display = 'block';
    document.getElementById('mapContainer').style.display = 'none';
}

function initializeMap() {
    // 현재 위치 가져오기
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            function(position) {
                const lat = position.coords.latitude;
                const lng = position.coords.longitude;
                currentPosition = new kakao.maps.LatLng(lat, lng);
                
                createMap(currentPosition);
            },
            function(error) {
                console.error('위치 정보를 가져올 수 없습니다:', error);
                // 기본 위치 (서울시청)
                const defaultPosition = new kakao.maps.LatLng(37.566826, 126.9786567);
                currentPosition = defaultPosition;
                createMap(defaultPosition);
            }
        );
    } else {
        alert('이 브라우저에서는 위치 서비스를 지원하지 않습니다.');
        // 기본 위치 (서울시청)
        const defaultPosition = new kakao.maps.LatLng(37.566826, 126.9786567);
        currentPosition = defaultPosition;
        createMap(defaultPosition);
    }
}

function createMap(position) {
    const mapContainer = document.getElementById('map');
    const mapOption = {
        center: position, // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };

    // 지도 생성
    map = new kakao.maps.Map(mapContainer, mapOption);
    
    // Places 서비스 객체 생성
    placesService = new kakao.maps.services.Places();

    // 현재 위치 마커 생성
    const myLocationMarker = new kakao.maps.Marker({
        position: position,
        map: map
    });

    // 인포윈도우로 현재 위치 표시
    const infowindow = new kakao.maps.InfoWindow({
        content: '<div style="padding:5px;font-size:12px;color:#0066cc;font-weight:bold;">📍 내 위치</div>'
    });
    infowindow.open(map, myLocationMarker);

    // 지도 크기 재조정 (지도가 표시될 때 호출)
    setTimeout(() => {
        map.relayout();
        map.setCenter(position);
        // 초기 전체 카테고리 검색
        searchByCategory('전체');
    }, 100);
}

// 카테고리별 검색
function searchByCategory(category) {
    // 카테고리 버튼 활성화 상태 변경
    document.querySelectorAll('.category-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    event.target.classList.add('active');
    
    currentCategory = category;
    
    // 목록 화면의 카테고리 필터링
    filterStoreList(category);
    
    // 지도가 활성화된 상태에서만 지도 검색
    if (map && placesService && currentPosition) {
        // 기존 마커들 제거
        clearMarkers();
        
        // CategoryProperties에서 검색 키워드 가져오기
        let keyword = '';
        if (categoryConfig && categoryConfig.searchKeywords) {
            keyword = categoryConfig.searchKeywords[category] || category;
        } else {
            keyword = category; // 백업용
        }
        
        // 키워드 검색 옵션
        const options = {
            location: currentPosition,
            radius: 1000, // 1km 반경
            sort: kakao.maps.services.SortBy.DISTANCE
        };
        
        // 키워드로 장소 검색
        placesService.keywordSearch(keyword, placesSearchCB, options);
    }
}

// 목록 화면 카테고리 필터링 함수 (Ajax 사용)
function filterStoreList(category) {
    // 로딩 표시
    showLoading();
    
    // Ajax로 카테고리별 데이터 가져오기
    fetch('/solfood/user/api/store/category/' + encodeURIComponent(category))
        .then(response => response.json())
        .then(data => {
            updateStoreGrid(data);
        })
        .catch(error => {
            console.error('카테고리 데이터 로딩 실패:', error);
            // 실패시 기존 방식으로 필터링
            fallbackFilterStoreList(category);
        });
}

// 로딩 표시 함수
function showLoading() {
    const storeGrid = document.querySelector('.store-grid');
    storeGrid.innerHTML = '<div class="loading"><i class="bi bi-arrow-clockwise"></i><br>불러오는 중...</div>';
}

// 기존 방식 필터링 (백업용)
function fallbackFilterStoreList(category) {
    const storeCards = document.querySelectorAll('.store-card');
    
    storeCards.forEach(card => {
        const storeCategory = card.querySelector('.store-category');
        if (storeCategory) {
            const storeCategoryText = storeCategory.textContent.trim();
            
            if (category === '전체') {
                card.style.display = 'block';
            } else {
                if (isCategoryMatch(storeCategoryText, category)) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            }
        }
    });
}

// 가게 목록 업데이트 함수
function updateStoreGrid(stores) {
    const storeGrid = document.querySelector('.store-grid');
    storeGrid.innerHTML = '';
    
    stores.forEach(store => {
        const storeCard = createStoreCard(store);
        storeGrid.appendChild(storeCard);
    });
}

// 가게 카드 생성 함수
function createStoreCard(store) {
    const card = document.createElement('div');
    card.className = 'store-card';
    card.setAttribute('data-category', store.storeCategory);
    
    let imageHtml = '';
    if (!store.storeMainimage || store.storeMainimage === '/img/default-restaurant.jpg') {
        imageHtml = '<div class="store-img" style="background-color: #f8f9fa; display: flex; align-items: center; justify-content: center; color: #6c757d;"><i class="bi bi-shop" style="font-size: 40px;"></i></div>';
    } else {
        imageHtml = '<img src="' + store.storeMainimage + '" alt="' + store.storeName + '" class="store-img" onerror="this.style.display=\'none\'; this.nextElementSibling.style.display=\'flex\';"><div class="store-img" style="background-color: #f8f9fa; display: none; align-items: center; justify-content: center; color: #6c757d;"><i class="bi bi-shop" style="font-size: 40px;"></i></div>';
    }
    
    let addressHtml = '';
    if (store.storeAddress && store.storeAddress.trim() !== '') {
        const shortAddress = store.storeAddress.length > 15 ? store.storeAddress.substring(0, 15) + '...' : store.storeAddress;
        addressHtml = '<div style="font-size: 11px; color: #666; margin-bottom: 3px;">📍 ' + shortAddress + '</div>';
    }
    
    let starHtml = '';
    if (store.storeAvgstar > 0) {
        starHtml = '⭐ ' + store.storeAvgstar + '점';
    } else {
        starHtml = '⭐ 신규매장';
    }
    
    let phoneHtml = '';
    if (store.storeTel && store.storeTel !== '정보없음') {
        phoneHtml = '<div style="font-size: 10px; color: #28a745; margin-top: 2px;">📞 ' + store.storeTel + '</div>';
    }
    
    card.innerHTML = imageHtml + 
        '<div class="store-body">' +
        '<div class="store-name">' + store.storeName + '</div>' +
        '<div class="store-category">' + store.storeCategory + '</div>' +
        addressHtml +
        '<div style="font-size: 12px;">' + starHtml + '</div>' +
        phoneHtml +
        '<i class="bi bi-heart like-icon"></i>' +
        '</div>';
    
    return card;
}

// 카테고리 매칭 함수 (CategoryProperties 사용)
function isCategoryMatch(storeCategory, selectedCategory) {
    if (selectedCategory === '전체') {
        return true;
    }
    
    // CategoryProperties에서 매칭 키워드 가져오기
    if (categoryConfig && categoryConfig.matchingKeywords) {
        const matchingKeywords = categoryConfig.matchingKeywords[selectedCategory];
        if (matchingKeywords) {
            const storeCat = storeCategory.toLowerCase();
            return matchingKeywords.some(keyword => 
                storeCat.includes(keyword.toLowerCase())
            );
        }
    }
    
    // 백업용: 기본 매칭
    return storeCategory.toLowerCase().includes(selectedCategory.toLowerCase());
}

// 검색 결과 콜백 함수
function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {
        // 검색된 장소들을 지도에 마커로 표시
        for (let i = 0; i < data.length; i++) {
            displayMarker(data[i]);
        }
    } else if (status === kakao.maps.services.Status.ZERO_RESULT) {
        console.log('검색 결과가 없습니다.');
    } else if (status === kakao.maps.services.Status.ERROR) {
        console.log('검색 중 오류가 발생했습니다.');
    }
}

// 마커 표시 함수
function displayMarker(place) {
    const marker = new kakao.maps.Marker({
        map: map,
        position: new kakao.maps.LatLng(place.y, place.x)
    });
    
    markers.push(marker);
    
    // 마커에 클릭 이벤트 등록
    kakao.maps.event.addListener(marker, 'click', function() {
        // 인포윈도우 내용
        let content = '<div style="padding:10px;min-width:150px;">';
        content += '<div style="font-weight:bold;margin-bottom:5px;">' + place.place_name + '</div>';
        content += '<div style="font-size:12px;color:#666;margin-bottom:3px;">' + place.category_name + '</div>';
        content += '<div style="font-size:12px;color:#666;">' + (place.road_address_name || place.address_name) + '</div>';
        if (place.phone) {
            content += '<div style="font-size:12px;color:#0066cc;margin-top:5px;">' + place.phone + '</div>';
        }
        content += '</div>';
        
        const infowindow = new kakao.maps.InfoWindow({
            content: content
        });
        
        infowindow.open(map, marker);
    });
}

// 기존 마커들 제거
function clearMarkers() {
    for (let i = 0; i < markers.length; i++) {
        markers[i].setMap(null);
    }
    markers = [];
}
</script>

</body>
</html>
