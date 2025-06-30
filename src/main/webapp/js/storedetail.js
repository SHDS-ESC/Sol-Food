/**
 * ==========================================
 * 가게 상세페이지 JavaScript
 * ==========================================
 * Sol-Food 프로젝트의 가게 상세페이지 관련 기능을 담당
 */

/* ===========================
   전역 상수 및 설정
   =========================== */

// 가게 상세페이지 설정
const CONFIG = {
    // 지도 관련
    MAP_ZOOM_LEVEL: 4,
    MAP_INIT_DELAY: 1500, // 카카오맵 초기화 지연 시간 (ms)
    
    // 기본 좌표값 (서울 강남구)
    DEFAULT_LATITUDE: 37.496299,
    DEFAULT_LONGITUDE: 126.958500
};

// 카카오맵 전역 변수
let kakaoMapLoaded = false;
let kakaoMapLoading = false;

/* ===========================
   카카오맵 관련 함수들
   =========================== */

/**
 * 카카오맵 SDK 로딩 상태 확인
 * @returns {boolean} SDK 로딩 상태
 */
function checkKakaoMapSDK() {
    try {
        return typeof kakao !== 'undefined' && 
               kakao.maps && 
               kakao.maps.LatLng && 
               kakao.maps.Map &&
               kakao.maps.Marker;
    } catch (error) {
        return false;
    }
}

/**
 * 카카오맵 SDK 대기 함수
 * @param {Function} callback - 콜백 함수
 * @param {number} maxAttempts - 최대 시도 횟수
 */
function waitForKakaoMapSDK(callback, maxAttempts = 100) {
    let attempts = 0;
    
    function check() {
        attempts++;
        
        if (checkKakaoMapSDK()) {
            kakaoMapLoaded = true;
            kakaoMapLoading = false;
            callback();
        } else if (attempts < maxAttempts) {
            setTimeout(check, 200); // 대기 시간 증가
        } else {
            console.error('카카오맵 SDK 로딩 시간 초과');
            kakaoMapLoading = false;
            callback(false);
        }
    }
    
    check();
}

/**
 * 페이지에서 가게 데이터 추출
 * @returns {Object} 가게 데이터
 */
function getStoreDataFromPage() {
    return {
        latitude: window.storeLatitude || CONFIG.DEFAULT_LATITUDE,
        longitude: window.storeLongitude || CONFIG.DEFAULT_LONGITUDE,
        name: window.storeName || '맛있는 한식당',
        address: window.storeAddress || '서울특별시 강남구 테헤란로 123'
    };
}

/**
 * 카카오맵 초기화 함수
 */
function initMap() {
    try {
        const container = document.getElementById('map');
        if (!container) {
            console.warn('지도 컨테이너를 찾을 수 없습니다.');
            return;
        }
        
        // 카카오맵 SDK 재확인
        if (!checkKakaoMapSDK()) {
            console.error('카카오맵 SDK가 로드되지 않았습니다.');
            showMapError();
            return;
        }
        
        // 가게 좌표 정보
        const storeData = getStoreDataFromPage();
        const storeLatitude = storeData.latitude;
        const storeLongitude = storeData.longitude;
        const storeName = storeData.name;
        
        // 좌표 유효성 검사
        if (isNaN(storeLatitude) || isNaN(storeLongitude)) {
            console.error('유효하지 않은 좌표:', storeLatitude, storeLongitude);
            showMapError();
            return;
        }
        
        const options = {
            center: new kakao.maps.LatLng(storeLatitude, storeLongitude),
            level: CONFIG.MAP_ZOOM_LEVEL,
            draggable: false,
            scrollwheel: false,
            disableDoubleClick: true,
            disableDoubleClickZoom: true,
            zoomable: false
        };
        
        const map = new kakao.maps.Map(container, options);
        
        // 가게 마커 추가
        const storeMarkerPosition = new kakao.maps.LatLng(storeLatitude, storeLongitude);
        const storeMarker = new kakao.maps.Marker({
            position: storeMarkerPosition
        });
        storeMarker.setMap(map);
        
        // 가게 인포윈도우 추가
        const storeInfowindow = new kakao.maps.InfoWindow({
            content: '<div style="padding:5px;font-size:12px;">🍽️ ' + storeName + '</div>'
        });
        storeInfowindow.open(map, storeMarker);
        
        kakaoMapLoaded = true;
    } catch (error) {
        console.error('카카오맵 초기화 중 오류 발생:', error);
        showMapError();
    }
}

/**
 * 카카오맵 로딩 및 초기화
 */
