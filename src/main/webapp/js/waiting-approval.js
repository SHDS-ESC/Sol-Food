// 수락 대기 페이지 JavaScript
let acceptedFriends = 0;
let selectedFriendsData = [];
let totalAmount = 0;
let splitAmounts = {};
let sseStarted = false; // 폴링 시작 플래그

// 참여자 화면인지 확인하는 함수
function isParticipantView() {
    return window.userRole === 'participant';
}

// 여러 방법으로 페이지 로드 감지
document.addEventListener('DOMContentLoaded', initializePage);
window.addEventListener('load', initializePage);

// 즉시 실행도 시도
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializePage);
} else {
    initializePage();
}

// 페이지 로드시 API로 데이터 받아오기
function initializePage() {
    console.log('💰 결제 대기 페이지 초기화 시작');
    // 게임 결과 확인 및 처리
    const gameResult = getGameResultFromURL();
    if (gameResult) {
        console.log('🎮 게임 결과 감지됨:', gameResult);
        // URL에서 gameResult 파라미터 제거
        removeGameResultFromURL();
    }

    loadWaitingApprovalData();

    // 게임 결과가 있다면 적용
    if (gameResult) {
        setTimeout(() => {
            applyGameResult(gameResult);
        }, 500); // 데이터 로드 후 적용
    }

    // 결제 상태 폴링 시작
    // startPaymentStatusMonitoring();

    updateProgress();
    
    // 초기 로드 시 전체 결제 완료 여부 체크
    setTimeout(() => {
        checkInitialPaymentStatus();
    }, 1000); // 1초 후 체크
}

/**
 * 초기 로드 시 전체 결제 완료 여부 체크
 */
async function checkInitialPaymentStatus() {
    console.log('🔍 초기 결제 상태 체크 시작');
    
    try {
        // 역할에 따라 다른 API 호출
        let apiUrl;
        if (isParticipantView()) {
            apiUrl = window.UrlConstants.Builder.fullUrl(`/payments/payment/${window.paymentId}`);
        } else {
            apiUrl = window.UrlConstants.Builder.fullUrl('/user/cart/waiting-approval-data');
        }
        
        const response = await fetch(apiUrl);
        const data = await response.json();
        
        if (data.result === 'success' || data.success) {
            if (data.participants && data.participants.length > 0) {
                updateParticipantsFromResponse(data);
                
                // 전체 결제 완료 여부 확인
                const isAllCompleted = checkAllPaymentsCompleted();
                
                if (isAllCompleted) {
                    console.log('🎉 초기 체크: 모든 결제 완료!');
                    changeRefreshButtonToPaymentHistory();
                }
            }
        } else {
            // 진행 중인 결제가 없으면 payment-history로 리다이렉트
            if (data.result === 'error' && data.message === '진행 중인 결제가 없습니다.') {
                console.log('🔍 초기 체크: 진행 중인 결제가 없음, payment-history로 리다이렉트');
                window.location.href = UrlConstants.Builder.fullUrl('/user/mypage/payment-history');
                return;
            }
        }
    } catch (error) {
        console.error('❌ 초기 결제 상태 체크 오류:', error);
    }
}

// 페이지 로드 시 선택된 친구들 정보 로드
async function loadWaitingApprovalData() {
    try {
        // 사용자 역할에 따라 다른 API 호출
        let apiUrl;
        if (isParticipantView()) {
            // 참여자 역할: 특정 paymentId로 결제 정보 조회
            apiUrl = window.UrlConstants.Builder.fullUrl(`/payments/payment/${window.paymentId}`)
            // 참여자는 결제 정보만 조회하고, 전체 목록은 조회하지 않음
            await loadParticipantPaymentData(apiUrl);
            return;
        } else {
            // 발의자 역할: 기존 API 사용
            apiUrl = window.UrlConstants.Builder.fullUrl('/user/cart/waiting-approval-data');
        }
        
        const res = await fetch(apiUrl);
        const data = await res.json();
        if (data.result === 'success' && data.participants && data.participants.length > 0) {
            // 발의자 역할: API에서 받은 데이터를 그대로 사용 (이제 paymentStatus 포함)
            selectedFriendsData = data.participants;
            totalAmount = data.totalAmount;
            displayFriends();
            updateTotalAmountDisplay();
        } else {
            // 진행 중인 결제가 없으면 payment-history로 리다이렉트
            if (data.result === 'error' && data.message === '진행 중인 결제가 없습니다.') {
                console.log('🔍 진행 중인 결제가 없음, payment-history로 리다이렉트');
                window.location.href = UrlConstants.Builder.fullUrl('/user/mypage/payment-history');
                return;
            }
            displayNoFriends();
        }
    } catch (error) {
        console.error('대기 데이터 로드 오류:', error);
        displayNoFriends();
    }
}

// 참여자용 결제 데이터 로드
async function loadParticipantPaymentData(apiUrl) {
    try {
        // Payment ID로 결제 정보 조회 (이제 모든 참여자 정보도 함께 받아옴)
        const paymentResponse = await fetch(apiUrl);
        const paymentData = await paymentResponse.json();
        console.log('참여자용 결제 데이터:', paymentData);
        
        if (paymentData.success && paymentData.payment) {
            const payment = paymentData.payment;
            const participants = paymentData.participants || [];
            const totalAmount = paymentData.totalAmount || 0;
            
            // 참여자 데이터를 selectedFriendsData 형식으로 변환
            selectedFriendsData = participants.map(participant => ({
                usersId: participant.usersId,
                usersName: participant.usersName,
                usersProfile: participant.usersProfile,
                companyName: participant.companyName,
                departmentName: participant.departmentName,
                paymentAmount: participant.paymentAmount,
                paymentStatus: participant.paymentStatus,
                paymentId: participant.paymentId
            }));
            
            // 총 금액 설정
            // totalAmount = totalAmount;
            
            // 발의자 화면과 동일한 방식으로 표시
            displayFriends();
            updateTotalAmountDisplay();
            
            // 제목과 설명 변경
            const statusTitle = document.getElementById('statusTitle');
            const statusDesc = document.getElementById('statusDesc');
            
            if (statusTitle) {
                statusTitle.textContent = '참여자 결제';
            }
            if (statusDesc) {
                statusDesc.innerHTML = '초대받은 그룹 결제에<br>참여하여 결제를 진행해주세요';
            }
        } else {
            displayNoFriends();
        }
    } catch (error) {
        console.error('참여자 결제 데이터 로드 오류:', error);
        displayNoFriends();
    }
}

// 가격 분할 계산
function calculateSplitAmounts() {
    if (totalAmount <= 0 || selectedFriendsData.length === 0) {
        return;
    }
    
    const totalPeople = selectedFriendsData.length;
    const baseAmount = Math.floor(totalAmount / totalPeople); // 기본 분할 금액
    const remainder = totalAmount % totalPeople; // 나머지
    
    // 현재 사용자 ID 찾기
    const currentUserId = window.currentUserId;
    const currentUserCompanyName = window.currentUserCompanyName;
    const currentUserDepartmentName = window.currentUserDepartmentName;
    const currentUserEmail = window.currentUserEmail;
    const currentUserNickname = window.currentUserNickname;
    const currentUserTel = window.currentUserTel;
    
    // 각 사용자에게 기본 금액 배정
    selectedFriendsData.forEach(friend => {
        splitAmounts[friend.usersId] = baseAmount;
    });
    
    // 나머지 금액은 현재 사용자에게 추가
    if (currentUserId && splitAmounts[currentUserId] !== undefined) {
        splitAmounts[currentUserId] += remainder;
        console.log(`현재 사용자(${currentUserId})에게 나머지 ${remainder}원 추가`);
    }
    
    console.log('분할된 금액:', splitAmounts);
    
    // UI 업데이트
    updateFriendDisplayWithAmounts();
    updateTotalAmountDisplay();
}

