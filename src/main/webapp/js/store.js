// ==================== 전역 변수 ====================
let map;
let currentPosition;
let placesService;
let markers = [];
let currentCategory = '전체';
let categoryConfig = null;
let currentInfoWindow = null;
let offset = 0;
const pageSize = 10;
let hasNext = true;
let loading = false;
let isSearchMode = false;
let currentSearchKeyword = '';
let currentSort = 'star';

// ==================== 초기화 ====================
document.addEventListener('DOMContentLoaded', function () {
    // DOM이 완전히 로드된 후 실행되도록 약간의 지연 추가
    setTimeout(() => {
        initializeStorePage();
    }, 100);
});

function initializeStorePage() {
    try {
        currentCategory = '전체';
        loadCategoryConfig();

        // 초기 로딩 시 페이징 방식으로 통일
        offset = 0;
        hasNext = true;
        loading = false;
        
        // storeGrid 요소 존재 확인
        const storeGrid = document.getElementById('storeGrid');
        if (storeGrid) {
            storeGrid.innerHTML = "";
            loadStoreList();
        } else {
            console.error('storeGrid 요소를 찾을 수 없습니다. 페이지 구조를 확인해주세요.');
            return; // 초기화 중단
        }
    } catch (error) {
        console.error('initializeStorePage 함수 실행 중 오류:', error);
    }

    // 더보기 버튼 이벤트 리스너
    const loadMoreBtn = document.getElementById('loadMoreBtn');
    if (loadMoreBtn) {
        loadMoreBtn.addEventListener('click', function () {
            if (hasNext && !loading) {
                loadStoreList();
            }
        });
    } else {
        console.error('loadMoreBtn 요소를 찾을 수 없습니다.');
    }

    // 검색창 Enter 키 이벤트
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function (e) {
            if (e.key === 'Enter') {
                performSearch();
            }
        });
    }

    // 장바구니 개수 업데이트
    if (typeof updateCartBadge === 'function') {
        fetch(UrlConstants.Builder.fullUrl(UrlConstants.API.CART_COUNT))
            .then(response => response.json())
            .then(data => updateCartBadge(data.count || 0))
            .catch(error => console.error('장바구니 개수 로드 실패:', error));
    }

    //정렬 셀렉트 박스 활성화
    const sortSelect = document.getElementById('sortSelect');
    if (sortSelect) {
        sortSelect.value = currentSort; // 초기값 셋팅
    }

    // 카테고리 렌더링 및 선택
    if (window.allCategories) {
        setCategories(window.allCategories);
    } else {
        // fallback: DOM에서 읽기 (예시)
        const cats = [];
        document.querySelectorAll('.category-item').forEach(btn => {
            const name = btn.querySelector('.category-name')?.textContent;
            const img = btn.querySelector('img')?.src;
            if (name && name !== '전체' && name !== '더보기') cats.push({categoryName: name, categoryImage: img});
        });
        setCategories(cats);
    }
}

// ==================== 장바구니 관련 ====================
// updateCartBadge 함수는 cart.js에서 제공됨

