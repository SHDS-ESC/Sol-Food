/**
 * ==========================================
 * 장바구니 JavaScript 
 * ==========================================
 * Sol-Food 프로젝트의 장바구니 관련 기능
 */

/**
 * 장바구니 JavaScript (경량화 버전)
 * common-utils.js 활용으로 중복 제거
 */

// 수량 변경 (+/- 버튼)
function changeQuantity(menuId, change) {
    const numMenuId = parseInt(menuId);
    const quantityInput = document.querySelector(`[data-menu-id="${numMenuId}"] .quantity-input`);
    const currentQuantity = parseInt(quantityInput.value);
    const newQuantity = currentQuantity + change;
    
    if (newQuantity < 1) {
        showConfirmPopup('수량이 0이 되면 상품이 삭제됩니다. 계속하시겠습니까?', () => {
            removeItem(numMenuId);
        });
        return;
    }
    
    quantityInput.value = newQuantity;
    updateQuantity(numMenuId, newQuantity);
}

// 수량 직접 변경
function updateQuantity(menuId, quantity) {
    const numMenuId = parseInt(menuId);
    const numQuantity = parseInt(quantity);
    
    if (numQuantity < 1) {
        removeItem(numMenuId);
        return;
    }
    
    const requestBody = `menuId=${numMenuId}&quantity=${numQuantity}`;
    
            fetch(UrlConstants.Builder.fullUrl(UrlConstants.API.CART_UPDATE), {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: requestBody
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            updateCartItemDisplay(numMenuId, numQuantity, data.totalAmount, data.cartCount);
            updateCartSummary(data.totalAmount, data.cartCount);
        } else {
            SolFoodUtils.showToast(data.message || '수량 변경에 실패했습니다.', 'error');
            restoreQuantityInput(numMenuId);
        }
    })
    .catch(error => {
        SolFoodUtils.showToast('오류가 발생했습니다.', 'error');
        restoreQuantityInput(numMenuId);
    });
}

// 장바구니 아이템 삭제
function removeItem(menuId) {
    showConfirmPopup('이 상품을 장바구니에서 삭제하시겠습니까?', () => {
        performRemoveItem(menuId);
    });
}

function performRemoveItem(menuId) {
    
    const numMenuId = parseInt(menuId);
    
            fetch(UrlConstants.Builder.fullUrl(UrlConstants.API.CART_REMOVE), {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `menuId=${numMenuId}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            removeCartItemFromDOM(numMenuId);
            updateCartSummary(data.totalAmount, data.cartCount);
            
            if (data.cartCount === 0) {
                showEmptyCart();
            } else {
                updatePaymentButtonState(data.cartCount);
            }
        } else {
            SolFoodUtils.showToast(data.message || '삭제에 실패했습니다.', 'error');
        }
    })
    .catch(error => {
        SolFoodUtils.showToast('오류가 발생했습니다.', 'error');
    });
}

// 장바구니 전체 비우기
function clearCart() {
    showConfirmPopup('장바구니를 모두 비우시겠습니까?', () => {
        performClearCart();
    });
}

function performClearCart() {
    
            fetch(UrlConstants.Builder.fullUrl(UrlConstants.API.CART_CLEAR), {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            showEmptyCart();
            SolFoodUtils.updateBadge('.cart-badge, .cart-nav-badge', 0);
            updatePaymentButtonState(0);
        } else {
            SolFoodUtils.showToast(data.message || '장바구니 비우기에 실패했습니다.', 'error');
        }
    });
}

// proceedToOrder 함수는 cart.jsp에서 showOrderComingSoon으로 대체됨

// 장바구니에 메뉴 추가
function addToCart(menuId, quantity = 1) {
    const btn = event ? event.target : null;
    const originalText = btn ? btn.innerHTML : '';

    if (btn) {
        btn.disabled = true;
        btn.innerHTML = '<i class="cart-icon">⏳</i> 추가중...';
    }
    
    fetch(UrlConstants.Builder.fullUrl(UrlConstants.API.CART_ADD), {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `menuId=${menuId}&quantity=${quantity}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            if (btn) {
                btn.innerHTML = '<i class="cart-icon">✅</i> 완료!';
                btn.style.background = '#28a745';
                
                setTimeout(() => {
                    btn.innerHTML = originalText;
                    btn.style.background = '';
                    btn.disabled = false;
                }, 1500);
            }
            
            const cartCount = data.cartCount || data.count || 0;
            if (document.getElementById('bottomCartBar')) {
                setTimeout(() => fetchCartInfo(), 200);
            }

            SolFoodUtils.updateBadge('.cart-badge, .cart-nav-badge', cartCount);
        } else {
            SolFoodUtils.showToast(data.message || '장바구니 추가에 실패했습니다.', 'error');
            if (btn) {
                btn.innerHTML = originalText;
                btn.disabled = false;
            }
        }
    })
    .catch(error => {
        SolFoodUtils.showToast('오류가 발생했습니다.', 'error');
        if (btn) {
            btn.innerHTML = originalText;
            btn.disabled = false;
        }
    });
}