function loadKakaoMap() {
    if (kakaoMapLoading) {
        return;
    }
    
    kakaoMapLoading = true;
    
    // Promise 기반 SDK 로딩 사용
    if (window.kakaoMapSDKPromise) {
        window.kakaoMapSDKPromise
            .then(() => {
                kakaoMapLoading = false;
                initMap();
            })
            .catch((error) => {
                console.error('카카오맵 SDK 로딩 실패:', error);
                kakaoMapLoading = false;
                showMapError();
            });
    } else {
        // fallback: 기존 방식
        if (checkKakaoMapSDK()) {
            kakaoMapLoading = false;
            initMap();
        } else {
            waitForKakaoMapSDK((success) => {
                if (success !== false) {
                    initMap();
                } else {
                    showMapError();
                }
            });
        }
    }
}

/**
 * 지도 로딩 실패 시 에러 메시지 표시
 */
function showMapError() {
    const mapContainer = document.getElementById('map');
    if (mapContainer) {
        mapContainer.innerHTML = `
            <div style="width:100%; height:100%; background:#f0f0f0; display:flex; align-items:center; justify-content:center; flex-direction:column;">
                <div style="background:white; padding:20px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.1); text-align:center; max-width:300px;">
                    <h3 style="margin-bottom:15px; color:#333;">📍 가게 위치</h3>
                    <p style="margin:5px 0; color:#666;">${window.storeAddress || '주소 정보 없음'}</p>
                    <p style="margin:5px 0; color:#999; font-size:12px;">지도를 불러올 수 없습니다.</p>
                    <div style="margin-top:15px;">
                        <button onclick="loadKakaoMap()" style="background:#fee500; color:#000; border:none; padding:8px 16px; border-radius:5px; cursor:pointer; font-weight:bold;">다시 시도</button>
                    </div>
                </div>
            </div>
        `;
    }
}

/* ===========================
   탭 및 UI 관련 함수들
   =========================== */

/**
 * 카테고리 필터 초기화
 */
function initializeCategoryFilter() {
    const categoryTabs = document.querySelectorAll('.category-tab');
    const menuItems = document.querySelectorAll('.menu-item');
    
    if (categoryTabs.length === 0 || menuItems.length === 0) return;
    
    categoryTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            // 모든 탭에서 active 클래스 제거
            categoryTabs.forEach(t => t.classList.remove('active'));
            // 클릭된 탭에 active 클래스 추가
            tab.classList.add('active');
            
            const category = tab.getAttribute('data-category');
            
            // 메뉴 항목 필터링
            menuItems.forEach(item => {
                if (category === '전체' || item.getAttribute('data-category') === category) {
                    item.classList.remove('hidden');
                } else {
                    item.classList.add('hidden');
                }
            });
        });
    });
}

/**
 * 별점 막대 그래프 초기화
 */
function initializeStarBars() {
    const starBars = document.querySelectorAll('.bar-fill');
    const starCounts = document.querySelectorAll('.bar-percent');
    
    starBars.forEach((bar, index) => {
        const percent = starCounts[index]?.textContent || '0%';
        const percentValue = parseInt(percent);
        
        setTimeout(() => {
            bar.style.width = percent;
        }, 300 + (index * 100));
    });
}

/**
 * 탭 변경 처리
 * @param {string} tabName - 탭 이름
 */
function handleHeaderChange(tabName) {
    // 모든 섹션 숨기기
    document.querySelectorAll('.content-section').forEach(section => {
        section.classList.remove('active');
    });
    
    // 모든 탭에서 active 클래스 제거
    document.querySelectorAll('.tab').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // 선택된 탭과 섹션 활성화
    const selectedTab = document.querySelector(`.tab[data-tab="${tabName}"]`);
    const selectedSection = document.querySelector(`#${tabName}-section`);
    
    if (selectedTab) selectedTab.classList.add('active');
    if (selectedSection) selectedSection.classList.add('active');
    
    // 별점 통계 표시/숨김 처리
    const summary = document.querySelector('.summary');
    if (summary) {
        if (tabName === 'review') {
            summary.classList.remove('hide');
            summary.classList.add('show');
        } else {
            summary.classList.remove('show');
            summary.classList.add('hide');
        }
    }
    
    // 가게 대표 사진 표시/숨김 처리
    const featuredMenu = document.querySelector('.featured-menu');
    const scrollableContent = document.querySelector('.scrollable-content');
    
    if (featuredMenu && scrollableContent) {
        if (tabName === 'review') {
            // body에 review-mode 클래스 추가
            document.body.classList.add('review-mode');
            
            featuredMenu.classList.remove('show');
            featuredMenu.classList.add('hide');
            featuredMenu.style.display = 'none';
            featuredMenu.style.visibility = 'hidden';
            featuredMenu.style.height = '0';
            featuredMenu.style.overflow = 'hidden';
            // 리뷰 탭일 때 padding-top 조정 (별점 요약 + 탭 높이만)
            scrollableContent.style.paddingTop = '300px';
        } else {
            // body에서 review-mode 클래스 제거
            document.body.classList.remove('review-mode');
            
            featuredMenu.classList.remove('hide');
            featuredMenu.classList.add('show');
            featuredMenu.style.display = 'block';
            featuredMenu.style.visibility = 'visible';
            featuredMenu.style.height = 'auto';
            featuredMenu.style.overflow = 'visible';
            // 다른 탭일 때 원래 padding-top (대표 사진 + 탭 높이)
            scrollableContent.style.paddingTop = '270px';
        }
    }
    
    // 지도 탭일 때 지도 초기화
    if (tabName === 'map') {
        setTimeout(loadKakaoMap, 300);
    }
}