function loadCategoryConfig() {
    try {
        // UrlConstants가 로드되지 않은 경우 처리
        if (typeof UrlConstants === 'undefined' || !UrlConstants.API || !UrlConstants.API.STORE_CATEGORY_CONFIG) {
            console.error('UrlConstants가 로드되지 않았습니다.');
            categoryConfig = {};
            return;
        }

        const apiUrl = UrlConstants.Builder.fullUrl(UrlConstants.API.STORE_CATEGORY_CONFIG);
        console.log('카테고리 설정 API 호출:', apiUrl);

        fetch(apiUrl)
            .then(response => {
                console.log('API 응답 상태:', response.status, response.statusText);
                
                if (!response.ok) {
                    // 응답이 HTML인지 확인
                    const contentType = response.headers.get('content-type');
                    if (contentType && contentType.includes('text/html')) {
                        throw new Error('서버가 HTML 페이지를 반환했습니다. 서버가 실행 중인지 확인해주세요.');
                    }
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                
                return response.json();
            })
            .then(data => {
                categoryConfig = data.data || data;
                console.log('카테고리 설정 로딩 성공:', categoryConfig);
            })
            .catch(error => {
                console.error('카테고리 설정 로딩 실패:', error);
                console.log('서버가 실행 중인지 확인하고, API 엔드포인트가 올바른지 확인해주세요.');
                // 오류 발생 시 기본값 설정
                categoryConfig = {};
            });
    } catch (error) {
        console.error('loadCategoryConfig 함수 실행 중 오류:', error);
        categoryConfig = {};
    }
}

// ==================== 화면 전환 ====================
function showMap() {
    document.getElementById('mapBtn').classList.add('map-tab', 'active');
    document.getElementById('listBtn').classList.remove('active');
    document.getElementById('mapContainer').style.display = 'flex';
    document.querySelector('.map-view').style.display = 'block';
    document.querySelector('.map-category-container').style.display = 'block';
    document.getElementById('listContainer').style.display = 'none';
    document.querySelector('.wrap').classList.add('map-view');
    document.querySelector('.scroll-list-header').style.display = 'none';


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
    document.getElementById('listBtn').classList.add('map-tab', 'active');
    document.getElementById('mapBtn').classList.remove('active');
    document.getElementById('listContainer').style.display = 'block';
    document.getElementById('mapContainer').style.display = 'none';
    document.querySelector('.map-category-container').style.display = 'none';
    document.querySelector('.wrap').classList.remove('map-view');
    document.querySelector('.scroll-list-header').style.display = '';

}

// ==================== 지도 초기화 ====================
function initializeMap() {
    // 카카오맵 SDK가 로딩될 때까지 대기
    if (window.kakaoMapSDKPromise) {
        window.kakaoMapSDKPromise
            .then(() => {
                initializeMapWithSDK();
            })
            .catch((error) => {
                console.error('카카오맵 SDK 로딩 실패로 지도를 초기화할 수 없습니다:', error);
            });
    } else {
        // fallback: SDK가 이미 로드된 경우
        if (typeof kakao !== 'undefined' && kakao.maps && kakao.maps.LatLng) {
            initializeMapWithSDK();
        } else {
            console.error('카카오맵 SDK를 사용할 수 없습니다.');
        }
    }
}

function initializeMapWithSDK() {
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
    try {
        if (!kakao || !kakao.maps) {
            console.error('카카오맵 SDK를 사용할 수 없습니다.');
            return;
        }

        const mapContainer = document.getElementById('map');
        if (!mapContainer) {
            console.error('지도 컨테이너를 찾을 수 없습니다.');
            return;
        }

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
            const allCategoryBtn = document.querySelector('.map-category-btn[onclick*="전체"]');
            if (allCategoryBtn) {
                allCategoryBtn.classList.add('active');
            }
        }, 100);
    } catch (error) {
        console.error('지도 생성 중 오류 발생:', error);
    }
}