// 옵션이 포함된 메뉴를 장바구니에 추가
function addToCartWithOptions(cartItem) {
    const optionsTotalPrice = Object.values(cartItem.options).reduce((sum, option) => {
        if (Array.isArray(option)) {
            return sum + option.reduce((optSum, opt) => optSum + (opt.price || 0), 0);
        } else {
            return sum + (option.price || 0);
        }
    }, 0);
    
    const unitPriceWithOptions = cartItem.menuPrice + optionsTotalPrice;
    const optionsJson = JSON.stringify(cartItem.options);
    
    const requestBody = `menuId=${cartItem.menuId}&quantity=${cartItem.quantity}&unitPrice=${unitPriceWithOptions}&options=${encodeURIComponent(optionsJson)}`;

    fetch(UrlConstants.Builder.fullUrl(UrlConstants.API.CART_ADD), {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: requestBody
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            SolFoodUtils.setStorage('menuOptions', {
                ...SolFoodUtils.getStorage('menuOptions', {}),
                [`${cartItem.menuId}_${Date.now()}`]: {
                    menuId: cartItem.menuId,
                    menuName: cartItem.menuName,
                    options: cartItem.options,
                    totalPrice: cartItem.totalPrice,
                    timestamp: Date.now()
                }
            });

            if (document.getElementById('bottomCartBar')) {
                setTimeout(() => fetchCartInfo(), 200);
            }

            SolFoodUtils.updateBadge('.cart-badge, .cart-nav-badge', data.cartCount || data.count || 0);
        } else {
            throw new Error(data.message || '장바구니 추가에 실패했습니다.');
        }
    })
    .catch(error => {
        SolFoodUtils.showToast('장바구니 추가 중 오류가 발생했습니다.', 'error');
    });
}

// 하단 카트 바 업데이트
function updateBottomCartBar(count, totalAmount) {
    const cartBar = document.getElementById('bottomCartBar');
    const cartItemCount = document.getElementById('cartItemCount');
    const cartAmount = document.getElementById('cartAmount');
    
    if (!cartBar || !cartItemCount || !cartAmount) {
        return;
    }
    
    if (count > 0) {
        cartItemCount.textContent = count;
        cartAmount.textContent = SolFoodUtils.formatNumber(totalAmount) + '원';
        cartBar.style.display = 'block';
        document.body.classList.add('has-cart-bar');
    } else {
        cartBar.style.display = 'none';
        document.body.classList.remove('has-cart-bar');
    }
}

// 장바구니 페이지로 이동
function goToCart() {
    window.location.href = UrlConstants.Builder.fullUrl(UrlConstants.Pages.CART);
}

// 결제 페이지로 이동
function proceedToPayment() {
    window.location.href = UrlConstants.Builder.fullUrl(UrlConstants.Pages.CART_PAYMENT_METHOD);
}

