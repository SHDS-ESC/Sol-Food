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
            return;
        }
        
        // 카카오맵 SDK 재확인
        if (!checkKakaoMapSDK()) {
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
    
    // 장바구니 정보 업데이트
    setTimeout(() => {
        console.log('🔄 상세페이지 장바구니 초기화 시작');

        if (document.getElementById('bottomCartBar') && typeof fetchCartInfo === 'function') {
            // 하단 카트 바가 있는 경우 총 금액도 함께 조회
            console.log('🛒 하단 카트 바 초기화');
            fetchCartInfo();
        } else if (typeof updateCartBadge === 'function') {
            // 하단 카트 바가 없는 경우 개수만 조회
            console.log('🏷️ 배지만 초기화');
            fetch(UrlConstants.Builder.fullUrl('/user/cart/count'))
                .then(response => response.json())
                .then(data => updateCartBadge(data.count || 0))
                .catch(error => console.error('장바구니 개수 로드 실패:', error));
        }
    }, 100); // 모든 요소가 완전히 로드된 후 실행
}

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

/* ===========================
   메뉴 모달 관련 함수들
   =========================== */

// 현재 선택된 메뉴 정보
let currentMenuData = {
    menuId: null,
    menuName: '',
    menuIntro: '',
    menuPrice: 0,
    menuImage: '',
    menuExtra: null,
    quantity: 1,
    options: {}
};

/**
 * 메뉴 상세 모달 열기 (data 속성 방식)
 * @param {HTMLElement} element - 클릭된 메뉴 요소
 */
function openMenuDetailFromElement(element) {
    const menuId = element.dataset.menuId;
    const menuName = element.dataset.menuName;
    const menuIntro = element.dataset.menuIntro;
    const menuPrice = parseInt(element.dataset.menuPrice);
    const menuImage = element.dataset.menuImage;
    const menuExtra = element.dataset.menuExtra;

    openMenuDetail(menuId, menuName, menuIntro, menuPrice, menuImage, menuExtra);
}

/**
 * 메뉴 상세 모달 열기
 * @param {number} menuId - 메뉴 ID
 * @param {string} menuName - 메뉴명
 * @param {string} menuIntro - 메뉴 설명
 * @param {number} menuPrice - 메뉴 가격
 * @param {string} menuImage - 메뉴 이미지
 * @param {string} menuExtra - 메뉴 추가 옵션 (JSON)
 */
function openMenuDetail(menuId, menuName, menuIntro, menuPrice, menuImage, menuExtra) {
    // 현재 메뉴 데이터 저장
    currentMenuData = {
        menuId: menuId,
        menuName: menuName,
        menuIntro: menuIntro,
        menuPrice: menuPrice,
        menuImage: menuImage,
        menuExtra: menuExtra,
        quantity: 1,
        options: {}
    };

    // 모달 요소들 업데이트
    document.getElementById('modalMenuImage').src = menuImage || 'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400&h=200&fit=crop';
    document.getElementById('modalMenuName').textContent = menuName;
    document.getElementById('modalMenuIntro').textContent = menuIntro;
    document.getElementById('modalMenuPrice').textContent = formatPrice(menuPrice);

    // 수량 초기화
    document.getElementById('quantityValue').textContent = '1';
    updateDecreaseButtonState();

    // 모든 옵션 그룹 숨기기
    const allOptionGroups = document.querySelectorAll('.option-group');
    allOptionGroups.forEach(group => {
        group.style.display = 'none';
    });

    // 기존 동적 옵션 제거
    const dynamicOptions = document.querySelectorAll('.dynamic-option-group');
    dynamicOptions.forEach(option => option.remove());

    // 현재 옵션 상태 초기화
    currentMenuData.options = {};

    // menu_extra 데이터가 있으면 동적으로 옵션 생성
    if (menuExtra && menuExtra.trim() && menuExtra !== 'null' && menuExtra !== '{}') {
        try {
            const extraData = JSON.parse(menuExtra);
            createDynamicOptions(extraData);
        } catch (e) {
            console.warn('menu_extra JSON 파싱 실패:', e);
        }
    }

    // 총 가격 계산 및 표시
    calculateTotalPrice();

    // 모달 표시
    const modal = document.getElementById('menuDetailModal');
    modal.style.display = 'flex';
    document.body.style.overflow = 'hidden'; // 백그라운드 스크롤 방지
}

