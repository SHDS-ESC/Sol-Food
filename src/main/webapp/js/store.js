// ==================== 전역 변수 ====================
let map;
let currentPosition;
let placesService;
let markers = [];
let currentCategory = '전체';
let categoryConfig = null;
let currentInfoWindow = null;
let isSearchMode = false;
let currentSearchKeyword = '';

// ==================== 초기화 ====================
document.addEventListener('DOMContentLoaded', function() {
    currentCategory = '전체';
    loadCategoryConfig();
    
    const listContainer = document.getElementById('listContainer');
    const listDisplay = window.getComputedStyle(listContainer).display;
    if (listDisplay === 'block' || listDisplay === '') {
        fallbackFilterStoreList('전체');
    }
});

function loadCategoryConfig() {
    fetch('/solfood/user/store/api/category/config')
        .then(response => response.json())
        .then(data => {
            categoryConfig = data.data || data;
        })
        .catch(error => {
            console.error('카테고리 설정 로딩 실패:', error);
        });
}

// ==================== 화면 전환 ====================
function showMap() {
    document.getElementById('mapBtn').classList.add('btn-active');
    document.getElementById('listBtn').classList.remove('btn-active');
    document.getElementById('mapContainer').style.display = 'flex';
    document.getElementById('listContainer').style.display = 'none';
    document.querySelector('.app-container').classList.add('map-view');

    if (!map) {
        initializeMap();
    } else {
        setTimeout(() => {
            map.relayout();
            if (currentPosition) {
                map.setCenter(currentPosition);
            }
        }, 100);
    }
}

function showList() {
    document.getElementById('listBtn').classList.add('btn-active');
    document.getElementById('mapBtn').classList.remove('btn-active');
    document.getElementById('listContainer').style.display = 'block';
    document.getElementById('mapContainer').style.display = 'none';
    document.querySelector('.app-container').classList.remove('map-view');
}

// ==================== 지도 초기화 ====================
function initializeMap() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(
            position => {
                const lat = position.coords.latitude;
                const lng = position.coords.longitude;
                currentPosition = new kakao.maps.LatLng(lat, lng);
                createMap(currentPosition);
            },
            error => {
                const defaultPosition = new kakao.maps.LatLng(37.566826, 126.9786567);
                currentPosition = defaultPosition;
                createMap(defaultPosition);
            }
        );
    } else {
        const defaultPosition = new kakao.maps.LatLng(37.566826, 126.9786567);
        currentPosition = defaultPosition;
        createMap(defaultPosition);
    }
}