// 총 금액 표시 업데이트
function updateTotalAmountDisplay() {
    const totalAmountElement = document.getElementById('totalAmountDisplay');
    const totalPeopleElement = document.getElementById('totalPeopleDisplay');
    
    if (totalAmountElement) {
        totalAmountElement.textContent = `₩${totalAmount.toLocaleString()}`;
    }
    
    if (totalPeopleElement) {
        totalPeopleElement.textContent = selectedFriendsData.length;
    }
}

function displayFriends() {
    const friendsContainer = document.getElementById('friendsStatus');
    friendsContainer.innerHTML = '';
    
    selectedFriendsData.forEach((friend, index) => {
        const friendElement = createFriendElement(friend, index);
        friendsContainer.appendChild(friendElement);
    });
    
    // 모든 사용자 초기 상태 설정
    initializeUserStatus();
    
    // 참여자 화면인지 확인
    const isParticipant = isParticipantView();
    
    // 가격 분할 계산 (발의자 화면에서만)
    if (!isParticipant && totalAmount > 0) {
        calculateSplitAmounts();
    } else if (isParticipant) {
        // 참여자 화면: paymentAmount 기반으로 UI 업데이트
        updateFriendDisplayWithAmounts();
    }
    
    // 친구 표시 완료
}

function updateFriendDisplayWithAmounts() {
    selectedFriendsData.forEach(friend => {
        const friendElement = document.getElementById('friend-' + friend.usersId);
        
        // 참여자 화면인지 확인
        const isParticipant = isParticipantView();
        
        if (isParticipant) {
            // 참여자 화면: paymentAmount와 paymentStatus 사용
            const amount = friend.paymentAmount || 0;
            const paymentStatus = friend.paymentStatus || 'pending';
            
            if (friendElement) {
                const amountElement = friendElement.querySelector('.friend-amount');
                const payBtn = document.getElementById('pay-btn-' + friend.usersId);
                const statusBadge = document.getElementById('badge-' + friend.usersId);
                
                if (amountElement) {
                    if (amount === 0) {
                        amountElement.textContent = '무료 🎉';
                        amountElement.style.color = '#28a745';
                    } else {
                        amountElement.textContent = `₩${amount.toLocaleString()}`;
                        amountElement.style.color = '#ff6b35';
                    }
                }
                
                // 결제 상태에 따른 UI 업데이트
                if (paymentStatus === 'paid' || paymentStatus === 'completed' || amount === 0) {
                    if (payBtn) {
                        payBtn.style.display = 'none';
                    }
                    if (statusBadge) {
                        statusBadge.className = 'status-badge status-accepted';
                        statusBadge.textContent = amount === 0 ? '무료' : '결제 완료';
                        statusBadge.style.background = '#28a745';
                    }
                    
                    // 결제 완료된 사용자는 자동으로 완료 처리
                    if (!friendElement.classList.contains('payment-completed')) {
                        friendElement.classList.add('payment-completed');
                        friendElement.style.background = '#d4edda';
                        friendElement.style.borderLeft = '4px solid #28a745';
                        
                        acceptedFriends++;
                        updateProgress();
                        
                        if (statusBadge) {
                            addCheckIcon(statusBadge);
                        }
                    }
                } else {
                    // 결제 대기 중인 경우
                    if (payBtn) {
                        payBtn.style.display = 'inline-block';
                    }
                    if (statusBadge && !friendElement.classList.contains('payment-completed')) {
                        const isCurrentUser = friend.usersId == window.currentUserId;
                        if (isCurrentUser) {
                            statusBadge.className = 'status-badge status-ready';
                            statusBadge.textContent = '결제 대기';
                            statusBadge.style.background = '#17a2b8';
                        } else {
                            statusBadge.className = 'status-badge status-waiting';
                            statusBadge.textContent = '결제 대기중';
                            statusBadge.style.background = '#6c757d';
                        }
                    }
                }
            }
        } else {
            // 발의자 화면: paymentStatus와 splitAmounts 모두 고려
            const amount = splitAmounts[friend.usersId] || 0;
            const paymentStatus = friend.paymentStatus || 'pending';
            
            if (friendElement) {
                const amountElement = friendElement.querySelector('.friend-amount');
                const payBtn = document.getElementById('pay-btn-' + friend.usersId);
                const statusBadge = document.getElementById('badge-' + friend.usersId);
                
                if (amountElement) {
                    if (amount === 0) {
                        amountElement.textContent = '무료 🎉';
                        amountElement.style.color = '#28a745';
                    } else {
                        amountElement.textContent = `₩${amount.toLocaleString()}`;
                        amountElement.style.color = '#ff6b35';
                    }
                }
                
                // 결제 상태에 따른 UI 업데이트 (paid, completed, 무료)
                if (paymentStatus === 'paid' || paymentStatus === 'completed' || amount === 0) {
                    if (payBtn) {
                        payBtn.style.display = 'none';
                    }
                    if (statusBadge) {
                        statusBadge.className = 'status-badge status-accepted';
                        statusBadge.textContent = amount === 0 ? '무료' : '결제 완료';
                        statusBadge.style.background = '#28a745';
                    }
                    
                    // 결제 완료된 사용자는 자동으로 완료 처리
                    if (!friendElement.classList.contains('payment-completed')) {
                        friendElement.classList.add('payment-completed');
                        friendElement.style.background = '#d4edda';
                        friendElement.style.borderLeft = '4px solid #28a745';
                        
                        acceptedFriends++;
                        updateProgress();
                        
                        if (statusBadge) {
                            addCheckIcon(statusBadge);
                        }
                    }
                } else {
                    // 결제 대기 중인 경우
                    if (payBtn) {
                        payBtn.style.display = 'inline-block';
                    }
                    if (statusBadge && !friendElement.classList.contains('payment-completed')) {
                        statusBadge.className = 'status-badge status-ready';
                        statusBadge.textContent = '결제 대기';
                        statusBadge.style.background = '#17a2b8';
                    }
                }
            }
        }
    });
    
    // 모든 결제가 완료되었는지 확인하고 버튼 변경
    const isAllCompleted = checkAllPaymentsCompleted();
    if (isAllCompleted) {
        console.log('🎉 updateFriendDisplayWithAmounts: 모든 결제 완료!');
        changeRefreshButtonToPaymentHistory();
    }
}