/**
 * menu_extra 데이터를 기반으로 동적 옵션 생성
 * @param {Array} extraData - menu_extra JSON 데이터 (새로운 형식)
 */
function createDynamicOptions(extraData) {
    const optionsContainer = document.querySelector('.options-section');
    if (!optionsContainer || !Array.isArray(extraData)) {
        return;
    }

    extraData.forEach((group, groupIndex) => {
        const optionGroup = document.createElement('div');
        optionGroup.className = 'option-group dynamic-option-group';
        optionGroup.style.display = 'block';

        const optionTitle = document.createElement('h4');
        optionTitle.className = 'option-title';
        optionTitle.textContent = group.groupName;

        // 필수 여부 표시
        if (group.required) {
            const requiredBadge = document.createElement('span');
            requiredBadge.className = 'required-badge';
            requiredBadge.textContent = '필수';
            requiredBadge.style.cssText = 'background: #ef4444; color: white; padding: 2px 6px; border-radius: 3px; font-size: 0.7rem; margin-left: 8px;';
            optionTitle.appendChild(requiredBadge);
        }

        const optionItems = document.createElement('div');
        optionItems.className = 'option-items';

        if (group.options && group.options.length > 0) {
            // 라디오 버튼 또는 체크박스 선택
            const inputType = group.maxSelect === 1 ? 'radio' : 'checkbox';
            const inputName = `dynamic_${groupIndex}`;

            group.options.forEach((option, optionIndex) => {
                const label = document.createElement('label');
                label.className = 'option-item';

                const input = document.createElement('input');
                input.type = inputType;
                input.name = inputName;
                input.value = option.name;
                input.dataset.price = option.price || 0;
                input.dataset.optionName = group.groupName;
                input.dataset.maxSelect = group.maxSelect;

                // 라디오 버튼인 경우 첫 번째 옵션 기본 선택
                if (inputType === 'radio' && optionIndex === 0) {
                    input.checked = true;
                }

                const optionText = document.createElement('span');
                optionText.className = 'option-text';
                optionText.textContent = option.name;

                const optionPrice = document.createElement('span');
                optionPrice.className = 'option-price';
                optionPrice.textContent = `+${(option.price || 0).toLocaleString()}원`;

                // 옵션 변경 이벤트 리스너
                input.addEventListener('change', function() {
                    handleOptionChange(group, this);
                    calculateTotalPrice();
                });

                label.appendChild(input);
                label.appendChild(optionText);
                label.appendChild(optionPrice);
                optionItems.appendChild(label);

                // 기본값 설정 (라디오 버튼인 경우)
                if (inputType === 'radio' && optionIndex === 0) {
                    if (!currentMenuData.options[group.groupName]) {
                        currentMenuData.options[group.groupName] = [];
                    }
                    currentMenuData.options[group.groupName] = [{
                        name: option.name,
                        price: parseInt(option.price) || 0
                    }];
                }
            });
        }

        optionGroup.appendChild(optionTitle);
        optionGroup.appendChild(optionItems);
        optionsContainer.appendChild(optionGroup);
    });
}

/**
 * 옵션 변경 처리
 * @param {Object} group - 옵션 그룹 정보
 * @param {HTMLInputElement} input - 변경된 input 요소
 */
function handleOptionChange(group, input) {
    const groupName = group.groupName;
    const maxSelect = group.maxSelect;

    if (!currentMenuData.options[groupName]) {
        currentMenuData.options[groupName] = [];
    }

    if (input.type === 'radio') {
        // 라디오 버튼: 단일 선택
        const optionPrice = parseInt(input.dataset.price) || 0;
        currentMenuData.options[groupName] = [{
            name: input.value,
            price: optionPrice
        }];
    } else {
        // 체크박스: 다중 선택
        const selectedOptions = currentMenuData.options[groupName];

        if (input.checked) {
            // 선택된 경우
            if (selectedOptions.length < maxSelect) {
                const optionPrice = parseInt(input.dataset.price) || 0;
                selectedOptions.push({
                    name: input.value,
                    price: optionPrice
                });
            } else {
                // 최대 선택 개수 초과 시 체크 해제
                input.checked = false;
                alert(`최대 ${maxSelect}개까지 선택할 수 있습니다.`);
                return;
            }
        } else {
            // 선택 해제된 경우
            const index = selectedOptions.findIndex(opt => opt.name === input.value);
            if (index > -1) {
                const removedOption = selectedOptions.splice(index, 1)[0];
            }
        }

        // 필수 선택인 경우 최소 1개는 선택되어야 함
        if (group.required && selectedOptions.length === 0) {
            input.checked = true;
            const optionPrice = parseInt(input.dataset.price) || 0;
            selectedOptions.push({
                name: input.value,
                price: optionPrice
            });
        }
    }
}

