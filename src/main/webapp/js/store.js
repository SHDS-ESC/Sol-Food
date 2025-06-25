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
    document.querySelectorAll('.category-item').forEach(item => item.classList.remove('active'));
    element.classList.add('active');
    currentCategory = category;
    offset = 0;
    hasNext = true;
    loadStoreList(true);

    // "더보기" 접기/펼치기 등 부가 UI
    const extendedCategories = document.getElementById('extendedCategories');
    const isMoreOpen = extendedCategories && extendedCategories.style.display === 'grid';
    if (isMoreOpen) {
        setTimeout(() => {
            toggleMoreCategories();
        }, 300);
    }

    // 지도/목록 동기화
    const mapContainer = document.getElementById('mapContainer');
    const listContainer = document.getElementById('listContainer');
    const mapDisplay = window.getComputedStyle(mapContainer).display;
    const listDisplay = window.getComputedStyle(listContainer).display;
    const isMapView = mapDisplay === 'flex';
    const isListView = listDisplay === 'block' || listDisplay === '';
    if (isListView) fallbackFilterStoreList(category);
    if (isMapView) searchMapCategory(category);
    if (!isMapView && !isListView) fallbackFilterStoreList(category);
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
                card.style.display = '';
                filteredCount++;
            } else {
                if (isCategoryMatch(storeCategoryText, category)) {
                    card.style.display = '';
                    filteredCount++;
                } else {
                    card.style.display = 'none';
                }
            }
        } else {
            card.style.display = '';
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

// 페이징처리
document.addEventListener('DOMContentLoaded', function() {
    offset = 0;
    hasNext = true;
    loading = false;
    document.getElementById('storeGrid').innerHTML = "";
    loadStoreList();

    document.getElementById('loadMoreBtn').addEventListener('click', function() {
        if (hasNext && !loading) {
            loadStoreList();
        }
    });
});


// AJAX로 목록을 받아서 append
function loadStoreList(isInit = false) {
    loading = true;
    document.getElementById('loadMoreBtn').textContent = "로딩중...";

    fetch(`/solfood/user/store/api/list?category=${encodeURIComponent(currentCategory)}&offset=${offset}&pageSize=${pageSize}`)
        .then(res => res.json())
        .then(data => {
            if (isInit) {
                document.getElementById('storeGrid').innerHTML = ""; // 카테고리 바꿀 때만 초기화
                offset = 0;
            }
            renderStoreList(data.list); // 새 목록만 append
            hasNext = data.hasNext;
            offset += data.list.length;
            if (hasNext) {
                document.getElementById('loadMoreBtn').style.display = "block";
                document.getElementById('loadMoreBtn').textContent = "더보기";
            } else {
                document.getElementById('loadMoreBtn').style.display = "none";
            }
        })
        .catch(err => {
            alert("가게 목록을 불러오지 못했습니다.");
            console.error("fetch error:", err);
        })
        .finally(() => {
            loading = false;
        });
}



function renderStoreList(list) {
    const container = document.getElementById('storeGrid');
    const usersId = window.loginUserId;

    list.forEach(store => {
        const card = document.createElement('div');
        card.className = "store-card";
        card.setAttribute('data-category', store.storeCategory);

        const likedClass = store.liked ? 'liked' : '';
        const heartIcon = store.liked ? 'bi-heart-fill' : 'bi-heart';

        card.innerHTML = `
            <img src="${store.storeMainimage || '/img/default-restaurant.jpg'}" alt="${store.storeName}" class="store-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
            <div class="store-img" style="background-color: #f8f9fa; display: none; align-items: center; justify-content: center; color: #6c757d;">
                <i class="bi bi-shop" style="font-size: 40px;"></i>
            </div>
            <div class="store-body">
                <div class="store-name">${store.storeName}</div>
                <div class="store-category">${store.storeCategory}</div>
                <div style="font-size:11px; color:#666; margin-bottom:3px;">
                    📍 ${store.storeAddress && store.storeAddress.length > 15 ? store.storeAddress.substring(0,15) + '...' : store.storeAddress}
                </div>
                <div style="font-size:12px;">
                    ${store.storeAvgstar > 0 ? `⭐ ${store.storeAvgstar}점` : '⭐ 신규매장'}
                </div>
                ${store.storeTel && store.storeTel !== '정보없음' ? `<div style="font-size:10px; color:#28a745; margin-top:2px;">📞 ${store.storeTel}</div>` : ''}
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
        likeBtn.addEventListener('click', function(event) {
            event.stopPropagation();
            toggleLike(this);
        });

        container.appendChild(card);
    });
}

function toggleLike(btn) {
    const storeId = btn.dataset.storeId;
    const isLiked = btn.classList.contains('liked');
    const url = isLiked ?'/solfood/user/like/cancel' : '/solfood/user/like/add';
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
                alert('찜 처리 중 오류가 발생했습니다.');
            }
        })
        .catch(() => {
            alert('서버와 통신 중 오류가 발생했습니다.');
        });
}