function createFriendElement(friend, index) {
    const div = document.createElement('div');
    
    // 현재 사용자 ID 가져오기
    const currentUserId = window.currentUserId;
    const isCurrentUser = friend.usersId == currentUserId;
    
    // 참여자 화면인지 확인
    const isParticipant = isParticipantView();
    
    // 친구 요소 생성
    div.className = isCurrentUser ? 'friend-status accepted' : 'friend-status pending';
    div.setAttribute('data-friend-id', friend.usersId);
    div.id = 'friend-' + friend.usersId;
    
    // 현재 사용자인 경우 특별한 스타일 적용
    if (isCurrentUser) {
        div.style.background = '#d1edff';
        div.style.borderLeft = '4px solid #007bff';
        
        // 현재 사용자의 회사-부서 정보가 없는 경우 JSP에서 가져오기
        if (!friend.companyName || !friend.departmentName || 
            friend.companyName === 'null' || friend.departmentName === 'null') {
            const currentUserCompanyName = window.currentUserCompanyName;
            const currentUserDepartmentName = window.currentUserDepartmentName;
            if (currentUserCompanyName && currentUserDepartmentName) {
                friend.companyName = currentUserCompanyName;
                friend.departmentName = currentUserDepartmentName;
                console.log('현재 사용자 회사-부서 정보 JSP에서 로드:', friend.companyName, '-', friend.departmentName);
            }
        }
    }
    
    const avatarDiv = document.createElement('div');
    avatarDiv.className = 'friend-avatar';
    
    if (friend.usersProfile && friend.usersProfile !== '' && friend.usersProfile !== 'null') {
        const img = document.createElement('img');
        img.src = friend.usersProfile;
        img.style.width = '100%';
        img.style.height = '100%';
        img.style.borderRadius = '50%';
        img.style.objectFit = 'cover';
        img.onerror = function() {
            this.style.display = 'none';
            avatarDiv.textContent = friend.usersName.substring(0, 1);
        };
        avatarDiv.appendChild(img);
    } else {
        avatarDiv.textContent = friend.usersName.substring(0, 1);
    }
    
    const infoDiv = document.createElement('div');
    infoDiv.className = 'friend-info';
    
    const nameDiv = document.createElement('div');
    nameDiv.className = 'friend-name';
    nameDiv.textContent = friend.usersName + (isCurrentUser ? ' (본인)' : '');
    
    const companyDiv = document.createElement('div');
    companyDiv.className = 'friend-company';
    
    // 회사명과 부서명이 있는지 확인하고 안전하게 표시
    const companyName = friend.companyName || '회사 정보 없음';
    const departmentName = friend.departmentName || '부서 정보 없음';
    
    // null, undefined, 빈 문자열 체크
    if (friend.companyName && friend.departmentName && 
        friend.companyName !== 'null' && friend.departmentName !== 'null') {
        companyDiv.textContent = companyName + ' - ' + departmentName;
    } else if (friend.companyName && friend.companyName !== 'null') {
        companyDiv.textContent = companyName;
    } else if (friend.departmentName && friend.departmentName !== 'null') {
        companyDiv.textContent = departmentName;
    } else {
        companyDiv.textContent = '소속 정보 없음';
        companyDiv.style.color = '#999';
        companyDiv.style.fontStyle = 'italic';
    }
    
    // 분할된 금액 표시
    const amountDiv = document.createElement('div');
    amountDiv.className = 'friend-amount';
    amountDiv.style.fontSize = '14px';
    amountDiv.style.fontWeight = 'bold';
    amountDiv.style.color = '#ff6b35';
    amountDiv.style.marginTop = '4px';
    
    // 참여자 화면에서는 paymentAmount 사용, 발의자 화면에서는 계산된 금액 사용
    if (isParticipant) {
        const amount = friend.paymentAmount || 0;
        if (amount === 0) {
            amountDiv.textContent = '무료 🎉';
            amountDiv.style.color = '#28a745';
        } else {
            amountDiv.textContent = `₩${amount.toLocaleString()}`;
            amountDiv.style.color = '#ff6b35';
        }
    } else {
        amountDiv.textContent = '계산 중...';
    }
    
    infoDiv.appendChild(nameDiv);
    infoDiv.appendChild(companyDiv);
    infoDiv.appendChild(amountDiv);
    
    const actionsDiv = document.createElement('div');
    actionsDiv.className = 'status-actions';
    
    const statusBadge = document.createElement('span');
    statusBadge.id = 'badge-' + friend.usersId;
    
    // 현재 사용자인 경우에만 결제 버튼 생성
    let payBtn = null;
    if (isCurrentUser) {
        console.log('💳 결제 버튼 생성:', friend.usersId);
        payBtn = document.createElement('button');
        payBtn.className = 'pay-btn';
        payBtn.textContent = '결제하기';
        payBtn.id = 'pay-btn-' + friend.usersId;
        payBtn.style.background = '#28a745';
        payBtn.style.color = 'white';
        payBtn.style.border = 'none';
        payBtn.style.borderRadius = '6px';
        payBtn.style.padding = '8px 16px';
        payBtn.style.fontSize = '12px';
        payBtn.style.fontWeight = 'bold';
        payBtn.style.cursor = 'pointer';
        payBtn.style.marginLeft = '8px';
        payBtn.onclick = function() {
            console.log('🔘 결제 버튼 클릭됨:', friend.usersId);
            console.log('🔘 proceedToPayment 함수 호출 시작');
            proceedToPayment(friend.usersId);
        };
    } else {
        console.log('❌ 현재 사용자가 아님, 결제 버튼 생성 안함:', friend.usersId);
    }
    
    // 결제 상태 표시
    if (isParticipant) {
        // 참여자 화면: paymentStatus 기반으로 상태 표시
        const paymentStatus = friend.paymentStatus || 'pending';
                        if (paymentStatus === 'paid' || paymentStatus === 'completed') {
                    statusBadge.className = 'status-badge status-accepted';
                    statusBadge.textContent = paymentStatus === 'completed' ? '그룹 완료' : '결제 완료';
                    statusBadge.style.background = '#28a745';
            
            // 결제 완료된 사용자는 자동으로 완료 처리
            div.classList.add('payment-completed');
            div.style.background = '#d4edda';
            div.style.borderLeft = '4px solid #28a745';
            
            if (payBtn) {
                payBtn.style.display = 'none';
            }
            
            addCheckIcon(statusBadge);
        } else if (friend.paymentAmount === 0) {
            statusBadge.className = 'status-badge status-accepted';
            statusBadge.textContent = '무료';
            statusBadge.style.background = '#28a745';
            
            if (payBtn) {
                payBtn.style.display = 'none';
            }
            
            addCheckIcon(statusBadge);
        } else {
            if (isCurrentUser) {
                statusBadge.className = 'status-badge status-ready';
                statusBadge.textContent = '결제 대기';
                statusBadge.style.background = '#17a2b8';
                statusBadge.innerHTML = '결제 대기 <i class="bi bi-person" style="margin-left: 5px; font-size: 10px;"></i>';
            } else {
                statusBadge.className = 'status-badge status-waiting';
                statusBadge.textContent = '결제 대기중';
                statusBadge.style.background = '#6c757d';
            }
        }
    } else {
        // 발의자 화면: paymentStatus 기반으로 상태 표시
        const paymentStatus = friend.paymentStatus || 'pending';
        
        if (paymentStatus === 'paid' || paymentStatus === 'completed') {
            statusBadge.className = 'status-badge status-accepted';
            statusBadge.textContent = paymentStatus === 'completed' ? '그룹 완료' : '결제 완료';
            statusBadge.style.background = '#28a745';
            
            // 결제 완료된 사용자는 자동으로 완료 처리
            div.classList.add('payment-completed');
            div.style.background = '#d4edda';
            div.style.borderLeft = '4px solid #28a745';
            
            if (payBtn) {
                payBtn.style.display = 'none';
            }
            
            addCheckIcon(statusBadge);
        } else if (friend.paymentAmount === 0 || (splitAmounts[friend.usersId] === 0)) {
            statusBadge.className = 'status-badge status-accepted';
            statusBadge.textContent = '무료';
            statusBadge.style.background = '#28a745';
            
            if (payBtn) {
                payBtn.style.display = 'none';
            }
            
            addCheckIcon(statusBadge);
        } else {
            if (isCurrentUser) {
                statusBadge.className = 'status-badge status-ready';
                statusBadge.textContent = '결제 대기';
                statusBadge.style.background = '#17a2b8';
                statusBadge.innerHTML = '결제 대기 <i class="bi bi-person" style="margin-left: 5px; font-size: 10px;"></i>';
            } else {
                statusBadge.className = 'status-badge status-waiting';
                statusBadge.textContent = '결제 대기중';
                statusBadge.style.background = '#6c757d';
            }
        }
    }
    
    actionsDiv.appendChild(statusBadge);
    if (payBtn) {
        actionsDiv.appendChild(payBtn);
    }
    
    div.appendChild(avatarDiv);
    div.appendChild(infoDiv);
    div.appendChild(actionsDiv);
    
    return div;
}

