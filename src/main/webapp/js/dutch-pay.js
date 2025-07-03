/**
 * 더치페이 JavaScript - 서버 기반 분할 계산
 * common-utils.js 활용으로 경량화
 */
let participants = [];
let cartData = null;

document.addEventListener('DOMContentLoaded', function() {
    initializeDutchPay();
});

function initializeDutchPay() {
    loadSelectedFriends();
    loadCartInfo();
    setupDutchPayEvents();
}

async function loadSelectedFriends() {
    try {
        const data = await SolFoodUtils.syncToServer('/user/cart/get-selected-friends', 'GET', null);
        if (data.result === 'success') {
            participants = data.friends;
            displayParticipants();
        } else {
            SolFoodUtils.showToast('친구 정보 로드에 실패했습니다.', 'error');
        }
    } catch (error) {
        SolFoodUtils.showToast('친구 정보 로드 중 오류가 발생했습니다.', 'error');
    }
}

async function loadCartInfo() {
    try {
        const response = await fetch(UrlConstants.Builder.fullUrl('/user/cart/total'), {
            method: 'GET',
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        });
        const data = await response.json();
        
        if (data.count !== undefined) {
            cartData = {
                totalAmount: data.totalAmount || 0,
                itemCount: data.count || 0
            };
            displayCartInfo();
        } else {
            SolFoodUtils.showToast('장바구니 정보 로드에 실패했습니다.', 'error');
        }
    } catch (error) {
        SolFoodUtils.showToast('장바구니 정보 로드 중 오류가 발생했습니다.', 'error');
    }
}

function setupDutchPayEvents() {
    const equalBtn = document.getElementById('equalPayBtn');
    if (equalBtn) {
        equalBtn.addEventListener('click', () => calculateDutchPay('equal'));
    }
    
    const randomBtn = document.getElementById('randomPayBtn');
    if (randomBtn) {
        randomBtn.addEventListener('click', () => calculateDutchPay('random'));
    }
    
    const recalculateBtn = document.getElementById('recalculateBtn');
    if (recalculateBtn) {
        recalculateBtn.addEventListener('click', function() {
            const method = this.getAttribute('data-method') || 'equal';
            calculateDutchPay(method);
        });
    }
}

function displayParticipants() {
    const container = document.getElementById('participantsContainer');
    if (!container || !participants || participants.length === 0) return;
    
    let html = '<h5><i class="bi bi-people-fill"></i> 참여자 (' + participants.length + '명)</h5>';
    html += '<div class="participants-list">';
    
    participants.forEach(participant => {
        const isCurrentUser = participant.usersEmail === 'CURRENT_USER';
        const profileImg = participant.usersProfile ? 
            `<img src="${participant.usersProfile}" alt="${participant.usersName}" class="participant-avatar">` :
            `<div class="participant-avatar">${participant.usersName.substring(0, 1)}</div>`;
        
        html += `
            <div class="participant-item ${isCurrentUser ? 'current-user' : ''}">
                ${profileImg}
                <div class="participant-info">
                    <div class="participant-name">${participant.usersName} ${isCurrentUser ? '(나)' : ''}</div>
                    <div class="participant-company">${participant.companyName} - ${participant.departmentName}</div>
                </div>
                ${isCurrentUser ? '<i class="bi bi-star-fill text-warning"></i>' : ''}
            </div>
        `;
    });
    
    html += '</div>';
    container.innerHTML = html;
}

function displayCartInfo() {
    const container = document.getElementById('cartInfoContainer');
    if (!container || !cartData) return;
    
    const html = `
        <div class="cart-summary">
            <h5><i class="bi bi-cart3"></i> 주문 정보</h5>
            <div class="d-flex justify-content-between">
                <span>총 상품 수:</span>
                <span class="fw-bold">${cartData.itemCount}개</span>
            </div>
            <div class="d-flex justify-content-between mt-2">
                <span class="h6">총 결제 금액:</span>
                <span class="h5 text-primary fw-bold">${SolFoodUtils.formatNumber(cartData.totalAmount)}원</span>
            </div>
        </div>
    `;
    
    container.innerHTML = html;
}