// ==================== 카테고리 선택 ====================
function selectCategory(element, category) {
    // 카테고리 순서 조정 및 재렌더링
    renderCategoryGrids(category);
    // 모든 카테고리 버튼에서 active/selected 클래스 제거 후 현재만 추가
    document.querySelectorAll('.category-item').forEach(item => {
        item.classList.remove('active', 'selected');
    });
    element.classList.add('active', 'selected');
    // 현재 카테고리 업데이트
    currentCategory = category;
    // 확장 카테고리 펼쳐져 있으면 접기
    const extendedCategories = document.getElementById('extendedCategories');
    if (extendedCategories && extendedCategories.style.display === 'grid') {
        setTimeout(() => { toggleMoreCategories(); }, 200);
    }
    // 지도/목록 동기화
    const mapContainer = document.getElementById('mapContainer');
    const mapDisplay = window.getComputedStyle(mapContainer).display;
    const isMapView = mapDisplay === 'flex';
    if (isMapView) {
        searchMapCategory(category);
    }
    // 검색 모드 해제
    clearSearchMode();
    // 페이지네이션 초기화 및 목록 로드
    resetPagination();
    loadStoreList();
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
    const moreIcon = document.getElementById('moreIcon');

    if (extendedCategories.style.display === 'grid') {
        // 펼쳐져 있음 → 접기 실행
        extendedCategories.style.display = 'none';
        moreText.textContent = '더보기';
        if (moreIcon) {
            moreIcon.className = 'bi bi-chevron-down'; // 더보기일 때 아래 화살표
        }
    } else {
        // 접혀져 있음 → 더보기 실행
        extendedCategories.style.display = 'grid';
        moreText.textContent = '접기';
        if (moreIcon) {
            moreIcon.className = 'bi bi-chevron-up'; // 접기일 때 위 화살표
        }
    }
}

// ==================== 페이징 처리 - 통합된 로직 ====================
function resetPagination() {
    offset = 0;
    hasNext = true;
    loading = false;
    document.getElementById('storeGrid').innerHTML = "";
    document.getElementById('loadMoreBtn').style.display = "none";
}

function loadStoreList() {
    if (loading) return;

    // UrlConstants 확인
    if (typeof UrlConstants === 'undefined' || !UrlConstants.API) {
        console.error('UrlConstants가 로드되지 않았습니다.');
        return;
    }

    loading = true;
    const loadMoreBtn = document.getElementById('loadMoreBtn');
    const storeGrid = document.getElementById('storeGrid');

    if (!storeGrid) {
        console.error('storeGrid 요소를 찾을 수 없습니다.');
        loading = false;
        return;
    }

    if (offset === 0) {
        // 첫 로딩
        storeGrid.innerHTML = "";
        if (loadMoreBtn) loadMoreBtn.style.display = "none";
    } else {
        // 더보기
        if (loadMoreBtn) {
            loadMoreBtn.textContent = "로딩중...";
            loadMoreBtn.disabled = true;
        }
    }

    const isSearchActive = currentSearchKeyword && currentSearchKeyword.trim() !== '';
    let apiUrl;

    if (isSearchActive) {
        apiUrl = UrlConstants.Builder.fullUrl(`${UrlConstants.API.STORE_SEARCH}?keyword=${encodeURIComponent(currentSearchKeyword)}&offset=${offset}&pageSize=${pageSize}&sort=${currentSort}`);
    } else {
        apiUrl = UrlConstants.Builder.fullUrl(`${UrlConstants.API.STORE_LIST}?category=${encodeURIComponent(currentCategory)}&offset=${offset}&pageSize=${pageSize}&sort=${currentSort}`);
    }

    console.log('가게 목록 API 호출:', apiUrl);

    fetch(apiUrl)
        .then(res => {
            console.log('가게 목록 API 응답 상태:', res.status, res.statusText);
            
            if (!res.ok) {
                // 응답이 HTML인지 확인
                const contentType = res.headers.get('content-type');
                if (contentType && contentType.includes('text/html')) {
                    throw new Error('서버가 HTML 페이지를 반환했습니다. 서버가 실행 중인지 확인해주세요.');
                }
                throw new Error(`HTTP ${res.status}: ${res.statusText}`);
            }
            
            return res.json();
        })
        .then(data => {
            hasNext = data.hasNext;
            const storeList = data.list || [];

            renderStoreList(storeList);
            offset += storeList.length;

            // 더보기 버튼 상태 업데이트
            if (hasNext && loadMoreBtn) {
                loadMoreBtn.style.display = "block";
                loadMoreBtn.textContent = "더보기";
                loadMoreBtn.disabled = false;
            } else if (loadMoreBtn) {
                loadMoreBtn.style.display = "none";
            }
        })
        .catch(error => {
            console.error('목록 로드 실패:', error);
            console.log('서버가 실행 중인지 확인하고, API 엔드포인트가 올바른지 확인해주세요.');
            
            // 오류 메시지 표시
            if (storeGrid) {
                storeGrid.innerHTML = `
                    <div style="grid-column: 1/-1; text-align: center; padding: 40px; color: #dc3545;">
                        <i class="bi bi-exclamation-triangle" style="font-size: 48px; margin-bottom: 16px; display: block;"></i>
                        <h3 style="margin-bottom: 8px;">데이터를 불러올 수 없습니다</h3>
                        <p>서버 연결에 문제가 있습니다. 페이지를 새로고침해주세요.</p>
                        <button onclick="location.reload()" class="btn btn-outline-danger mt-3">새로고침</button>
                    </div>
                `;
            }
        })
        .finally(() => {
            loading = false;
        });
}