function initializeUserStatus() {
    const hasGameResult = new URLSearchParams(window.location.search).has('gameResult');
    
    if (!hasGameResult) {
        // 참여자 화면인지 확인
        const isParticipant = isParticipantView();
        
        if (isParticipant) {
            // 참여자 화면: paymentStatus 기반으로 acceptedFriends 계산
            acceptedFriends = selectedFriendsData.filter(friend => 
                friend.paymentStatus === 'paid' || friend.paymentStatus === 'completed' || friend.paymentAmount === 0
            ).length;
        } else {
            // 발의자 화면: paymentStatus 기반으로 acceptedFriends 계산 (이제 paymentStatus 정보가 있음)
            acceptedFriends = selectedFriendsData.filter(friend => 
                friend.paymentStatus === 'paid' || friend.paymentStatus === 'completed' || friend.paymentAmount === 0
            ).length;
        }
    }
    
    updateProgress();
}

// 결제 완료 처리 (실제 결제 API 연동시 호출)
function markPaymentComplete(friendId) {
    console.log('💰 결제 완료 처리:', friendId);
    
    const friendElement = document.getElementById('friend-' + friendId);
    
    if (friendElement) {
        friendElement.style.background = '#d4edda';
        friendElement.style.borderLeft = '4px solid #28a745';
        
        const statusBadge = document.getElementById('badge-' + friendId);
        if (statusBadge) {
            statusBadge.className = 'status-badge status-accepted';
            statusBadge.textContent = '결제 완료';
            statusBadge.style.background = '#28a745';
        }
        
        const payBtn = document.getElementById('pay-btn-' + friendId);
        if (payBtn) {
            payBtn.style.display = 'none';
        }
        
        acceptedFriends++;
        updateProgress();
        
        if (statusBadge) {
            addCheckIcon(statusBadge);
        }
        
        // 실제 총 인원과 비교
        const actualTotalFriends = selectedFriendsData.length;
        if (acceptedFriends === actualTotalFriends) {
            completeAllPayments();
            changeRefreshButtonToPaymentHistory();
        }
    }
}

function displayNoFriends() {
    const friendsContainer = document.getElementById('friendsStatus');
    
    const div = document.createElement('div');
    div.className = 'text-center text-muted py-4';
    div.innerHTML = `
        <i class="bi bi-people" style="font-size: 48px; margin-bottom: 16px; opacity: 0.3;"></i>
        <p>혼자 결제하기를 선택했습니다.</p>
    `;
    
    friendsContainer.appendChild(div);
}

function updateProgress() {
    const acceptedElement = document.getElementById('acceptedCount');
    const totalElement = document.getElementById('totalCount');
    const actualTotalFriends = selectedFriendsData.length;
    
    if (acceptedElement) acceptedElement.textContent = acceptedFriends;
    if (totalElement) totalElement.textContent = actualTotalFriends;
    
    const continueBtn = document.getElementById('continueBtn');
    if (continueBtn) {
        if (acceptedFriends === actualTotalFriends) {
            continueBtn.classList.add('active');
            continueBtn.disabled = false;
        } else {
            continueBtn.classList.remove('active');
            continueBtn.disabled = true;
        }
    }
}

function addCheckIcon(targetElement) {
    const checkIcon = document.createElement('i');
    checkIcon.className = 'bi bi-check-circle-fill';
    checkIcon.style.color = '#28a745';
    checkIcon.style.marginLeft = '8px';
    checkIcon.style.animation = 'fadeIn 0.5s ease-in-out';
    
    targetElement.appendChild(checkIcon);
}

function completeAllPayments() {
    console.log('모든 결제 완료!');
    
    const statusIcon = document.getElementById('statusIcon');
    if (statusIcon) {
        statusIcon.className = 'bi bi-check-circle-fill status-icon';
        statusIcon.style.color = '#28a745';
        statusIcon.style.animation = 'none';
    }
    
    const statusTitle = document.getElementById('statusTitle');
    if (statusTitle) {
        statusTitle.textContent = '모든 결제가 완료되었습니다! 🎉';
    }
    
    const statusDesc = document.getElementById('statusDesc');
    if (statusDesc) {
        statusDesc.innerHTML = '주문이 성공적으로 처리되었습니다.<br>감사합니다!';
    }
}

function goBack() {
    history.back();
}

function cancelInvitation() {
    if (confirm('이전 페이지로 돌아가시겠습니까?')) {
        history.back();
    }
}

function goToMiniGame() {
    if (selectedFriendsData.length === 0) {
        showErrorPopup('참가자 정보를 불러오는 중입니다. 잠시 후 다시 시도해주세요.');
        return;
    }
    
    if (totalAmount <= 0) {
        showErrorPopup('총 결제 금액 정보를 불러오는 중입니다. 잠시 후 다시 시도해주세요.');
        return;
    }
    
    // 참가자 정보 준비 (이름만 전달)
    const members = selectedFriendsData.map(friend => {
        // "(나)", "(본인)" 제거하고 실제 이름만 전달
        const cleanName = friend.usersName.replace(' (나)', '').replace(' (본인)', '').trim();
        console.log(`🎮 게임으로 전달할 이름: "${friend.usersName}" → "${cleanName}"`);
        return cleanName;
    });
    
    // 데이터를 URL 파라미터로 전달
    const gameData = {
        members: members,
        amount: totalAmount
    };
    
    // JSON을 Base64로 인코딩하여 URL에 안전하게 전달
    const encodedData = btoa(encodeURIComponent(JSON.stringify(gameData)));
    
    console.log('🎮 미니게임으로 전달할 데이터:', gameData);
    
    // 더치페이 게임 페이지로 이동 (현재 페이지 URL도 함께 전달)
    const currentPageUrl = encodeURIComponent(window.location.href);
    const gameUrl = window.UrlConstants.Builder.fullUrl('/dutchpay.html') + `?data=${encodedData}&returnUrl=${currentPageUrl}`;
    window.location.href = gameUrl;
}

