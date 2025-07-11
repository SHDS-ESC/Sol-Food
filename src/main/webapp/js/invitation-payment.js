// 초대받은 결제 페이지 JavaScript
document.addEventListener('DOMContentLoaded', function() {
    loadInvitations();
});

// 초대 목록 로드
async function loadInvitations() {
    const loadingEl = document.getElementById('loading');
    const invitationListEl = document.getElementById('invitationList');
    const emptyStateEl = document.getElementById('emptyState');
    
    try {
        loadingEl.style.display = 'block';
        invitationListEl.style.display = 'none';
        emptyStateEl.style.display = 'none';
        
        const response = await fetch(`${window.contextPath}/user/invitations/api`, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
            }
        });
        
        const data = await response.json();
        
        if (data.success) {
            if (data.invitations && data.invitations.length > 0) {
                renderInvitations(data.invitations);
                invitationListEl.style.display = 'block';
            } else {
                emptyStateEl.style.display = 'block';
            }
        } else {
            showError('초대 목록을 불러오는데 실패했습니다: ' + data.message);
            emptyStateEl.style.display = 'block';
        }
    } catch (error) {
        console.error('Error loading invitations:', error);
        showError('초대 목록을 불러오는데 실패했습니다.');
        emptyStateEl.style.display = 'block';
    } finally {
        loadingEl.style.display = 'none';
    }
}

// 초대 목록 렌더링
function renderInvitations(invitations) {
    const invitationListEl = document.getElementById('invitationList');
    
    const invitationCards = invitations.map(invitation => {
        return createInvitationCard(invitation);
    }).join('');
    
    invitationListEl.innerHTML = invitationCards;
}

// 초대 카드 생성
function createInvitationCard(invitation) {
    // 백엔드에서 계산된 만료 여부 사용
    const isExpired = invitation.isExpired || false;
    const statusClass = getStatusClass(invitation.status);
    const statusText = getStatusText(invitation.status);
    
    return `
        <div class="invitation-card ${isExpired ? 'expired' : ''}" data-payment-id="${invitation.paymentId}">
            <div class="card-header">
                <div>
                    <h3>${invitation.storeName || '알 수 없는 매장'}</h3>
                    <p>발의자: ${invitation.leaderName || '알 수 없음'}</p>
                </div>
                <span class="status-badge ${statusClass}">${statusText}</span>
            </div>
            
            <div class="card-content">
                <div class="store-info">
                    <div class="store-icon">
                        <i class="bi bi-shop"></i>
                    </div>
                    <div class="store-details">
                        <h4>${invitation.storeName || '매장명 없음'}</h4>
                        <p>${invitation.storeAddress || '주소 정보 없음'}</p>
                    </div>
                </div>
                
                <div class="payment-details">
                    <div class="detail-item">
                        <span class="detail-label">내 결제 금액</span>
                        <span class="detail-value amount">${formatCurrency(invitation.amount)}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">총 결제 금액</span>
                        <span class="detail-value">${formatCurrency(invitation.totalAmount)}</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">참여자 수</span>
                        <span class="detail-value">${invitation.participantCount}명</span>
                    </div>
                    <div class="detail-item">
                        <span class="detail-label">생성일</span>
                        <span class="detail-value">${formatDate(invitation.createdAt)}</span>
                    </div>
                </div>
                
                ${invitation.participants && invitation.participants.length > 0 ? `
                <div class="participants-info">
                    <h5>참여자 목록</h5>
                    <div class="participant-list">
                        ${invitation.participants.map(participant => 
                            `<span class="participant-tag">${participant.name || '알 수 없음'}</span>`
                        ).join('')}
                    </div>
                </div>
                ` : ''}
            </div>
            
            <div class="card-actions">
                ${getActionButtons(invitation, isExpired)}
            </div>
        </div>
    `;
}

