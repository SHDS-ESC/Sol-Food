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
            
            // 장바구니 개수 업데이트
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

// 페이지 로드 시 장바구니 개수 조회
document.addEventListener('DOMContentLoaded', function() {
    fetch(UrlConstants.Builder.fullUrl('/user/cart/count'))
        .then(response => response.json())
        .then(data => {
            updateCartBadge(data.count || 0);
        })
        .catch(error => {
            // 로그인하지 않은 경우 등은 무시
        });
}); 