function createMap(position) {
    const mapContainer = document.getElementById('map');
    const mapOption = {
        center: position,
        level: 3
    };

    map = new kakao.maps.Map(mapContainer, mapOption);
    placesService = new kakao.maps.services.Places();

    const myLocationMarker = new kakao.maps.Marker({
        position: position,
        map: map
    });

    const infowindow = new kakao.maps.InfoWindow({
        content: '<div style="padding:5px;font-size:12px;color:#0066cc;font-weight:bold;">📍 내 위치</div>'
    });
    infowindow.open(map, myLocationMarker);

    setTimeout(() => {
        map.relayout();
        map.setCenter(position);
        searchMapCategory('전체');
        
        document.querySelectorAll('.map-category-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        document.querySelector('.map-category-btn[onclick*="전체"]').classList.add('active');
    }, 100);
}

// ==================== 카테고리 선택 ====================
function selectCategory(element, category) {
    // 검색 모드인 경우 검색 해제
    if (isSearchMode) {
        // 검색창 초기화
        document.getElementById('searchInput').value = '';
        
        // 검색 헤더 제거
        const searchHeader = document.getElementById('searchHeader');
        if (searchHeader) {
            searchHeader.remove();
        }
        
        isSearchMode = false;
        currentSearchKeyword = '';
    }
    
    document.querySelectorAll('.category-item').forEach(item => {
        item.classList.remove('active');
    });
    element.classList.add('active');
    currentCategory = category;
    
    const extendedCategories = document.getElementById('extendedCategories');
    const isMoreOpen = extendedCategories && extendedCategories.style.display === 'grid';
    
    if (isMoreOpen) {
        setTimeout(() => {
            toggleMoreCategories();
        }, 300);
    }
    
    const mapContainer = document.getElementById('mapContainer');
    const listContainer = document.getElementById('listContainer');
    const mapDisplay = window.getComputedStyle(mapContainer).display;
    const listDisplay = window.getComputedStyle(listContainer).display;
    const isMapView = mapDisplay === 'flex';
    const isListView = listDisplay === 'block' || listDisplay === '';

    if (isListView) {
        fallbackFilterStoreList(category);
    }
    if (isMapView) {
        searchMapCategory(category);
    }
    if (!isMapView && !isListView) {
        fallbackFilterStoreList(category);
    }
}

function selectMapCategory(element, category) {
    document.querySelectorAll('.map-category-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    element.classList.add('active');
    currentCategory = category;
    
    if (map && placesService && currentPosition) {
        searchMapCategory(category);
    }
}

function toggleMoreCategories() {
    const extendedCategories = document.getElementById('extendedCategories');
    const moreText = document.getElementById('moreText');
    
    if (extendedCategories.style.display === 'grid') {
        extendedCategories.style.display = 'none';
        moreText.textContent = '더보기';
    } else {
        extendedCategories.style.display = 'grid';
        moreText.textContent = '접기';
    }
}

// ==================== 목록 필터링 ====================
function fallbackFilterStoreList(category) {
    const storeCards = document.querySelectorAll('.store-card');
    let filteredCount = 0;
    
    storeCards.forEach(card => {
        let storeCategoryText = card.getAttribute('data-category');
        
        if (!storeCategoryText) {
            const storeCategory = card.querySelector('.store-category');
            if (storeCategory) {
                storeCategoryText = storeCategory.textContent.trim();
            }
        }
        
        if (storeCategoryText) {
            if (category === '전체') {
                card.style.display = 'block';
                filteredCount++;
            } else {
                if (isCategoryMatch(storeCategoryText, category)) {
                    card.style.display = 'block';
                    filteredCount++;
                } else {
                    card.style.display = 'none';
                }
            }
        } else {
            card.style.display = 'block';
            filteredCount++;
        }
    });
}

function isCategoryMatch(storeCategory, selectedCategory) {
    if (selectedCategory === '전체') {
        return true;
    }

    const storeCat = storeCategory.toLowerCase();
    const selectedCat = selectedCategory.toLowerCase();
    
    if (storeCat.includes(selectedCat)) {
        return true;
    }
    
    if (categoryConfig && categoryConfig.matchingKeywords) {
        const keywords = categoryConfig.matchingKeywords[selectedCategory];
        if (keywords) {
            return keywords.some(keyword => 
                storeCat.includes(keyword.toLowerCase())
            );
        }
    }
    
    return false;
}

// ==================== 지도 검색 ====================
function searchMapCategory(category) {
    if (map && placesService && currentPosition) {
        clearMarkers();
        closeAllInfoWindows();

        let keyword = '';
        if (categoryConfig && categoryConfig.searchKeywords) {
            keyword = categoryConfig.searchKeywords[category] || category;
        } else {
            keyword = category;
        }

        const options = {
            location: currentPosition,
            radius: 1000,
            sort: kakao.maps.services.SortBy.DISTANCE
        };

        placesService.keywordSearch(keyword, placesSearchCB, options);
    }
}

function placesSearchCB(data, status, pagination) {
    if (status === kakao.maps.services.Status.OK) {
        for (let i = 0; i < data.length; i++) {
            displayMarker(data[i]);
        }
    }
}

function displayMarker(place) {
    const marker = new kakao.maps.Marker({
        map: map,
        position: new kakao.maps.LatLng(place.y, place.x)
    });

    markers.push(marker);

    kakao.maps.event.addListener(marker, 'click', function() {
        closeAllInfoWindows();
        
        const content = createDetailedInfoWindow(place);
        const infowindow = new kakao.maps.InfoWindow({
            content: content,
            removable: false
        });

        currentInfoWindow = infowindow;
        infowindow.open(map, marker);
    });
}

function createDetailedInfoWindow(place) {
    const categoryTag = extractCategoryTag(place.category_name);
    
    let content = '<div class="custom-infowindow">';
    content += '<div class="infowindow-header">';
    content += '<button class="infowindow-close" onclick="closeCurrentInfoWindow()">×</button>';
    content += '<h3 class="store-title">' + place.place_name + '</h3>';
    content += '<span class="store-category-tag">' + categoryTag + '</span>';
    content += '</div>';
    
    content += '<div class="infowindow-body">';
    content += '<div class="menu-image-container">';
    content += '<div class="no-image-placeholder">';
    content += '<i class="bi bi-image" style="font-size: 24px; color: #dee2e6;"></i><br>';
    content += '<span>대표 메뉴 이미지</span>';
    content += '</div>';
    content += '</div>';
    
    content += '<div class="store-info">';
    content += '<div class="store-info-item">';
    content += '<i class="bi bi-geo-alt store-info-icon"></i>';
    content += '<span>' + (place.road_address_name || place.address_name) + '</span>';
    content += '</div>';
    
    if (place.phone) {
        content += '<div class="store-info-item">';
        content += '<i class="bi bi-telephone store-info-icon"></i>';
        content += '<span>' + place.phone + '</span>';
        content += '</div>';
    }
    
    content += '<div class="store-info-item">';
    content += '<i class="bi bi-tag store-info-icon"></i>';
    content += '<span>' + place.category_name + '</span>';
    content += '</div>';
    
    if (place.distance) {
        content += '<div class="store-info-item">';
        content += '<i class="bi bi-map store-info-icon"></i>';
        content += '<span>약 ' + place.distance + 'm</span>';
        content += '</div>';
    }
    
    content += '</div>';
    content += '<div class="infowindow-buttons">';
    content += '<button class="info-btn btn-detail" onclick="goToStoreDetailFromMap(\'' + place.place_name + '\', \'' + place.id + '\')">';
    content += '<i class="bi bi-info-circle" style="margin-right: 4px;"></i>상세보기';
    content += '</button>';
    
    if (place.phone) {
        content += '<button class="info-btn btn-call" onclick="callStore(\'' + place.phone + '\')">';
        content += '<i class="bi bi-telephone" style="margin-right: 4px;"></i>전화';
        content += '</button>';
    }
    
    content += '</div>';
    content += '</div>';
    content += '</div>';
    
    return content;
}

// ==================== 유틸리티 함수 ====================
function clearMarkers() {
    for (let i = 0; i < markers.length; i++) {
        markers[i].setMap(null);
    }
    markers = [];
}

function closeAllInfoWindows() {
    if (currentInfoWindow) {
        currentInfoWindow.close();
        currentInfoWindow = null;
    }
}

function closeCurrentInfoWindow() {
    closeAllInfoWindows();
}

function extractCategoryTag(categoryName) {
    if (!categoryName) return '기타';
    
    const parts = categoryName.split(' > ');
    const lastPart = parts[parts.length - 1];
    
    if (lastPart.length > 15) {
        return lastPart.substring(0, 15) + '...';
    }
    
    return lastPart;
}

function goToStoreDetail(storeId) {
    window.location.href = '/solfood/user/store/detail/' + storeId;
}

function goToStoreDetailFromMap(placeName, placeId) {
    window.location.href = '/solfood/user/list?storeId=1';
}

function callStore(phoneNumber) {
    if (phoneNumber) {
        window.location.href = 'tel:' + phoneNumber;
    } else {
        alert('전화번호 정보가 없습니다.');
    }
}

// ==================== 검색 기능 ====================

/**
 * 검색 실행 함수
 */
function performSearch() {
    const searchInput = document.getElementById('searchInput');
    const keyword = searchInput.value.trim();
    
    if (!keyword) {
        alert('검색어를 입력해주세요.');
        searchInput.focus();
        return;
    }
    
    // 로딩 표시
    showLoading(true);
    
    // AJAX로 검색 요청
    fetch(`/solfood/user/store/search?keyword=${encodeURIComponent(keyword)}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                isSearchMode = true;
                currentSearchKeyword = keyword;
                displaySearchResults(data.stores || [], keyword);
                updateSearchUI(keyword);
            } else {
                console.error('검색 실패:', data.message);
                alert('검색 중 오류가 발생했습니다: ' + data.message);
            }
        })
        .catch(error => {
            console.error('검색 요청 실패:', error);
            alert('검색 요청 중 오류가 발생했습니다.');
        })
        .finally(() => {
            showLoading(false);
        });
}

/**
 * 가게 목록을 화면에 표시
 */
function displayStoreList(stores) {
    console.log('displayStoreList 호출됨:', stores); // 디버깅용 로그
    
    const storeGrid = document.querySelector('.store-grid');
    if (!storeGrid) {
        console.error('store-grid 요소를 찾을 수 없습니다.');
        return;
    }
    
    // 기존 가게 카드들 제거
    storeGrid.innerHTML = '';
    
    if (!stores || stores.length === 0) {
        console.log('가게 목록이 비어있음');
        storeGrid.innerHTML = `
            <div class="empty-result">
                <i class="bi bi-shop" style="font-size: 64px; color: #ddd; margin-bottom: 20px; display: block;"></i>
                <h3>가게가 없습니다</h3>
                <p>다른 카테고리를 선택해보세요.</p>
            </div>
        `;
        return;
    }
    
    console.log(`총 ${stores.length}개의 가게 데이터 처리 시작`);
    
    // 첫 번째 가게 데이터 구조 확인
    if (stores.length > 0) {
        console.log('첫 번째 가게 데이터 구조:', stores[0]);
        console.log('첫 번째 가게 데이터 키들:', Object.keys(stores[0]));
    }
    
    // 가게 카드들 생성
    stores.forEach((store, index) => {
        try {
            const storeCard = createStoreCardElement(store);
            if (storeCard && storeCard instanceof Node) {
                storeGrid.appendChild(storeCard);
            } else {
                console.error('createStoreCardElement가 유효한 Node를 반환하지 않음:', store, storeCard);
            }
        } catch (error) {
            console.error(`가게 카드 생성 실패 (index: ${index}):`, error, store);
        }
    });
}

/**
 * 개별 가게 카드 DOM 요소 생성
 */
function createStoreCardElement(store) {
    try {
        // 필수 데이터 검증
        if (!store) {
            console.error('store 데이터가 없습니다:', store);
            return null;
        }
        
        const cardDiv = document.createElement('div');
        if (!cardDiv) {
            console.error('div 엘리먼트 생성 실패');
            return null;
        }
        
        cardDiv.className = 'store-card';
        cardDiv.setAttribute('data-category', String(store.storeCategory || ''));
        
        // 안전한 클릭 이벤트 설정
        const storeId = store.storeId || store.store_id;
        if (storeId) {
            cardDiv.onclick = () => goToStoreDetail(storeId);
        }
        
        // 안전한 문자열 처리
        const safeName = String(store.storeName || store.store_name || '이름 없음');
        const safeCategory = String(store.storeCategory || store.store_category || '기타');
        const safeImage = store.storeMainimage || store.store_mainimage || '';
        const safeAddress = store.storeAddress || store.store_address || '';
        const safeTel = store.storeTel || store.store_tel || '';
        const safeRating = Number(store.storeAvgstar || store.store_avgstar || 0);
        
        // 이미지 부분
        let imageHtml = '';
        if (!safeImage || safeImage === '/img/default-restaurant.jpg') {
            imageHtml = `
                <div class="store-img" style="background-color: #f8f9fa; display: flex; align-items: center; justify-content: center; color: #6c757d;">
                    <i class="bi bi-shop" style="font-size: 40px;"></i>
                </div>
            `;
        } else {
            imageHtml = `
                <img src="${safeImage}" alt="${safeName}" class="store-img"
                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                <div class="store-img" style="background-color: #f8f9fa; display: none; align-items: center; justify-content: center; color: #6c757d;">
                    <i class="bi bi-shop" style="font-size: 40px;"></i>
                </div>
            `;
        }
        
        // 주소 표시 (15자 제한)
        let addressHtml = '';
        if (safeAddress) {
            const displayAddress = safeAddress.length > 15 
                ? safeAddress.substring(0, 15) + '...'
                : safeAddress;
            addressHtml = `
                <div style="font-size: 11px; color: #666; margin-bottom: 3px;">
                    📍 ${displayAddress}
                </div>
            `;
        }
        
        // 평점 표시
        const ratingText = safeRating > 0 
            ? `⭐ ${safeRating}점`
            : '⭐ 신규매장';
        
        // 전화번호 표시
        let phoneHtml = '';
        if (safeTel && safeTel !== '정보없음') {
            phoneHtml = `
                <div style="font-size: 10px; color: #28a745; margin-top: 2px;">
                    📞 ${safeTel}
                </div>
            `;
        }
        
        // innerHTML 안전하게 설정
        try {
            cardDiv.innerHTML = `
                ${imageHtml}
                <div class="store-body">
                    <div class="store-name">${safeName}</div>
                    <div class="store-category">${safeCategory}</div>
                    ${addressHtml}
                    <div style="font-size: 12px;">
                        ${ratingText}
                    </div>
                    ${phoneHtml}
                    <i class="bi bi-heart like-icon"></i>
                </div>
            `;
        } catch (htmlError) {
            console.error('innerHTML 설정 실패:', htmlError, store);
            return null;
        }
        
        return cardDiv;
        
    } catch (error) {
        console.error('createStoreCardElement 실행 중 오류:', error, store);
        return null;
    }
}

/**
 * 검색 결과를 화면에 표시
 */
function displaySearchResults(stores, keyword) {
    const storeGrid = document.querySelector('.store-grid');
    
    if (!stores || stores.length === 0) {
        storeGrid.innerHTML = `
            <div style="grid-column: 1/-1; text-align: center; padding: 40px; color: #666;">
                <i class="bi bi-search" style="font-size: 48px; margin-bottom: 16px; display: block;"></i>
                <h3 style="margin-bottom: 8px;">검색 결과가 없습니다</h3>
                <p>'${keyword}'에 대한 검색 결과를 찾을 수 없습니다.</p>
                <button onclick="clearSearch()" class="btn btn-outline-primary mt-3">전체 목록 보기</button>
            </div>
        `;
        return;
    }
    
    // 검색 결과로 가게 카드 생성 - DOM 요소 방식으로 통일
    storeGrid.innerHTML = '';
    stores.forEach((store, index) => {
        try {
            const storeCard = createStoreCardElement(store);
            if (storeCard && storeCard instanceof Node) {
                storeGrid.appendChild(storeCard);
            } else {
                console.error(`검색 결과 카드 생성 실패 (index: ${index}):`, store);
            }
        } catch (error) {
            console.error(`검색 결과 카드 생성 오류 (index: ${index}):`, error, store);
        }
    });
    
    console.log(`검색 완료: '${keyword}'로 ${stores.length}개 가게 발견`);
}

/**
 * 검색 UI 업데이트
 */
function updateSearchUI(keyword) {
    // 카테고리 선택 해제
    document.querySelectorAll('.category-item').forEach(item => {
        item.classList.remove('active');
    });
    
    // 검색 상태 표시를 위한 헤더 추가 (선택적)
    const categoryContainer = document.querySelector('.category-container');
    let searchHeader = document.getElementById('searchHeader');
    
    if (!searchHeader) {
        searchHeader = document.createElement('div');
        searchHeader.id = 'searchHeader';
        searchHeader.style.cssText = `
            background: #e3f2fd; 
            padding: 12px 16px; 
            margin-bottom: 16px; 
            border-radius: 8px; 
            border-left: 4px solid #2196f3;
            display: flex;
            justify-content: space-between;
            align-items: center;
        `;
        categoryContainer.insertBefore(searchHeader, categoryContainer.firstChild);
    }
    
    searchHeader.innerHTML = `
        <div>
            <i class="bi bi-search" style="color: #2196f3; margin-right: 8px;"></i>
            <strong>'${keyword}' 검색 결과</strong>
        </div>
        <button onclick="clearSearch()" class="btn btn-sm btn-outline-secondary">
            <i class="bi bi-x"></i> 검색 해제
        </button>
    `;
}

/**
 * 검색 해제 함수
 */
function clearSearch() {
    isSearchMode = false;
    currentSearchKeyword = '';
    
    // 검색창 초기화
    document.getElementById('searchInput').value = '';
    
    // 검색 헤더 제거
    const searchHeader = document.getElementById('searchHeader');
    if (searchHeader) {
        searchHeader.remove();
    }
    
    // '전체' 카테고리 element 찾기
    const allCategoryElement = document.querySelector('.category-item[onclick*="전체"]') || 
                               document.querySelector('.category-item[data-category="전체"]') ||
                               document.querySelector('.category-item:first-child');
    
    if (allCategoryElement) {
        selectCategory(allCategoryElement, '전체');
    } else {
        // fallback: 직접 전체 목록 로드
        loadAllStores();
    }
}

/**
 * 전체 가게 목록 직접 로드 (fallback 함수)
 */
function loadAllStores() {
    // 카테고리 선택 상태 초기화
    document.querySelectorAll('.category-item').forEach(item => {
        item.classList.remove('active');
    });
    
    // 첫 번째 카테고리 아이템 활성화 (보통 '전체')
    const firstCategory = document.querySelector('.category-item');
    if (firstCategory) {
        firstCategory.classList.add('active');
    }
    
    currentCategory = '전체';
    
    // 현재 보기 모드에 따라 적절한 로드 함수 호출
    const mapContainer = document.getElementById('mapContainer');
    const listContainer = document.getElementById('listContainer');
    const mapDisplay = window.getComputedStyle(mapContainer).display;
    const listDisplay = window.getComputedStyle(listContainer).display;
    const isMapView = mapDisplay === 'flex';
    const isListView = listDisplay === 'block' || listDisplay === '';

    if (isListView) {
        fallbackFilterStoreList('전체');
    } else if (isMapView) {
        searchMapCategory('전체');
    } else {
        // 기본적으로 리스트 뷰로 전환하고 전체 목록 표시
        fallbackFilterStoreList('전체');
    }
    
    console.log('전체 가게 목록을 다시 로드했습니다.');
}

/**
 * 리스트 뷰로 전환
 */
function showListView() {
    const mapContainer = document.getElementById('mapContainer');
    const listContainer = document.getElementById('listContainer');
    
    if (mapContainer && listContainer) {
        mapContainer.style.display = 'none';
        listContainer.style.display = 'block';
        
        // 버튼 상태 업데이트
        const mapBtn = document.getElementById('mapViewBtn');
        const listBtn = document.getElementById('listViewBtn');
        
        if (mapBtn && listBtn) {
            mapBtn.classList.remove('active');
            listBtn.classList.add('active');
        }
    }
}

/**
 * 맵 뷰로 전환
 */
function showMapView() {
    const mapContainer = document.getElementById('mapContainer');
    const listContainer = document.getElementById('listContainer');
    
    if (mapContainer && listContainer) {
        listContainer.style.display = 'none';
        mapContainer.style.display = 'flex';
        
        // 버튼 상태 업데이트
        const mapBtn = document.getElementById('mapViewBtn');
        const listBtn = document.getElementById('listViewBtn');
        
        if (mapBtn && listBtn) {
            listBtn.classList.remove('active');
            mapBtn.classList.add('active');
        }
    }
}

/**
 * 서버에서 전체 가게 목록을 다시 가져와서 표시하는 fallback 함수
 */
function fallbackFilterStoreList(category) {
    showLoading(true);
    
    const url = category === '전체' ? 
        '/solfood/user/store/stores' : 
        `/solfood/user/store/category?category=${encodeURIComponent(category)}`;
    
    fetch(url)
        .then(response => {
            if (!response.ok) {
                throw new Error('서버 응답 오류');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                // 리스트 컨테이너 표시
                showListView();
                displayStoreList(data.stores || []);
            } else {
                console.error('가게 목록 조회 실패:', data.message);
                alert('가게 목록을 불러오는데 실패했습니다.');
            }
        })
        .catch(error => {
            console.error('가게 목록 조회 오류:', error);
            alert('가게 목록을 불러오는데 오류가 발생했습니다.');
        })
        .finally(() => {
            showLoading(false);
        });
}

// 중복된 createStoreCard 함수 제거 - createStoreCardElement로 통일

/**
 * 로딩 표시 함수
 */
function showLoading(show) {
    let loadingElement = document.getElementById('searchLoading');
    
    if (show) {
        if (!loadingElement) {
            loadingElement = document.createElement('div');
            loadingElement.id = 'searchLoading';
            loadingElement.style.cssText = `
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: rgba(255, 255, 255, 0.9);
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                z-index: 9999;
                text-align: center;
            `;
            loadingElement.innerHTML = `
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">검색 중...</span>
                </div>
                <div style="margin-top: 10px; color: #666;">검색 중...</div>
            `;
            document.body.appendChild(loadingElement);
        }
        loadingElement.style.display = 'block';
    } else {
        if (loadingElement) {
            loadingElement.style.display = 'none';
        }
    }
}

/**
 * Enter 키로 검색 실행
 */
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                performSearch();
            }
        });
    }
}); 