function proceedToPayment(userId) {
    console.log('🚀 proceedToPayment 함수 시작됨, userId:', userId);
    const currentUserId = window.currentUserId;
    console.log('🚀 currentUserId:', currentUserId);

    // 참여자 화면인지 확인
    const currentUser = selectedFriendsData.find(friend => friend.usersId == userId);
    const isParticipant = isParticipantView();
    
    let userAmount;
    if (isParticipant) {
        // 참여자 화면: paymentAmount 사용
        userAmount = currentUser.paymentAmount || 0;
    } else {
        // 발의자 화면: splitAmounts 사용
        userAmount = splitAmounts[userId];
    }
    
    if (!userAmount && userAmount !== 0) {
        showErrorPopup('결제 금액을 계산할 수 없습니다.');
        return;
    }
    
    console.log(`💳 사용자 ${userId}의 결제 진행: ₩${userAmount.toLocaleString()}`);
    
    // 결제 버튼 비활성화 및 로딩 상태로 변경
    const payBtn = document.getElementById('pay-btn-' + userId);
    if (payBtn) {
        // 이미 처리 중인지 확인
        if (payBtn.disabled) {
            console.log('⚠️ 이미 결제 처리 중입니다.');
            return;
        }
        
        payBtn.textContent = '결제 중...';
        payBtn.disabled = true;
        payBtn.style.background = '#6c757d';
        
        // 30초 후 자동 복원 (안전장치)
        setTimeout(() => {
            if (payBtn.disabled) {
                payBtn.textContent = '결제하기';
                payBtn.disabled = false;
                payBtn.style.background = '#28a745';
                console.log('⚠️ 결제 버튼 자동 복원 (30초 타임아웃)');
            }
        }, 30000);
    }
    
    // 결제 진행 확인 알림
    console.log('💳 confirm 다이얼로그 표시 예정');
    const confirmPayment = confirm(`결제 금액: ₩${userAmount.toLocaleString()}\n결제를 진행하시겠습니까?`);
    console.log('💳 confirm 결과:', confirmPayment);
    
    if (confirmPayment) {
        console.log('💳 confirm 확인됨, 결제 진행 시작');
        
        // 결제 요청 데이터 준비
        let amount = userAmount;
        let userEmail = window.currentUserEmail || 'user@example.com';
        let userNickname = window.currentUserNickname || '사용자';
        let userTel = window.currentUserTel || '010-0000-0000';
        
        console.log('💳 결제 요청 시작:', {
            impCode: window.impCode,
            amount: amount,
            userEmail: userEmail,
            userNickname: userNickname,
            userTel: userTel
        });
        
        // impCode 확인
        if (!window.impCode || window.impCode === '') {
            console.error('❌ impCode가 설정되지 않았습니다!');
            showErrorPopup('결제 설정이 올바르지 않습니다.');
            return;
        }
        
        // IMP 객체 확인
        if (!window.IMP) {
            console.error('❌ IMP 객체가 없습니다!');
            showErrorPopup('결제 라이브러리가 로드되지 않았습니다.');
            return;
        }
        
        // requestPayment 함수 확인
        if (typeof window.requestPayment !== 'function') {
            console.error('❌ requestPayment 함수가 정의되지 않았습니다!');
            console.error('window.requestPayment:', typeof window.requestPayment);
            showErrorPopup('결제 함수가 로드되지 않았습니다. 페이지를 새로고침해주세요.');
            return;
        }
        
        console.log('✅ requestPayment 함수 호출 시작');
        console.log('impCode 확인:', window.impCode);
        console.log('IMP 객체 확인:', typeof window.IMP);
        
        // 고유한 merchant_uid 생성 (사용자 ID + 타임스탬프 + 랜덤값)
        const uniqueMerchantUid = 'payNo_' + window.currentUserId + '_' + new Date().getTime();
        
        // payment.js의 requestPayment 함수 사용 (중복 검증 제거)
        const paymentOptions = {
            impCode: window.impCode || 'imp00000000',
            pg: 'html5_inicis',
            pay_method: 'card',
            merchant_uid: uniqueMerchantUid,
            name: '더치페이 결제',
            amount: amount,
            buyer_email: userEmail,
            buyer_name: userNickname,
            buyer_tel: userTel
        };
        
        // 역할에 따른 옵션 추가
        if (isParticipantView()) {
            paymentOptions.role = 'participant';
            paymentOptions.paymentId = currentUser.paymentId;
        } else {
            paymentOptions.role = 'leader';
        }
        
        // requestPayment 호출 (내부적으로 verifyPayment까지 처리됨)
        window.requestPayment(paymentOptions, function(rsp) {
            console.log("🎯 requestPayment 콜백 실행됨");
            console.log("결제 응답:", rsp);
            
            if (rsp.success) {
                console.log("✅ 결제 성공 - UI 업데이트 시작");
                
                // 결제 완료 처리 (현재 사용자의 결제 상태를 먼저 업데이트)
                markPaymentComplete(userId);
                
                // 현재 사용자의 결제 상태를 즉시 업데이트
                const currentUser = selectedFriendsData.find(friend => friend.usersId == userId);
                if (currentUser) {
                    currentUser.paymentStatus = 'paid';
                    console.log("🔄 현재 사용자 결제 상태 즉시 업데이트:", {
                        userId: userId,
                        name: currentUser.usersName,
                        status: currentUser.paymentStatus
                    });
                }
                
                // 서버에서 전체 결제 완료 여부 확인
                const isAllCompleted = rsp.isAllCompleted || false;
                console.log("🔍 서버 응답의 전체 결제 완료 여부:", isAllCompleted);
                
                // 클라이언트에서도 전체 결제 완료 여부 재확인 (현재 사용자 상태 업데이트 후)
                const clientAllCompleted = checkAllPaymentsCompleted();
                console.log("🔍 클라이언트 확인 전체 결제 완료 여부:", clientAllCompleted);
                
                // 서버 또는 클라이언트 중 하나라도 완료로 판단하면 완료 처리
                const finalAllCompleted = isAllCompleted || clientAllCompleted;
                console.log("🔍 최종 전체 결제 완료 여부:", finalAllCompleted);
                
                if (finalAllCompleted) {
                    // 모든 결제가 완료된 경우
                    console.log("🎉 모든 결제 완료!");
                    completeAllPayments();
                    changeRefreshButtonToPaymentHistory();
                    
                    // 성공 알림 후 payment-history로 이동
                    showPaymentSuccessAlert(
                        "모든 결제가 완료되었습니다!", 
                        "그룹 결제가 성공적으로 완료되었습니다.", 
                        UrlConstants.Builder.fullUrl("/user/mypage/payment-history")
                    );
                } else {
                    // 아직 다른 참여자들의 결제가 남은 경우
                    console.log("⏳ 다른 참여자들의 결제 대기 중...");
                    
                    // 성공 알림 (페이지 이동 없이)
                    const alertPromise = showPaymentSuccessAlert(
                        "결제가 완료되었습니다!", 
                        "다른 참여자들의 결제를 기다리는 중입니다.", 
                        null // 페이지 이동하지 않음
                    );
                    
                    // Promise가 반환되는 경우에만 then 체인 사용
                    if (alertPromise && typeof alertPromise.then === 'function') {
                        alertPromise.then(() => {
                            // 알림 닫힌 후 결제 상태 새로고침 (페이지 새로고침 대신)
                            console.log("🔄 결제 상태 새로고침");
                            refreshPaymentStatus();
                        });
                    } else {
                        // Promise가 반환되지 않는 경우 결제 상태 새로고침
                        console.log("🔄 결제 상태 새로고침 (즉시)");
                        setTimeout(() => {
                            refreshPaymentStatus();
                        }, 1000); // 1초 후 새로고침
                    }
                }
            } else {
                console.log("❌ 결제 실패");
                showPaymentErrorAlert("결제 실패", rsp.error_msg || "결제 처리 중 오류가 발생했습니다.");
                
                // 결제 실패시 버튼 복원
                if (payBtn) {
                    payBtn.textContent = '결제하기';
                    payBtn.disabled = false;
                    payBtn.style.background = '#28a745';
                }
            }
        });
    } else {
        // 결제 취소시 버튼 복원
        if (payBtn) {
            payBtn.textContent = '결제하기';
            payBtn.disabled = false;
            payBtn.style.background = '#28a745';
        }
    }
}

// ======== 게임 결과 처리 함수들 ========