/**
 * 메뉴 상세 모달 닫기
 */
function closeMenuDetail() {
    const modal = document.getElementById('menuDetailModal');
    modal.style.display = 'none';
    document.body.style.overflow = 'auto'; // 백그라운드 스크롤 복원

    // 데이터 초기화
    currentMenuData = {
        menuId: null,
        menuName: '',
        menuIntro: '',
        menuPrice: 0,
        menuImage: '',
        quantity: 1,
        options: {}
    };
}

/**
 * 수량 증가
 */
function increaseQuantity() {
    currentMenuData.quantity++;
    document.getElementById('quantityValue').textContent = currentMenuData.quantity;
    updateDecreaseButtonState();
    calculateTotalPrice();
}

/**
 * 수량 감소
 */
function decreaseQuantity() {
    if (currentMenuData.quantity > 1) {
        currentMenuData.quantity--;
        document.getElementById('quantityValue').textContent = currentMenuData.quantity;
        updateDecreaseButtonState();
        calculateTotalPrice();
    }
}

/**
 * 수량 감소 버튼 상태 업데이트
 */
function updateDecreaseButtonState() {
    const decreaseBtn = document.getElementById('decreaseBtn');
    if (currentMenuData.quantity <= 1) {
        decreaseBtn.disabled = true;
    } else {
        decreaseBtn.disabled = false;
    }
}

/**
 * 총 가격 계산
 */
function calculateTotalPrice() {
    let totalPrice = currentMenuData.menuPrice;

    // 선택된 옵션들의 가격 추가 (새로운 형식)
    Object.values(currentMenuData.options).forEach(optionArray => {
        if (Array.isArray(optionArray)) {
            optionArray.forEach(option => {
                totalPrice += option.price || 0;
            });
        }
    });

    // 수량 곱하기
    totalPrice *= currentMenuData.quantity;

    // 총 가격 표시
    document.getElementById('totalPrice').textContent = formatPrice(totalPrice);
}

/**
 * 가격 포맷팅 (원 단위)
 * @param {number} price - 가격
 * @returns {string} 포맷된 가격
 */
function formatPrice(price) {
    return new Intl.NumberFormat('ko-KR').format(price) + '원';
}

/**
 * 아이템 총 가격 계산 (반환용)
 * @returns {number} 총 가격
 */
function calculateItemTotalPrice() {
    let totalPrice = currentMenuData.menuPrice;

    // 선택된 옵션들의 가격 추가 (새로운 형식)
    Object.values(currentMenuData.options).forEach(optionArray => {
        if (Array.isArray(optionArray)) {
            optionArray.forEach(option => {
                totalPrice += option.price || 0;
            });
        }
    });

    // 수량 곱하기
    totalPrice *= currentMenuData.quantity;

    return totalPrice;
}

/**
 * 장바구니에 메뉴 추가
 */