function renderStoreList(list) {
    const container = document.getElementById('storeGrid');
    const usersId = window.loginUserId;

    if (!container) {
        return;
    }

    // 첫 로딩이고 결과가 없을 때 메시지 표시
    if (offset === 0 && (!list || list.length === 0)) {
        if (isSearchMode) {
            container.innerHTML = `
                <div style="grid-column: 1/-1; text-align: center; padding: 40px; color: #666;">
                    <i class="bi bi-search" style="font-size: 48px; margin-bottom: 16px; display: block;"></i>
                    <h3 style="margin-bottom: 8px;">검색 결과가 없습니다</h3>
                    <p>'${currentSearchKeyword}'에 대한 검색 결과를 찾을 수 없습니다.</p>
                    <button onclick="clearSearch()" class="btn btn-outline-primary mt-3">전체 목록 보기</button>
                </div>
            `;
        } else {
            container.innerHTML = `
                <div style="grid-column: 1/-1; text-align: center; padding: 40px; color: #666;">
                    <i class="bi bi-shop" style="font-size: 48px; margin-bottom: 16px; display: block;"></i>
                    <h3 style="margin-bottom: 8px;">가게가 없습니다</h3>
                    <p>다른 카테고리를 선택해보세요.</p>
                </div>
            `;
        }
        return;
    }

    // 가게 카드들 생성
    list.forEach(store => {
        const card = createStoreCardElement(store, usersId);
        if (card) {
            container.appendChild(card);
        }
    });
}