// URL에서 게임 결과 파라미터 추출
function getGameResultFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    const encodedResult = urlParams.get('gameResult');
    
    if (encodedResult) {
        try {
            const decodedResult = JSON.parse(decodeURIComponent(atob(encodedResult)));
            console.log('🎮 게임 결과 디코딩 성공:', decodedResult);
            return decodedResult;
        } catch (error) {
            console.error('게임 결과 디코딩 오류:', error);
        }
    }
    
    return null;
}

// URL에서 gameResult 파라미터 제거 (깔끔한 URL 유지)
function removeGameResultFromURL() {
    const url = new URL(window.location.href);
    url.searchParams.delete('gameResult');
    window.history.replaceState({}, document.title, url.toString());
}

// 게임 결과를 수락 대기 페이지에 적용
function applyGameResult(gameResult) {
    console.log('🎮 게임 결과 적용 시작:', gameResult);
    
    // 현재 상태 확인
    console.log('📊 적용 전 상태 확인:');
    console.log('  - selectedFriendsData:', selectedFriendsData);
    console.log('  - 현재 splitAmounts:', splitAmounts);
    console.log('  - totalAmount:', totalAmount);
    
    // acceptedFriends 초기화 (게임 결과 적용 시)
    acceptedFriends = 0;
    console.log('  - acceptedFriends 초기화: 0');
    
    // splitAmounts 초기화 (안전하게)
    if (!splitAmounts || typeof splitAmounts !== 'object') {
        splitAmounts = {};
        console.log('  - splitAmounts 객체 초기화');
    }
    
    if (gameResult.type === 'winner') {
        // 결제자 한 명이 전체 결제
        console.log('🎯 결제자 선택 모드 적용');
        applyWinnerResult(gameResult);
    } else if (gameResult.type === 'split') {
        // 균등 분할 결과 적용
        console.log('💸 균등 분할 모드 적용');
        applySplitResult(gameResult);
    }
    
    // UI 업데이트
    console.log('🔄 UI 업데이트 시작');
    updateFriendDisplayWithAmounts();
    updateTotalAmountDisplay();
    
    // 게임 결과 적용 알림
    showGameResultNotification(gameResult);
}

// 결제자(winner) 결과 적용
function applyWinnerResult(gameResult) {
    const winnerName = gameResult.winner;
    console.log(`🎉 결제자: ${winnerName}님이 ₩${gameResult.amount.toLocaleString()} 전체 결제`);
    
    // 디버깅: 현재 사용자 정보 출력
    console.log('🔍 현재 사용자 목록:');
    selectedFriendsData.forEach(friend => {
        const cleanName = friend.usersName.replace(' (나)', '').replace(' (본인)', '');
        console.log(`  - 원본: "${friend.usersName}" → 정제: "${cleanName}"`);
    });
    console.log(`🎯 찾고 있는 결제자: "${winnerName}"`);
    
    // 모든 사용자의 분할 금액을 0으로 설정
    selectedFriendsData.forEach(friend => {
        splitAmounts[friend.usersId] = 0;
    });
    
    // 결제자 찾기 (여러 방법으로 시도)
    let winner = selectedFriendsData.find(friend => 
        friend.usersName.replace(' (나)', '').replace(' (본인)', '') === winnerName
    );
    
    // 첫 번째 시도 실패 시 다른 방법으로 시도
    if (!winner) {
        winner = selectedFriendsData.find(friend => 
            friend.usersName.includes(winnerName) || winnerName.includes(friend.usersName.replace(' (나)', '').replace(' (본인)', ''))
        );
    }
    
    // 여전히 찾지 못한 경우 부분 매칭 시도
    if (!winner) {
        winner = selectedFriendsData.find(friend => {
            const cleanFriendName = friend.usersName.replace(' (나)', '').replace(' (본인)', '').trim();
            const cleanWinnerName = winnerName.trim();
            return cleanFriendName === cleanWinnerName || 
                   cleanFriendName.includes(cleanWinnerName) || 
                   cleanWinnerName.includes(cleanFriendName);
        });
    }
    
    if (winner) {
        splitAmounts[winner.usersId] = gameResult.amount;
        console.log(`✅ 결제자 찾기 성공: ${winner.usersName}(ID: ${winner.usersId})에게 ₩${gameResult.amount.toLocaleString()} 배정`);
    } else {
        console.error(`❌ 결제자 "${winnerName}"를 찾을 수 없습니다!`);
        // 결제자를 찾지 못한 경우 첫 번째 사용자에게 배정
        if (selectedFriendsData.length > 0) {
            const firstUser = selectedFriendsData[0];
            splitAmounts[firstUser.usersId] = gameResult.amount;
            console.log(`⚠️ 대체: ${firstUser.usersName}(ID: ${firstUser.usersId})에게 배정`);
        }
    }
    
    // 최종 결과 확인
    console.log('💰 최종 분할 금액:', splitAmounts);
}

// 균등 분할 결과 적용
function applySplitResult(gameResult) {
    console.log('💸 균등 분할 결과 적용:', gameResult.splitAmounts);
    
    // 디버깅: 게임 결과와 현재 사용자 매칭 확인
    console.log('🔍 게임 결과에서 받은 분할 금액:');
    Object.keys(gameResult.splitAmounts).forEach(name => {
        console.log(`  - "${name}" → ₩${gameResult.splitAmounts[name].toLocaleString()}`);
    });
    
    console.log('🔍 현재 사용자 목록과 매칭 시도:');
    
    // 게임에서 계산된 분할 금액 적용
    selectedFriendsData.forEach(friend => {
        const cleanName = friend.usersName.replace(' (나)', '').replace(' (본인)', '').trim();
        console.log(`  - 사용자: "${friend.usersName}" → 정제된 이름: "${cleanName}"`);
        
        let gameAmount = gameResult.splitAmounts[cleanName];
        
        // 직접 매칭 실패 시 다른 방법 시도
        if (gameAmount === undefined) {
            // 게임 결과의 모든 키와 비교
            const matchedKey = Object.keys(gameResult.splitAmounts).find(key => {
                return key.trim() === cleanName || 
                       key.includes(cleanName) || 
                       cleanName.includes(key.trim());
            });
            
            if (matchedKey) {
                gameAmount = gameResult.splitAmounts[matchedKey];
                console.log(`    ✅ 매칭 성공: "${cleanName}" ↔ "${matchedKey}" → ₩${gameAmount.toLocaleString()}`);
            } else {
                console.log(`    ❌ 매칭 실패: "${cleanName}"에 해당하는 금액을 찾을 수 없음`);
            }
        } else {
            console.log(`    ✅ 직접 매칭 성공: "${cleanName}" → ₩${gameAmount.toLocaleString()}`);
        }
        
        if (gameAmount !== undefined) {
            splitAmounts[friend.usersId] = gameAmount;
        } else {
            // 매칭 실패 시 0원으로 설정
            splitAmounts[friend.usersId] = 0;
            console.log(`    ⚠️ 매칭 실패로 0원 설정: ${friend.usersName}`);
        }
    });
    
    // 최종 결과 확인
    console.log('💰 최종 분할 금액 적용 결과:', splitAmounts);
}

// 게임 결과 적용 알림 표시
function showGameResultNotification(gameResult) {
    let message = '';
    
    if (gameResult.type === 'winner') {
        message = `🎉 ${gameResult.winner}님이 전체 ₩${gameResult.amount.toLocaleString()}을 결제하기로 결정되었습니다!`;
    } else if (gameResult.type === 'split') {
        message = `💸 더치페이 게임 결과가 적용되었습니다!\n각자 분할된 금액을 확인해주세요.`;
    }
    
    // 알림 표시
    if (message) {
        // 모달이나 토스트 알림 대신 간단한 alert 사용
        setTimeout(() => {
            showErrorPopup(message);
        }, 100);
        
        // 콘솔에도 로그
        console.log('📢 게임 결과 알림:', message);
    }
}