async function calculateDutchPay(method) {
    if (!participants || participants.length === 0) {
        SolFoodUtils.showToast('참여자 정보가 없습니다.', 'warning');
        return;
    }
    
    if (!cartData || cartData.totalAmount === 0) {
        SolFoodUtils.showToast('장바구니 정보가 없습니다.', 'warning');
        return;
    }
    
    SolFoodUtils.showLoading('#paymentResultContainer');
    
    try {
        const participantIds = participants.map(p => p.usersId.toString());
        const requestData = {
            participantIds: participantIds,
            paymentMethod: method
        };
        
        const data = await SolFoodUtils.syncToServer('/user/cart/calculate-dutch-pay', 'POST', requestData);
        
        if (data.result === 'success') {
            displayPaymentResult(data, method);
        } else {
            SolFoodUtils.showToast('더치페이 계산에 실패했습니다: ' + data.message, 'error');
        }
    } catch (error) {
        console.error('더치페이 계산 오류:', error);
        SolFoodUtils.showToast('서버 통신 중 오류가 발생했습니다.', 'error');
    }
}

function displayPaymentResult(data, method) {
    const container = document.getElementById('paymentResultContainer');
    if (!container) return;
    
    const methodText = method === 'equal' ? '균등 분할' : '랜덤 분할';
    
    let html = `
        <div class="payment-result">
            <div class="result-header">
                <h5><i class="bi bi-calculator"></i> ${methodText} 결과</h5>
                <button class="btn btn-outline-primary btn-sm" id="recalculateBtn" data-method="${method}">
                    <i class="bi bi-arrow-clockwise"></i> 재계산
                </button>
            </div>
            
            <div class="result-summary">
                <div class="row text-center">
                    <div class="col-4">
                        <div class="summary-item">
                            <div class="summary-value">${SolFoodUtils.formatNumber(data.totalAmount)}원</div>
                            <div class="summary-label">총 금액</div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="summary-item">
                            <div class="summary-value">${data.participantCount}명</div>
                            <div class="summary-label">참여자</div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="summary-item">
                            <div class="summary-value">${methodText}</div>
                            <div class="summary-label">분할 방식</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="payment-list">
                <h6><i class="bi bi-credit-card"></i> 개별 결제 금액</h6>
    `;
    
    const sortedPayments = data.paymentList.sort((a, b) => b.amount - a.amount);
    
    sortedPayments.forEach((payment, index) => {
        const isCurrentUser = payment.isCurrentUser;
        const profileImg = payment.userProfile ? 
            `<img src="${payment.userProfile}" alt="${payment.userName}" class="payment-avatar">` :
            `<div class="payment-avatar">${payment.userName.substring(0, 1)}</div>`;
        
        const rankIcon = index === 0 ? '<i class="bi bi-award-fill text-warning"></i>' : 
                        index === sortedPayments.length - 1 ? '<i class="bi bi-heart-fill text-danger"></i>' : '';
        
        html += `
            <div class="payment-item ${isCurrentUser ? 'current-user-payment' : ''}">
                <div class="d-flex align-items-center">
                    ${profileImg}
                    <div class="payment-info flex-grow-1">
                        <div class="payment-name">
                            ${payment.userName} ${isCurrentUser ? '(나)' : ''}
                            ${rankIcon}
                        </div>
                        <div class="payment-amount">${SolFoodUtils.formatNumber(payment.amount)}원</div>
                    </div>
                    ${isCurrentUser ? '<i class="bi bi-star-fill text-warning"></i>' : ''}
                </div>
            </div>
        `;
    });
    
    html += `
            </div>
            
            <div class="result-actions">
                <button class="btn btn-success btn-lg w-100" onclick="proceedToPayment()">
                    <i class="bi bi-credit-card"></i> 결제 진행하기
                </button>
            </div>
        </div>
    `;
    
    container.innerHTML = html;
    setupDutchPayEvents();
}

function proceedToPayment() {
    SolFoodUtils.showToast('결제 시스템으로 이동합니다. (미구현)', 'info');
}

window.calculateDutchPay = calculateDutchPay;
window.proceedToPayment = proceedToPayment; 