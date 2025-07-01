/**
 * ==========================================
 * 장바구니 JavaScript 
 * ==========================================
 * Sol-Food 프로젝트의 장바구니 관련 기능
 */

// 수량 변경 (+/- 버튼)
function changeQuantity(menuId, change) {
    const numMenuId = parseInt(menuId);
    const quantityInput = document.querySelector(`[data-menu-id="${numMenuId}"] .quantity-input`);
    const currentQuantity = parseInt(quantityInput.value);
    const newQuantity = currentQuantity + change;
    
    if (newQuantity < 1) {
        if (confirm('수량이 0이 되면 상품이 삭제됩니다. 계속하시겠습니까?')) {
            removeItem(numMenuId);
        }
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
    
    fetch(UrlConstants.Builder.fullUrl('/user/cart/update'), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `menuId=${numMenuId}&quantity=${numQuantity}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            location.reload(); // 페이지 새로고침으로 금액 업데이트
        } else {
            alert(data.message || '수량 변경에 실패했습니다.');
            location.reload();
        }
    })
    .catch(error => {
        alert('오류가 발생했습니다.');
        location.reload();
    });
}

// 장바구니 아이템 삭제
function removeItem(menuId) {
    if (!confirm('이 상품을 장바구니에서 삭제하시겠습니까?')) {
        return;
    }
    
    const numMenuId = parseInt(menuId);
    
    fetch(UrlConstants.Builder.fullUrl('/user/cart/remove'), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `menuId=${numMenuId}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            location.reload(); // 페이지 새로고침
        } else {
            alert(data.message || '삭제에 실패했습니다.');
        }
    })
    .catch(error => {
        alert('오류가 발생했습니다.');
    });
}

// 장바구니 전체 비우기
function clearCart() {
    if (!confirm('장바구니를 모두 비우시겠습니까?')) {
        return;
    }
    
    fetch(UrlConstants.Builder.fullUrl('/user/cart/clear'), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            location.reload();
        } else {
            alert(data.message || '장바구니 비우기에 실패했습니다.');
        }
    })
    .catch(error => {
        alert('오류가 발생했습니다.');
    });
}

// proceedToOrder 함수는 cart.jsp에서 showOrderComingSoon으로 대체됨