// ======== 결제 상태 폴링 함수들 ========

// 결제 상태 폴링 시작
function startPaymentStatusMonitoring() {
    // 이미 폴링이 시작되었으면 중복 실행 방지
    if (sseStarted) {
        console.log('🔗 폴링 이미 시작됨, 중복 실행 방지');
        return;
    }
    
    console.log('🔗 결제 상태 폴링 시작');
    console.log('🔗 폴링 간격: 3초');
    sseStarted = true;
    
    // 3초마다 결제 상태 확인
    const pollInterval = setInterval(() => {
        if (!sseStarted) {
            console.log('🔗 폴링 중지됨');
            clearInterval(pollInterval);
            return;
        }
        
        console.log('🔗 폴링 실행 중...');
        checkPaymentStatus();
    }, 3000); // 3초마다
    
    // 페이지 언로드 시 폴링 중지
    window.addEventListener('beforeunload', () => {
        console.log('🔗 페이지 언로드, 폴링 중지');
        sseStarted = false;
        clearInterval(pollInterval);
    });
}

// 결제 상태 확인 API 호출
async function checkPaymentStatus() {
    try {
        let apiUrl;
        if (isParticipantView()) {
            // 참여자: 특정 paymentId로 결제 정보 조회
            apiUrl = window.UrlConstants.Builder.fullUrl(`/payments/payment/${window.paymentId}`);
        } else {
            // 발의자: 기존 API 사용
            apiUrl = window.UrlConstants.Builder.fullUrl('/user/cart/waiting-approval-data');
        }
        
        console.log('🔍 폴링 API 호출:', apiUrl);
        const response = await fetch(apiUrl);
        const data = await response.json();
        console.log('🔍 폴링 응답 데이터:', data);
        
        if (data.result === 'success' || data.success) {
            console.log('🔍 폴링 성공, 참여자 수:', data.participants ? data.participants.length : 0);
            // 결제 상태 변경 감지 및 UI 업데이트
            updatePaymentStatusFromResponse(data);
        } else {
            console.log('🔍 폴링 실패 또는 데이터 없음:', data);
        }
    } catch (error) {
        console.error('결제 상태 확인 오류:', error);
    }
}

// 응답 데이터로부터 결제 상태 업데이트
function updatePaymentStatusFromResponse(data) {
    const participants = data.participants || [];
    let hasChanges = false;
    
    console.log('🔍 현재 selectedFriendsData 상태:', selectedFriendsData.map(f => ({
        id: f.usersId,
        name: f.usersName,
        status: f.paymentStatus,
        amount: f.paymentAmount
    })));
    
    console.log('🔍 폴링으로 받은 participants 상태:', participants.map(p => ({
        id: p.usersId,
        name: p.usersName,
        status: p.paymentStatus,
        amount: p.paymentAmount
    })));
    
    participants.forEach(participant => {
        const existingFriend = selectedFriendsData.find(friend => friend.usersId == participant.usersId);
        
        if (existingFriend) {
            // 결제 상태가 변경되었는지 확인
            if (existingFriend.paymentStatus !== participant.paymentStatus) {
                console.log(`💰 결제 상태 변경 감지: ${existingFriend.usersName} ${existingFriend.paymentStatus} → ${participant.paymentStatus}`);
                existingFriend.paymentStatus = participant.paymentStatus;
                existingFriend.paymentAmount = participant.paymentAmount;
                hasChanges = true;
                
                // 현재 사용자의 결제 상태가 변경된 경우 특별 로그
                if (participant.usersId == window.currentUserId) {
                    console.log(`🎯 현재 사용자 결제 상태 변경: ${existingFriend.usersName} → ${participant.paymentStatus}`);
                }
            } else {
                console.log(`🔍 상태 변경 없음: ${existingFriend.usersName} (${existingFriend.paymentStatus})`);
            }
        } else {
            console.log(`⚠️ 매칭되지 않은 참여자: ${participant.usersName} (ID: ${participant.usersId})`);
        }
    });
    
    console.log('🔍 변경사항 있음:', hasChanges);
    
    // 변경사항이 있으면 UI 업데이트
    if (hasChanges) {
        console.log('🔄 UI 업데이트 시작');
        updateFriendDisplayWithAmounts();
        updateProgress();
        
        // 모든 결제가 완료되었는지 확인 (현재 사용자 제외 로직 적용)
        const allCompleted = checkAllPaymentsCompleted();
        
        console.log('🔍 모든 결제 완료 여부 (폴링):', allCompleted);
        
        if (allCompleted) {
            handleGroupPaymentCompleted();
            changeRefreshButtonToPaymentHistory();
        }
    } else {
        console.log('🔍 변경사항 없음, UI 업데이트 건너뜀');
    }
}



// 결제 실패 처리
function markPaymentFailed(userId) {
    console.log('❌ 결제 실패 처리:', userId);
    
    const friendElement = document.getElementById('friend-' + userId);
    
    if (friendElement) {
        const statusBadge = document.getElementById('badge-' + userId);
        if (statusBadge) {
            statusBadge.className = 'status-badge status-failed';
            statusBadge.textContent = '결제 실패';
            statusBadge.style.background = '#dc3545';
        }
        
        const payBtn = document.getElementById('pay-btn-' + userId);
        if (payBtn) {
            payBtn.textContent = '재결제';
            payBtn.disabled = false;
            payBtn.style.background = '#dc3545';
        }
    }
}

// 그룹 결제 완료 처리
function handleGroupPaymentCompleted() {
    console.log('🎉 그룹 결제 완료!');
    
    // 모든 결제가 완료된 상태로 UI 업데이트
    completeAllPayments();
    changeRefreshButtonToPaymentHistory();
    
    // 성공 알림 표시
    showPaymentSuccessAlert("모든 결제가 완료되었습니다!", "결제 완료 페이지로 이동합니다.", 
        UrlConstants.Builder.fullUrl("/user/mypage/payment-history"));
}

// 그룹 결제 취소 처리
function handleGroupPaymentCancelled(cancelledByUserId) {
    console.log('❌ 그룹 결제 취소됨, 취소한 사용자:', cancelledByUserId);
    
    // 취소 알림 표시
    const cancelledByUser = selectedFriendsData.find(friend => friend.usersId == cancelledByUserId);
    const cancelledByName = cancelledByUser ? cancelledByUser.usersName : '알 수 없는 사용자';
    
    showPaymentErrorAlert("그룹 결제 취소", 
        `${cancelledByName}님이 그룹 결제를 취소했습니다.\n결제했던 금액은 자동으로 환불됩니다.`);
    
    // 3초 후 이전 페이지로 이동
    setTimeout(() => {
        history.back();
    }, 3000);
}

// 그룹 결제 취소 요청
function cancelGroupPayment() {
    if (!confirm('정말로 그룹 결제를 취소하시겠습니까?\n다른 참여자들의 결제도 함께 취소됩니다.')) {
        return;
    }
    
    console.log('🚫 그룹 결제 취소 요청');
    
    fetch(UrlConstants.Builder.fullUrl('/user/cart/cancel-group-payment'), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            showPaymentSuccessAlert("그룹 결제 취소", "그룹 결제가 취소되었습니다.");
            setTimeout(() => {
                history.back();
            }, 2000);
        } else {
            showPaymentErrorAlert("취소 실패", data.message || "그룹 결제 취소에 실패했습니다.");
        }
    })
    .catch(error => {
        console.error('그룹 결제 취소 오류:', error);
        showPaymentErrorAlert("취소 실패", "그룹 결제 취소 중 오류가 발생했습니다.");
    });
}