// 액션 버튼 생성
function getActionButtons(invitation, isExpired) {
    if (isExpired) {
        return `
            <button class="btn btn-secondary" disabled>
                <i class="bi bi-clock"></i>
                만료됨
            </button>
        `;
    }
    
    switch (invitation.status) {
        case 'pending':
            return `
                <button class="btn btn-primary" onclick="proceedToPayment(${invitation.paymentId})">
                    <i class="bi bi-credit-card"></i>
                    결제하기
                </button>
                <button class="btn btn-danger" onclick="rejectInvitation(${invitation.paymentId})">
                    <i class="bi bi-x-circle"></i>
                    거절하기
                </button>
            `;
        case 'accepted':
            return `
                <button class="btn btn-secondary" disabled>
                    <i class="bi bi-check-circle"></i>
                    수락됨
                </button>
            `;
        case 'rejected':
            return `
                <button class="btn btn-secondary" disabled>
                    <i class="bi bi-x-circle"></i>
                    거절됨
                </button>
            `;
        default:
            return `
                <button class="btn btn-secondary" disabled>
                    <i class="bi bi-question-circle"></i>
                    알 수 없음
                </button>
            `;
    }
}

// 결제 페이지로 이동
function proceedToPayment(paymentId) {
    // waiting-approval 페이지로 이동하면서 participant 역할로 설정
    const url = `${window.contextPath}/user/cart/waiting-approval?role=participant&paymentId=${paymentId}`;
    window.location.href = url;
}

// 초대 거절
async function rejectInvitation(paymentId) {
    if (!confirm('정말로 이 초대를 거절하시겠습니까?')) {
        return;
    }
    
    try {
        const response = await fetch(`${window.contextPath}/user/cart/invitation/respond`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `response=reject&paymentId=${paymentId}`
        });
        
        const data = await response.json();
        
        if (data.result === 'success') {
            showSuccess('초대를 거절했습니다.');
            loadInvitations(); // 목록 새로고침
        } else {
            showError('초대 거절에 실패했습니다: ' + data.message);
        }
    } catch (error) {
        console.error('Error rejecting invitation:', error);
        showError('초대 거절에 실패했습니다.');
    }
}

// 유틸리티 함수들
// 백엔드에서 만료 여부를 계산하므로 더 이상 필요하지 않음
// function isInvitationExpired(createdAt) {
//     console.log('Checking expiration for createdAt:', createdAt);
//     
//     // createdAt이 null이거나 undefined인 경우 만료되지 않음으로 처리
//     if (!createdAt) {
//         console.log('createdAt is null/undefined, treating as not expired');
//         return false;
//     }
//     
//     const createdTime = new Date(createdAt).getTime();
//     const currentTime = new Date().getTime();
//     const thirtyMinutes = 30 * 60 * 1000; // 30분
//     
//     console.log('Created time:', new Date(createdTime));
//     console.log('Current time:', new Date(currentTime));
//     console.log('Time difference (minutes):', (currentTime - createdTime) / (1000 * 60));
//     
//     const isExpired = (currentTime - createdTime) > thirtyMinutes;
//     console.log('Is expired:', isExpired);
//     
//     return isExpired;
// }

function getStatusClass(status) {
    switch (status) {
        case 'pending': return 'pending';
        case 'accepted': return 'accepted';
        case 'rejected': return 'rejected';
        default: return 'pending';
    }
}

function getStatusText(status) {
    switch (status) {
        case 'pending': return '대기중';
        case 'accepted': return '수락됨';
        case 'rejected': return '거절됨';
        default: return '알 수 없음';
    }
}

function formatCurrency(amount) {
    return new Intl.NumberFormat('ko-KR').format(amount) + '원';
}

function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('ko-KR', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
    });
}

// 알림 함수들
function showSuccess(message) {
    // 간단한 성공 알림 (실제 구현에서는 더 정교한 알림 시스템 사용)
    alert('성공: ' + message);
}

function showError(message) {
    // 간단한 에러 알림 (실제 구현에서는 더 정교한 알림 시스템 사용)
    alert('오류: ' + message);
} 