function addMenuToCart() {
    // 선택된 옵션들을 서버 API에 맞는 형식으로 수집
    const selectedOptions = {};

    // 새로운 옵션 형식으로 수집 (서버 호환 형식)
    Object.entries(currentMenuData.options).forEach(([groupName, options]) => {
        if (Array.isArray(options) && options.length > 0) {
            // 서버에서 기대하는 형식: {"사이즈": "대", "토핑": ["치즈", "계란"]}
            if (options.length === 1) {
                // 단일 선택인 경우
                selectedOptions[groupName] = options[0].name;
            } else {
                // 다중 선택인 경우
                selectedOptions[groupName] = options.map(option => option.name);
            }
        }
    });

    // 새로운 자동 옵션 계산 API 사용 (fetch API)
    const formData = new FormData();
    formData.append('menuId', currentMenuData.menuId);
    formData.append('quantity', currentMenuData.quantity);
    formData.append('selectedOptions', JSON.stringify(selectedOptions));

    fetch(UrlConstants.Builder.fullUrl('/user/cart/add-with-options'), {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(response => {
        if (response.result === 'success') {
            // 성공 피드백
            showCartAddedFeedback();

            // 하단 카트 바 업데이트
            if (document.getElementById('bottomCartBar')) {
                updateCartInfo(response.cartCount, response.totalAmount);
            }

            // 모달 닫기
            closeMenuDetail();
        } else {
            alert(response.message || '장바구니 추가에 실패했습니다.');
        }
    })
    .catch(error => {
        alert('장바구니 추가 중 오류가 발생했습니다.');
    });
}

/**
 * 장바구니 정보 업데이트
 * @param {number} cartCount - 장바구니 아이템 개수
 * @param {number} totalAmount - 총 금액
 */
function updateCartInfo(cartCount, totalAmount) {
    // 하단 카트 바 업데이트
    const cartCountElement = document.querySelector('.cart-count');
    const cartTotalElement = document.querySelector('.cart-total');

    if (cartCountElement) {
        cartCountElement.textContent = cartCount || 0;
    }

    if (cartTotalElement && totalAmount !== undefined) {
        cartTotalElement.textContent = formatPrice(totalAmount);
    }

    // 기존 fetchCartInfo 함수가 있다면 호출
    if (typeof fetchCartInfo === 'function') {
        setTimeout(() => fetchCartInfo(), 100);
    }
}

/**
 * 장바구니 추가 성공 피드백 표시
 */
function showCartAddedFeedback() {
    // 간단한 토스트 메시지 표시
    const toast = document.createElement('div');
    toast.style.cssText = `
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: rgba(0, 0, 0, 0.8);
        color: white;
        padding: 16px 24px;
        border-radius: 8px;
        font-size: 14px;
        z-index: 10000;
        opacity: 0;
        transition: opacity 0.3s ease;
    `;
    toast.textContent = '🛒 장바구니에 추가되었습니다!';
    document.body.appendChild(toast);

    // 애니메이션
    setTimeout(() => {
        toast.style.opacity = '1';
    }, 10);

    setTimeout(() => {
        toast.style.opacity = '0';
        setTimeout(() => {
            document.body.removeChild(toast);
        }, 300);
    }, 1500);
}

/**
 * 옵션 그룹들을 동적으로 렌더링
 * @param {Array} optionGroups - 옵션 그룹 데이터
 */
function renderOptionGroups(optionGroups) {
    const optionsContainer = document.getElementById('optionsContainer');

    optionGroups.forEach((group, groupIndex) => {
        if (!group.options || group.options.length === 0) return;

        // 옵션 그룹 HTML 생성
        const groupElement = document.createElement('div');
        groupElement.className = 'option-group';
        groupElement.innerHTML = `
            <h4 class="option-title">
                ${group.name}
                ${group.required ? '<span class="option-required">필수 선택</span>' : ''}
            </h4>
            <div class="option-items">
                ${group.options.map((option, index) => `
                    <label class="option-item">
                        <input type="${group.type}" 
                               name="group_${groupIndex}" 
                               value="${index}" 
                               data-price="${option.price || 0}"
                               ${option.default || index === 0 ? 'checked' : ''}>
                        <span class="option-text">${option.name}</span>
                        <span class="option-price">${option.price > 0 ? '+' + formatPrice(option.price) : '+0원'}</span>
                    </label>
                `).join('')}
            </div>
        `;

        optionsContainer.appendChild(groupElement);
    });
}

/**
 * 옵션 변경 이벤트 리스너 초기화
 */
function initializeOptionListeners() {
    // 옵션 변경 시 총 가격 재계산
    document.addEventListener('change', function(e) {
        if ((e.target.type === 'radio' || e.target.type === 'checkbox') && e.target.closest('.option-group')) {
            calculateTotalPrice();
        }
    });
}

// 옵션 리스너 초기화
document.addEventListener('DOMContentLoaded', initializeOptionListeners);