// ==================== 스토어 카드 생성 ====================
function createStoreCardElement(store, usersId) {
    try {
        // 필수 데이터 검증
        if (!store) {
            console.error('store 데이터가 없습니다:', store);
            return null;
        }

        const card = document.createElement('div');
        if (!card) {
            console.error('div 엘리먼트 생성 실패');
            return null;
        }

        card.className = "store-card";
        card.setAttribute('data-category', store.storeCategory || '');

        const likedClass = store.liked ? 'liked' : '';
        const heartIcon = store.liked ? 'bi-heart-fill' : 'bi-heart';

        // 안전한 문자열 처리
        const safeName = String(store.storeName || '이름 없음');
        const safeCategory = String(store.storeCategory || '기타');
        const safeImage = store.storeMainimage || 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=200&h=120&fit=crop&crop=center';
        const safeAddress = store.storeAddress || '';
        const safeTel = store.storeTel || '';
        const safeRating = Number(store.storeAvgstar || 0);

        // 주소 표시 (15자 제한)
        const displayAddress = safeAddress && safeAddress.length > 15
            ? safeAddress.substring(0, 15) + '...'
            : safeAddress;

        // 별점 표시 개선 (실시간 계산된 별점, 소수점 한 자리까지)
        const starDisplay = safeRating > 0
            ? `⭐ ${safeRating.toFixed(1)}점`
            : '⭐ 신규매장';

        card.innerHTML = `
            <img src="${safeImage}" alt="${safeName}" class="store-img" 
                 onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
            <div class="store-img" style="background-color: #f8f9fa; display: none; align-items: center; justify-content: center; color: #6c757d;">
                <i class="bi bi-shop" style="font-size: 40px;"></i>
            </div>
            <div class="store-body">
                <div class="store-name">${safeName}</div>
                <div class="store-category">${safeCategory}</div>
                <div style="font-size:11px; color:#666; margin-bottom:5px;">
                    📍 ${displayAddress}
                </div>
                <div style="font-size:12px;">
                    ${starDisplay}
                </div>
                ${safeTel && safeTel !== '정보없음' ? `<div style="font-size:10px; color:#28a745; margin-top:4px;">📞 ${safeTel}</div>` : ''}
                <button
                    class="like-btn ${likedClass}"
                    data-store-id="${store.storeId}"
                    data-users-id="${usersId}"
                    aria-label="찜">
                    <i class="bi ${heartIcon}"></i>
                </button>
            </div>
        `;

        // 카드 클릭(상세이동)
        card.addEventListener('click', () => goToStoreDetail(store.storeId));

        // 하트 버튼 클릭(버블링 방지)
        const likeBtn = card.querySelector('.like-btn');
        likeBtn.addEventListener('click', function (event) {
            event.stopPropagation();
            toggleLike(this);
        });

        return card;

    } catch (error) {
        console.error('createStoreCardElement 실행 중 오류:', error, store);
        return null;
    }
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
    try {
        if (!kakao || !kakao.maps) {
            console.error('카카오맵 SDK를 사용할 수 없습니다.');
            return;
        }

        const marker = new kakao.maps.Marker({
            map: map,
            position: new kakao.maps.LatLng(place.y, place.x)
        });

        markers.push(marker);

        kakao.maps.event.addListener(marker, 'click', function () {
            closeAllInfoWindows();

            const content = createDetailedInfoWindow(place);
            const infowindow = new kakao.maps.InfoWindow({
                content: content,
                removable: false
            });

            currentInfoWindow = infowindow;
            infowindow.open(map, marker);
        });
    } catch (error) {
        console.error('마커 생성 중 오류 발생:', error);
    }
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

// ==================== 검색 기능 ====================
function performSearch() {
    const searchInput = document.getElementById('searchInput');
    const keyword = searchInput.value.trim();

    if (!keyword) {
        showWarningPopup('검색어를 입력해주세요.');
        searchInput.focus();
        return;
    }

    // 검색 모드로 전환 및 초기화
    isSearchMode = true;
    currentSearchKeyword = keyword;
    resetPagination();

    // 검색 UI 업데이트
    updateSearchUI(keyword);

    // 페이징 API로 검색 실행
    loadStoreList();
}

function updateSearchUI(keyword) {
    // 카테고리 선택 해제
    document.querySelectorAll('.category-item').forEach(item => {
        item.classList.remove('active');
    });

    // 검색 상태 표시를 위한 헤더 추가
    const listContainer = document.querySelector('.list-container');
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
        listContainer.prepend(searchHeader);
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

function clearSearchMode() {
    isSearchMode = false;
    currentSearchKeyword = '';

    // 검색창 초기화
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.value = '';
    }

    // 검색 헤더 제거
    const searchHeader = document.getElementById('searchHeader');
    if (searchHeader) {
        searchHeader.remove();
    }
}

function clearSearch() {
    clearSearchMode();

    // '전체' 카테고리 선택
    const allCategoryElement = document.querySelector('.category-item[onclick*="전체"]') ||
        document.querySelector('.category-item:first-child');

    if (allCategoryElement) {
        selectCategory(allCategoryElement, '전체');
    } else {
        // fallback: 직접 전체 목록 로드
        currentCategory = '전체';
        resetPagination();
        loadStoreList();
    }
}

// ==================== 찜 기능 ====================
function toggleLike(btn) {
    const storeId = btn.dataset.storeId;
    const isLiked = btn.classList.contains('liked');
    const url = isLiked ? UrlConstants.Builder.fullUrl('/user/like/cancel') : UrlConstants.Builder.fullUrl('/user/like/add');
    const urlWithParams = `${url}?storeId=${encodeURIComponent(storeId)}`;

    fetch(urlWithParams)
        .then(res => res.json())
        .then(res => {
            if (res.result === "success") {
                if (isLiked) {
                    btn.classList.remove('liked');
                    btn.querySelector('i').className = 'bi bi-heart';
                } else {
                    btn.classList.add('liked');
                    btn.querySelector('i').className = 'bi bi-heart-fill';
                }
            } else {
                showErrorPopup('찜 처리 중 오류가 발생했습니다.');
            }
        })
        .catch(() => {
            showErrorPopup('서버와 통신 중 오류가 발생했습니다.');
        });
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
    window.location.href = UrlConstants.Builder.storeDetail(storeId);
}

function goToStoreDetailFromMap(placeName, placeId) {
    // 로딩 상태 표시
    const loadingOverlay = document.createElement('div');
    loadingOverlay.id = 'mapSearchLoading';
    loadingOverlay.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 10000;
    `;
    loadingOverlay.innerHTML = `
        <div style="background: white; padding: 20px; border-radius: 8px; text-align: center;">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">검색 중...</span>
            </div>
            <div style="margin-top: 10px; color: #666;">가게 정보를 확인하는 중...</div>
        </div>
    `;
    document.body.appendChild(loadingOverlay);

    // 가게명으로 DB 검색
    const searchUrl = UrlConstants.Builder.fullUrl(`${UrlConstants.API.STORE_SEARCH_BY_NAME}?name=${encodeURIComponent(placeName)}`);

    fetch(searchUrl)
        .then(response => response.json())
        .then(data => {
            // 로딩 오버레이 제거
            document.body.removeChild(loadingOverlay);

            if (data.success && data.stores && data.stores.length > 0) {
                // 가게가 존재하는 경우 - 첫 번째 가게의 상세페이지로 이동
                const store = data.stores[0];
                window.location.href = UrlConstants.Builder.storeDetail(store.storeId);
            } else {
                // 가게가 없는 경우 - 모달 표시
                showKakaoMapModal(placeName, placeId);
                closeCurrentInfoWindow();
            }
        })
        .catch(error => {
            // 에러 처리
            console.error('가게 검색 중 오류 발생:', error);
            document.body.removeChild(loadingOverlay);
            showErrorPopup('가게 정보를 확인하는 중 오류가 발생했습니다.\n잠시 후 다시 시도해주세요.');
            closeCurrentInfoWindow();
        });
}

// ESC 키 이벤트 핸들러 (전역 변수)
let kakaoMapModalEscHandler = null;

// 카카오맵 모달 표시 함수
function showKakaoMapModal(placeName, placeId) {
    // 기존 모달이 있다면 제거
    const existingModal = document.getElementById('kakaoMapModal');
    if (existingModal) {
        existingModal.remove();
    }

    // 모달 생성
    const modal = document.createElement('div');
    modal.id = 'kakaoMapModal';
    modal.style.cssText = `
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.5);
        display: flex;
        justify-content: center;
        align-items: center;
        z-index: 10001;
    `;

    // 모달 외부 클릭 시 닫기
    modal.addEventListener('click', function (e) {
        if (e.target === modal) {
            closeKakaoMapModal();
        }
    });

    modal.innerHTML = `
        <div style="
            background: white;
            border-radius: 12px;
            padding: 24px;
            max-width: 400px;
            width: 90%;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        ">
            <div style="margin-bottom: 20px;">
                <div style="
                    width: 60px;
                    height: 60px;
                    background: #fee500;
                    border-radius: 50%;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 0 auto 16px;
                ">
                    <span style="font-size: 24px;">🗺️</span>
                </div>
                <h3 style="margin: 0 0 8px 0; color: #333; font-size: 18px;">카카오맵으로 이동</h3>
                <p style="margin: 0; color: #666; font-size: 14px; line-height: 1.4;">
                    '${placeName}' 가게는 현재 Sol Food에 등록되지 않았습니다.<br>
                    카카오맵에서 자세한 정보를 확인하시겠습니까?
                </p>
            </div>
            <div style="display: flex; gap: 12px; justify-content: center;">
                <button onclick="closeKakaoMapModal()" style="
                    padding: 12px 24px;
                    border: 1px solid #ddd;
                    background: white;
                    color: #666;
                    border-radius: 8px;
                    font-size: 14px;
                    cursor: pointer;
                    transition: all 0.2s;
                " onmouseover="this.style.background='#f8f9fa'" onmouseout="this.style.background='white'">
                    취소
                </button>
                <button onclick="openKakaoMap('${placeName}')" style="
                    padding: 12px 24px;
                    border: none;
                    background: #fee500;
                    color: #000;
                    border-radius: 8px;
                    font-size: 14px;
                    font-weight: bold;
                    cursor: pointer;
                    transition: all 0.2s;
                " onmouseover="this.style.background='#f4d800'" onmouseout="this.style.background='#fee500'">
                    카카오맵 열기
                </button>
            </div>
        </div>
    `;

    document.body.appendChild(modal);

    // ESC 키 이벤트 리스너 추가
    kakaoMapModalEscHandler = function (e) {
        if (e.key === 'Escape') {
            closeKakaoMapModal();
        }
    };
    document.addEventListener('keydown', kakaoMapModalEscHandler);
}

// 카카오맵 모달 닫기 함수
function closeKakaoMapModal() {
    const modal = document.getElementById('kakaoMapModal');
    if (modal) {
        modal.remove();
    }

    // ESC 키 이벤트 리스너 정리
    if (kakaoMapModalEscHandler) {
        document.removeEventListener('keydown', kakaoMapModalEscHandler);
        kakaoMapModalEscHandler = null;
    }
}

// 카카오맵 열기 함수
function openKakaoMap(placeName) {
    // 카카오맵 URL 생성 (검색어로 검색)
    const encodedPlaceName = encodeURIComponent(placeName);
    const kakaoMapUrl = `https://map.kakao.com/link/search/${encodedPlaceName}`;

    // 새 창에서 카카오맵 열기
    window.open(kakaoMapUrl, '_blank');

    // 모달 닫기
    closeKakaoMapModal();
}