// 옵션 한글 매핑 상수
const OPTION_MAPPING = {
    // 옵션 이름 매핑
    key: {
        'mocchi': '모찌치',
        'meat': '뼈/순살',
        'spicy': '맵기조절'
    },
    // 옵션 값 매핑
    value: {
        'bone': '뼈',
        'boneless': '순살',
        'mild': '순한맛',
        'medium': '보통맛',
        'hot': '매운맛',
        '1': '1개',
        '2': '2개'
    }
};

// 옵션 정보 표시 함수
function renderOptions() {
    const optionsContainers = document.querySelectorAll('.item-options');
    
    optionsContainers.forEach(container => {
        const menuId = container.dataset.menuId;
        const optionsDataScript = container.querySelector('.options-data');
        const menuExtraScript = container.querySelector('.menu-extra-data');

        if (!optionsDataScript) {
            console.warn(`옵션 데이터를 찾을 수 없습니다. menuId: ${menuId}`);
            return;
        }
        
        try {
            // 옵션 데이터 파싱
            const rawData = optionsDataScript.textContent.trim();
            const selectedOptions = JSON.parse(rawData);

            if (typeof selectedOptions !== 'object' || Array.isArray(selectedOptions)) {
                console.warn(`유효하지 않은 옵션 데이터입니다. menuId: ${menuId}`);
                return;
            }

            // 메뉴 옵션 정보 파싱
            let menuExtra = [];
            if (menuExtraScript) {
                try {
                    menuExtra = JSON.parse(menuExtraScript.textContent.trim());
                } catch (e) {
                    console.warn('메뉴 옵션 정보 파싱 실패:', e);
                }
            }

            // 선택된 옵션들을 배열로 변환
            const selectedOptionsList = [];
            for (const [groupName, selectedValue] of Object.entries(selectedOptions)) {
                // 선택된 값이 배열인 경우 각각 처리
                if (Array.isArray(selectedValue)) {
                    selectedValue.forEach(value => {
                        selectedOptionsList.push({ groupName, value });
                    });
                } else {
                    // 단일 값인 경우
                    selectedOptionsList.push({ groupName, value: selectedValue });
                }
            }

            // 옵션 가격 정보 맵 생성
            const optionPriceMap = {};
            menuExtra.forEach(group => {
                group.options.forEach(opt => {
                    optionPriceMap[opt.name] = opt.price;
                });
            });

            // 옵션 HTML 생성
            let optionsHtml = '<div class="option-group">';

            // 각 선택된 옵션을 개별적으로 표시
            selectedOptionsList.forEach(({ groupName, value }) => {
                const optionPrice = optionPriceMap[value] || 0;
                optionsHtml += `
                    <div class="option-item">
                        <div class="option-info">
                            <i class="bi bi-plus-circle-fill"></i>
                            <span class="option-name">${groupName} : ${value}</span>
                        </div>
                        <span class="option-price">${optionPrice > 0 ? `(+${formatPrice(optionPrice)}원)` : ''}</span>
                    </div>
                `;
            });

            optionsHtml += '</div>';

            // 옵션 컨테이너 업데이트
            container.innerHTML = optionsHtml;

        } catch (error) {
            console.error(`옵션 데이터 파싱 중 오류 발생:`, error);
            container.innerHTML = '<div class="error-message">옵션 정보를 불러올 수 없습니다.</div>';
        }
    });
}

// 가격 포맷팅 함수
function formatPrice(price) {
    return new Intl.NumberFormat('ko-KR').format(price);
}

// 페이지 로드 시 옵션 렌더링
document.addEventListener('DOMContentLoaded', () => {
    renderOptions();
});

// 카트 정보 가져오기
function fetchCartInfo() {
            fetch(UrlConstants.Builder.fullUrl(UrlConstants.API.CART_TOTAL))
        .then(response => response.json())
        .then(data => {
            const count = data.count || 0;
            const totalAmount = data.totalAmount || 0;

            SolFoodUtils.updateBadge('.cart-badge, .cart-nav-badge', count);
            updateBottomCartBar(count, totalAmount);
        })
        .catch(error => {
            console.error('장바구니 정보 로드 실패:', error);
        });
}