// ======== 결제 상태 새로고침 함수들 ========

/**
 * 결제 상태 새로고침
 */
async function refreshPaymentStatus() {
    console.log('🔄 결제 상태 새로고침 시작');
    
    const refreshBtn = document.getElementById('refreshPaymentStatus');
    if (refreshBtn) {
        // 버튼 비활성화 및 로딩 상태
        refreshBtn.disabled = true;
        refreshBtn.innerHTML = '<i class="bi bi-arrow-clockwise spin"></i> 새로고침 중...';
    }
    
    try {
        // 역할에 따라 다른 API 호출
        let apiUrl;
        if (isParticipantView()) {
            // 참여자: 특정 paymentId로 결제 정보 조회
            apiUrl = window.UrlConstants.Builder.fullUrl(`/payments/payment/${window.paymentId}`);
        } else {
            // 발의자: 기존 API 사용
            apiUrl = window.UrlConstants.Builder.fullUrl('/user/cart/waiting-approval-data');
        }
        
        console.log('🔍 API 호출:', apiUrl);
        const response = await fetch(apiUrl);
        const data = await response.json();
        
        if (data.result === 'success' || data.success) {
            console.log('✅ 결제 상태 새로고침 성공:', data);
            
            // 참여자 데이터 업데이트
            if (data.participants && data.participants.length > 0) {
                updateParticipantsFromResponse(data);
            }
            
            // 전체 결제 완료 여부 확인
            const isAllCompleted = checkAllPaymentsCompleted();
            
            if (isAllCompleted) {
                console.log('🎉 모든 결제 완료! 버튼을 payment-history로 변경');
                changeRefreshButtonToPaymentHistory();
            } else {
                console.log('⏳ 아직 결제 대기 중...');
                // UI 업데이트
                updateFriendDisplayWithAmounts();
                updateProgress();
            }
            
        } else {
            // 진행 중인 결제가 없으면 payment-history로 리다이렉트
            if (data.result === 'error' && data.message === '진행 중인 결제가 없습니다.') {
                console.log('🔍 진행 중인 결제가 없음, payment-history로 리다이렉트');
                window.location.href = UrlConstants.Builder.fullUrl('/user/mypage/payment-history');
                return;
            }
            
            console.error('❌ 결제 상태 새로고침 실패:', data);
            showErrorPopup('결제 상태를 불러오는데 실패했습니다.');
        }
        
    } catch (error) {
        console.error('❌ 결제 상태 새로고침 오류:', error);
        showErrorPopup('결제 상태를 불러오는 중 오류가 발생했습니다.');
    } finally {
        // 버튼 복원
        if (refreshBtn) {
            refreshBtn.disabled = false;
            refreshBtn.innerHTML = '<i class="bi bi-arrow-clockwise"></i> 결제 상태 새로고침';
        }
    }
}

/**
 * 서버 응답으로부터 참여자 데이터 업데이트
 */
function updateParticipantsFromResponse(data) {
    const participants = data.participants || [];
    
    // selectedFriendsData 업데이트
    participants.forEach(participant => {
        const existingFriend = selectedFriendsData.find(friend => friend.usersId == participant.usersId);
        if (existingFriend) {
            // 결제 상태 업데이트
            existingFriend.paymentStatus = participant.paymentStatus || 'pending';
            existingFriend.paymentAmount = participant.paymentAmount || 0;
            
            console.log(`💰 참여자 ${existingFriend.usersName} 상태 업데이트:`, {
                status: existingFriend.paymentStatus,
                amount: existingFriend.paymentAmount
            });
        }
    });
    
    // acceptedFriends 재계산
    acceptedFriends = selectedFriendsData.filter(friend => 
        friend.paymentStatus === 'paid' || friend.paymentStatus === 'completed' || friend.paymentAmount === 0
    ).length;
    
    console.log('📊 acceptedFriends 재계산:', acceptedFriends);
}

/**
 * 모든 결제가 완료되었는지 확인
 * 현재 사용자의 결제가 완료된 경우 자신은 제외하고 다른 참여자들만 검사
 */
function checkAllPaymentsCompleted() {
    const currentUserId = window.currentUserId;
    
    // 현재 사용자의 결제 상태 확인
    const currentUser = selectedFriendsData.find(friend => friend.usersId == currentUserId);
    const isCurrentUserCompleted = currentUser && (
        currentUser.paymentStatus === 'paid' || 
        currentUser.paymentStatus === 'completed' || 
        currentUser.paymentAmount === 0
    );
    
    console.log('🔍 현재 사용자 결제 상태:', {
        userId: currentUserId,
        name: currentUser?.usersName,
        status: currentUser?.paymentStatus,
        amount: currentUser?.paymentAmount,
        isCompleted: isCurrentUserCompleted
    });
    
    // 현재 사용자의 결제가 완료된 경우, 다른 참여자들만 검사
    if (isCurrentUserCompleted) {
        const otherParticipantsCompleted = selectedFriendsData.every(friend => {
            // 현재 사용자는 제외
            if (friend.usersId == currentUserId) {
                return true; // 현재 사용자는 항상 통과
            }
            // 다른 참여자들은 결제 완료 상태여야 함
            return friend.paymentStatus === 'paid' || 
                   friend.paymentStatus === 'completed' || 
                   friend.paymentAmount === 0;
        });
        
        console.log('🔍 다른 참여자들 결제 완료 여부:', otherParticipantsCompleted);
        console.log('📊 참여자별 상태 (현재 사용자 제외):', selectedFriendsData.map(f => ({
            name: f.usersName,
            isCurrentUser: f.usersId == currentUserId,
            status: f.paymentStatus,
            amount: f.paymentAmount
        })));
        
        return otherParticipantsCompleted;
    } else {
        // 현재 사용자의 결제가 아직 완료되지 않은 경우, 모든 참여자 검사
        const allCompleted = selectedFriendsData.every(friend => 
            friend.paymentStatus === 'paid' || 
            friend.paymentStatus === 'completed' || 
            friend.paymentAmount === 0
        );
        
        console.log('🔍 전체 결제 완료 여부 (현재 사용자 미완료):', allCompleted);
        console.log('📊 참여자별 상태:', selectedFriendsData.map(f => ({
            name: f.usersName,
            status: f.paymentStatus,
            amount: f.paymentAmount
        })));
        
        return allCompleted;
    }
}

/**
 * 새로고침 버튼을 payment-history로 이동하는 버튼으로 변경
 */
function changeRefreshButtonToPaymentHistory() {
    const refreshBtn = document.getElementById('refreshPaymentStatus');
    if (refreshBtn) {
        refreshBtn.className = 'btn-refresh btn-success';
        refreshBtn.style.background = '#28a745';
        refreshBtn.style.color = 'white';
        refreshBtn.innerHTML = '<i class="bi bi-check-circle"></i> 결제 완료! 내역 보기';
        refreshBtn.onclick = function() {
            window.location.href = UrlConstants.Builder.fullUrl('/user/mypage/payment-history');
        };
        
        // 설명 텍스트도 업데이트
        const refreshSection = refreshBtn.closest('.refresh-section');
        if (refreshSection) {
            const smallText = refreshSection.querySelector('small');
            if (smallText) {
                smallText.textContent = '모든 결제가 완료되었습니다!';
                smallText.style.color = '#28a745';
            }
        }
        
        // 전체 결제 완료 UI 업데이트
        completeAllPayments();
    }
}

 