function callStore(phoneNumber) {
    if (phoneNumber) {
        window.location.href = 'tel:' + phoneNumber;
    } else {
        showWarningPopup('전화번호 정보가 없습니다.');
    }
}

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

// ==================== 더보기 버튼 관련 ====================
function loadMoreStores() {
    if (loading || !hasNext) return;
    loadStoreList();
}

// ==================== 가게 정렬 관련 ====================
function changeSort(sortType) {
    // 현재 정렬값 갱신
    currentSort = sortType;

    // 페이징 및 목록 초기화
    resetPagination();
    loadStoreList();
}

// ==================== 토글 ====================
function toggleSortDropdown() {
    $("#sortDropdownMenu").toggle();
}

$(document).on("click", ".sort-option", function () {
    $(".sort-option").removeClass("selected");
    $(this).addClass("selected");
    $("#sortSelectedText").text($(this).text().trim());
    $("#sortDropdownMenu").hide();
    // TODO: 실제 정렬 파라미터 반영
    changeSort($(this).data("value"));
});
// 바깥 클릭시 닫기
$(document).on("click", function (e) {
    if (!$(e.target).closest('.sort-dropdown').length) {
        $("#sortDropdownMenu").hide();
    }
});


document.addEventListener('DOMContentLoaded', function() {
    var scrollListArea = document.querySelector('.scroll-list-area');
    var categoryContainer = document.querySelector('.category-container');
    var lastClass = false;

    if (scrollListArea && categoryContainer) {
        scrollListArea.addEventListener('scroll', function() {
            if (scrollListArea.scrollTop > 30 && !lastClass) {
                categoryContainer.classList.add('one-line');
                lastClass = true;
            }
            else if (scrollListArea.scrollTop <= 30 && lastClass) {
                categoryContainer.classList.remove('one-line');
                lastClass = false;
            }
        });
    }
});