// DOM 업데이트 헬퍼 함수들

function restoreQuantityInput(menuId) {
    const quantityInput = document.querySelector(`[data-menu-id="${menuId}"] .quantity-input`);
    if (quantityInput) {
        quantityInput.value = quantityInput.defaultValue || 1;
    }
}

function updateCartItemDisplay(menuId, quantity, totalAmount, cartCount) {
    const cartItem = document.querySelector(`[data-menu-id="${menuId}"]`);
    if (!cartItem) return;
    const totalPriceElement = cartItem.querySelector('.fw-bold');
    if (totalPriceElement) {
        // 서버에서 내려준 totalPrice를 그대로 사용
        const totalPrice = cartItem.getAttribute('data-total-price');
        if (totalPrice) {
            totalPriceElement.textContent = SolFoodUtils.formatNumber(parseInt(totalPrice)) + '원';
        }
    }
    
    SolFoodUtils.updateBadge('.cart-badge, .cart-nav-badge', cartCount);
}

function updateCartSummary(totalAmount, cartCount) {
    const totalAmountElement = document.querySelector('.total-amount');
    if (totalAmountElement) {
        totalAmountElement.textContent = SolFoodUtils.formatNumber(totalAmount) + '원';
    }
    
    const totalQuantityElement = document.querySelector('.cart-summary small');
    if (totalQuantityElement) {
        totalQuantityElement.textContent = `총 ${cartCount}개 상품`;
    }
    
    updateBottomCartBar(cartCount, totalAmount);
}

function removeCartItemFromDOM(menuId) {
    const cartItem = document.querySelector(`[data-menu-id="${menuId}"]`);
    if (cartItem) {
        cartItem.style.transition = 'opacity 0.3s ease-out';
        cartItem.style.opacity = '0';
        
        setTimeout(() => {
            cartItem.remove();
        }, 300);
    }
}

function showEmptyCart() {
    const cartContainer = document.querySelector('.cart-container');
    if (!cartContainer) return;
    
    const headerElement = cartContainer.querySelector('.cart-header');
    let headerHTML = '';
    if (headerElement) {
        headerHTML = headerElement.outerHTML;
    }
    
    cartContainer.innerHTML = headerHTML + `
        <div class="empty-cart">
            <i class="bi bi-cart-x"></i>
            <h4>장바구니가 비어있습니다</h4>
            <p class="text-muted">맛있는 메뉴를 담아보세요!</p>
            <a href="${contextPath}/user/store" class="btn btn-primary btn-lg mt-3">
                <i class="bi bi-shop"></i> 가게 둘러보기
            </a>
        </div>
    `;
    
    // 결제 버튼 비활성화
    disablePaymentButton();
}

// 결제 버튼 활성화
function enablePaymentButton() {
    const paymentBtn = document.getElementById('paymentBtn');
    if (paymentBtn) {
        paymentBtn.disabled = false;
        paymentBtn.classList.remove('disabled');
    }
}

// 결제 버튼 비활성화
function disablePaymentButton() {
    const paymentBtn = document.getElementById('paymentBtn');
    if (paymentBtn) {
        paymentBtn.disabled = true;
        paymentBtn.classList.add('disabled');
    }
}

// 장바구니 상태에 따라 결제 버튼 상태 업데이트
function updatePaymentButtonState(cartCount) {
    if (cartCount > 0) {
        enablePaymentButton();
    } else {
        disablePaymentButton();
    }
}

// 페이지 로드 시 장바구니 정보 조회
document.addEventListener('DOMContentLoaded', function() {
    // 장바구니 페이지인 경우 옵션 표시
    if (document.querySelector('.item-options')) {
        renderOptions();
    }
}); 