// 장바구니에 메뉴 추가 (다른 페이지에서 호출용)
function addToCart(menuId, quantity = 1) {
    const btn = event ? event.target : null;
    const originalText = btn ? btn.innerHTML : '';
    
    // 버튼 비활성화 및 로딩 표시
    if (btn) {
        btn.disabled = true;
        btn.innerHTML = '<i class="cart-icon">⏳</i> 추가중...';
    }
    
    fetch(UrlConstants.Builder.fullUrl('/user/cart/add'), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `menuId=${menuId}&quantity=${quantity}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            // 성공 애니메이션
            if (btn) {
                btn.innerHTML = '<i class="cart-icon">✅</i> 완료!';
                btn.style.background = '#28a745';
                
                setTimeout(() => {
                    btn.innerHTML = originalText;
                    btn.style.background = '';
                    btn.disabled = false;
                }, 1500);
            }
            
            // 가게 상세페이지에서 하단 카트 바 업데이트 (우선)
            if (document.getElementById('bottomCartBar')) {
                setTimeout(() => fetchCartInfo(), 200); // 약간의 지연 후 업데이트
            }
            
            // 기본 장바구니 개수 업데이트
            updateCartBadge(data.cartCount || data.count || 0);
        } else {
            alert(data.message || '장바구니 추가에 실패했습니다.');
            if (btn) {
                btn.innerHTML = originalText;
                btn.disabled = false;
            }
        }
    })
    .catch(error => {
        console.error('장바구니 추가 오류:', error);
        alert('오류가 발생했습니다.');
        if (btn) {
            btn.innerHTML = originalText;
            btn.disabled = false;
        }
    });
}

// 옵션이 포함된 메뉴를 장바구니에 추가 (메뉴 모달에서 호출용)
function addToCartWithOptions(cartItem) {
    console.log('🍽️ 옵션 포함 장바구니 추가:', cartItem);
    
    // 옵션 가격을 포함한 단가 계산 (수량 1개당 가격)
    const optionsTotalPrice = Object.values(cartItem.options).reduce((sum, option) => {
        if (Array.isArray(option)) {
            // 체크박스 옵션의 경우
            return sum + option.reduce((optSum, opt) => optSum + (opt.price || 0), 0);
        } else {
            // 라디오 옵션의 경우
            return sum + (option.price || 0);
        }
    }, 0);
    
    const unitPriceWithOptions = cartItem.menuPrice + optionsTotalPrice;
    console.log(`💰 기본가격: ${cartItem.menuPrice}원, 옵션가격: ${optionsTotalPrice}원, 총 단가: ${unitPriceWithOptions}원`);
    
    // 옵션 정보를 JSON 문자열로 변환
    const optionsJson = JSON.stringify(cartItem.options);
    console.log(`🔧 옵션 정보: ${optionsJson}`);
    
    // 옵션이 포함된 가격과 정보로 장바구니에 추가
    const requestBody = `menuId=${cartItem.menuId}&quantity=${cartItem.quantity}&unitPrice=${unitPriceWithOptions}&options=${encodeURIComponent(optionsJson)}`;
    
    fetch(UrlConstants.Builder.fullUrl('/user/cart/add'), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: requestBody
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            // 옵션 정보를 로컬 스토리지에 저장 (향후 확장용)
            saveMenuOptionsToStorage(cartItem);
            
            // 가게 상세페이지에서 하단 카트 바 업데이트 (우선)
            if (document.getElementById('bottomCartBar')) {
                setTimeout(() => fetchCartInfo(), 200); // 약간의 지연 후 업데이트
            }
            
            // 기본 장바구니 개수 업데이트
            updateCartBadge(data.cartCount || data.count || 0);
            
            console.log('장바구니에 옵션과 함께 추가됨:', cartItem);
        } else {
            throw new Error(data.message || '장바구니 추가에 실패했습니다.');
        }
    })
    .catch(error => {
        console.error('옵션 포함 장바구니 추가 오류:', error);
        alert('장바구니 추가 중 오류가 발생했습니다.');
    });
}

// 메뉴 옵션 정보를 로컬 스토리지에 저장 (임시 구현)
function saveMenuOptionsToStorage(cartItem) {
    try {
        const storageKey = 'menuOptions';
        const existingOptions = JSON.parse(localStorage.getItem(storageKey) || '{}');
        
        // 메뉴ID + 옵션 조합으로 키 생성
        const optionKey = `${cartItem.menuId}_${Date.now()}`;
        existingOptions[optionKey] = {
            menuId: cartItem.menuId,
            menuName: cartItem.menuName,
            options: cartItem.options,
            totalPrice: cartItem.totalPrice,
            timestamp: Date.now()
        };
        
        localStorage.setItem(storageKey, JSON.stringify(existingOptions));
    } catch (error) {
        console.warn('옵션 정보 저장 실패:', error);
    }
}

// 장바구니 개수 배지 업데이트 (통합 함수)
function updateCartBadge(count) {
    // 하단 네비게이션 배지 (store.js용)
    const navBadge = document.querySelector('.cart-nav-badge'); 
    if (navBadge) {
        navBadge.textContent = count;
        if (count > 0) {
            navBadge.classList.remove('hidden');
        } else {
            navBadge.classList.add('hidden');
        }
    }
    
    // 상단 헤더 배지 (storedetail.js용)
    const headerBadge = document.querySelector('.cart-badge');
    if (headerBadge) {
        headerBadge.textContent = count;
        headerBadge.style.display = count > 0 ? 'flex' : 'none';
    }
    
    // 기타 카운트 표시
    const cartCount = document.querySelector('.cart-count');
    if (cartCount) {
        cartCount.textContent = count;
    }
}

// 하단 카트 바 업데이트 (가게 상세페이지용)
function updateBottomCartBar(count, totalAmount) {
    console.log(`📱 하단 카트 바 업데이트: ${count}개, ${totalAmount}원`);
    
    const cartBar = document.getElementById('bottomCartBar');
    const cartItemCount = document.getElementById('cartItemCount');
    const cartAmount = document.getElementById('cartAmount');
    
    console.log('📱 카트 바 요소들:', { cartBar: !!cartBar, cartItemCount: !!cartItemCount, cartAmount: !!cartAmount });
    
    if (!cartBar || !cartItemCount || !cartAmount) {
        console.warn('⚠️ 카트 바 요소를 찾을 수 없음');
        return;
    }
    
    if (count > 0) {
        cartItemCount.textContent = count;
        cartAmount.textContent = formatPriceKorean(totalAmount) + '원';
        cartBar.style.display = 'block';
        document.body.classList.add('has-cart-bar');
        console.log('✅ 하단 카트 바 표시됨');
    } else {
        cartBar.style.display = 'none';
        document.body.classList.remove('has-cart-bar');
        console.log('❌ 하단 카트 바 숨김');
    }
}

// 한국어 가격 포맷팅
function formatPriceKorean(price) {
    return price.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',');
}

// 장바구니 페이지로 이동
function goToCart() {
    window.location.href = UrlConstants.Builder.fullUrl('/user/cart');
}

// 카트 정보 가져오기 (상세페이지용)
function fetchCartInfo() {
    console.log('🛒 장바구니 정보 조회 시작...');
    
    fetch(UrlConstants.Builder.fullUrl('/user/cart/total'))
        .then(response => response.json())
        .then(data => {
            console.log('🛒 장바구니 데이터:', data);
            
            const count = data.count || 0;
            const totalAmount = data.totalAmount || 0;
            
            console.log(`🛒 업데이트: ${count}개, ${totalAmount}원`);
            
            updateCartBadge(count);
            updateBottomCartBar(count, totalAmount);
        })
        .catch(error => {
            console.error('❌ 장바구니 정보 로드 실패:', error);
        });
}

// 페이지 로드 시 장바구니 정보 조회
document.addEventListener('DOMContentLoaded', function() {
    // 가게 상세페이지에서는 총 금액도 함께 조회
    if (document.getElementById('bottomCartBar')) {
        fetchCartInfo();
    } else {
        // 다른 페이지에서는 개수만 조회
        fetch(UrlConstants.Builder.fullUrl('/user/cart/count'))
            .then(response => response.json())
            .then(data => {
                updateCartBadge(data.count || 0);
            })
            .catch(error => {
                // 로그인하지 않은 경우 등은 무시
            });
    }
}); 