// ==================== 카테고리 렌더링 및 선택 ====================
let allCategories = [];
let mainCategoriesCount = 3; // 첫 줄에 표시할 카테고리 수

function setCategories(categories) {
    allCategories = categories.slice();
    renderCategoryGrids();
}

function renderCategoryGrids(selectedCategoryName) {
    const mainGrid = document.getElementById('mainCategoryGrid');
    const extendedGrid = document.getElementById('extendedCategories');
    if (!mainGrid || !extendedGrid) return;

    // 첫 줄: 전체 + 앞 mainCategoriesCount개
    let mainCats = allCategories.slice(0, mainCategoriesCount);
    let extendedCats = allCategories.slice(mainCategoriesCount);

    // 선택된 카테고리가 extended에 있으면 첫 줄로 올림
    if (selectedCategoryName && selectedCategoryName !== '전체') {
        const idx = allCategories.findIndex(cat => cat.categoryName === selectedCategoryName);
        if (idx >= mainCategoriesCount) {
            // 해당 카테고리 객체를 첫 줄로 이동
            const [catObj] = allCategories.splice(idx, 1);
            allCategories.splice(0, 0, catObj); // 첫 번째(전체 다음)에 삽입
            mainCats = allCategories.slice(0, mainCategoriesCount);
            extendedCats = allCategories.slice(mainCategoriesCount);
        }
    }

    // 메인 그리드 렌더링
    let html = `<button class="category-item${selectedCategoryName==='전체'?' selected':''}" onclick="selectCategory(this, '전체')">
        <div class="category-icon${selectedCategoryName==='전체'?' selected':''}"><i class="bi bi-grid-3x3-gap" style="font-size: 24px; color: #666;"></i></div>
        <span class="category-name">전체</span>
    </button>`;
    mainCats.forEach(cat => {
        html += `<button class="category-item${selectedCategoryName===cat.categoryName?' selected':''}" onclick="selectCategory(this, '${cat.categoryName}')">
            <div class="category-icon${selectedCategoryName===cat.categoryName?' selected':''}">${cat.categoryImage ? `<img src="${cat.categoryImage}" alt="${cat.categoryName}" onerror="this.style.display='none';">` : ''}</div>
            <span class="category-name">${cat.categoryName}</span>
        </button>`;
    });
    html += `<button class="category-item" onclick="toggleMoreCategories()">
        <div class="category-icon"><i id="moreIcon" class="bi bi-chevron-down" style="font-size: 24px; color: #666;"></i></div>
        <span class="category-name" id="moreText">더보기</span>
    </button>`;
    mainGrid.innerHTML = html;

    // 확장 그리드 렌더링
    let extHtml = '';
    extendedCats.forEach(cat => {
        extHtml += `<button class="category-item${selectedCategoryName===cat.categoryName?' selected':''}" onclick="selectCategory(this, '${cat.categoryName}')">
            <div class="category-icon${selectedCategoryName===cat.categoryName?' selected':''}">${cat.categoryImage ? `<img src="${cat.categoryImage}" alt="${cat.categoryName}" onerror="this.style.display='none';">` : ''}</div>
            <span class="category-name">${cat.categoryName}</span>
        </button>`;
    });
    extendedGrid.innerHTML = extHtml;
}