/**
 * 탭 이벤트 초기화
 */
function initializeTabEvents() {
    const tabs = document.querySelectorAll('.tab');
    
    tabs.forEach((tab, index) => {
        tab.addEventListener('click', (e) => {
            e.preventDefault();
            const tabName = tab.getAttribute('data-tab');
            handleHeaderChange(tabName);
        });
    });
    
    // 기본 탭을 메뉴로 설정
    const defaultTab = document.querySelector('.tab[data-tab="menu"]');
    if (defaultTab) {
        setTimeout(() => {
            handleHeaderChange('menu'); // 직접 함수 호출로 변경
        }, 100);
    } else {
        console.error('기본 탭(메뉴)을 찾을 수 없습니다.');
    }
}

/**
 * 스크롤 이벤트 초기화
 */
function initializeScrollEvents() {
    const scrollableContent = document.querySelector('.scrollable-content');
    if (!scrollableContent) return;
    
    scrollableContent.addEventListener('scroll', () => {
        const scrollTop = scrollableContent.scrollTop;
        
        // 스크롤에 따른 헤더 효과
        if (scrollTop > 50) {
            document.body.classList.add('scrolled');
        } else {
            document.body.classList.remove('scrolled');
        }
    });
}

/* ===========================
   초기화 함수들
   =========================== */

/**
 * 가게 상세페이지 초기화
 */
function initializeStoreDetailPage() {
    // 탭 이벤트 초기화
    initializeTabEvents();
    
    // 카테고리 필터 초기화
    initializeCategoryFilter();
    
    // 별점 막대 그래프 초기화
    initializeStarBars();
    
    // 스크롤 이벤트 초기화
    initializeScrollEvents();
    
    // 장바구니 배지 업데이트
    if (typeof updateCartBadge === 'function') {
        fetch(UrlConstants.Builder.fullUrl('/user/cart/count'))
            .then(response => response.json())
            .then(data => updateCartBadge(data.count || 0))
            .catch(error => console.error('장바구니 개수 로드 실패:', error));
    }
}

/* ===========================
   장바구니 관련 함수들
   =========================== */

// updateCartBadge 함수는 cart.js에서 제공됨

/**
 * 페이지 로드 완료 후 초기화
 */
function initializeStoreDetailSystem() {
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeStoreDetailPage);
    } else {
        initializeStoreDetailPage();
    }
}

// 시스템 초기화 실행
initializeStoreDetailSystem();

function loadStoreDetail() {
    const storeId = getStoreIdFromUrl();
    if (!storeId) {
        alert('가게 정보를 찾을 수 없습니다.');
        history.back();
        return;
    }
    
    fetch(UrlConstants.Builder.fullUrl('/user/store/api/detail/' + storeId))
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                renderStoreDetail(data.data);
                loadReviews(storeId);
            } else {
                alert('가게 정보를 불러오는데 실패했습니다.');
            }
        })
        .catch(error => {
            console.error('가게 상세 정보 로드 실패:', error);
            alert('가게 정보를 불러오는데 실패했습니다.');
        });
}

function loadReviews(storeId) {
    fetch(UrlConstants.Builder.fullUrl(`/user/review/api/list?storeId=${storeId}`))
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                renderReviews(data.data.reviews || []);
            }
        })
        .catch(error => {
            console.error('리뷰 로드 실패:', error);
        });
} 