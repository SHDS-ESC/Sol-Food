// 수락 대기 페이지 JavaScript
let acceptedFriends = 0;
let selectedFriendsData = [];
let totalAmount = 0;
let splitAmounts = {};

// 페이지 로드 시 선택된 친구들 정보 로드
document.addEventListener('DOMContentLoaded', function() {
    console.log('💰 결제 대기 페이지 로드됨');
    

    
    // 게임 결과 확인 및 처리
    const gameResult = getGameResultFromURL();
    if (gameResult) {
        console.log('🎮 게임 결과 감지됨:', gameResult);
        // URL에서 gameResult 파라미터 제거
        removeGameResultFromURL();
    }
    

    
    // 친구 데이터 로드 (JSP에서 렌더링된 데이터 사용)
    loadSelectedFriends();
    
    // 게임 결과가 있다면 적용
    if (gameResult) {
        setTimeout(() => {
            applyGameResult(gameResult);
        }, 500); // 데이터 로드 후 적용
    }
    
    updateProgress();
});



// 가격 분할 계산
function calculateSplitAmounts() {
    if (totalAmount <= 0 || selectedFriendsData.length === 0) {
        return;
    }
    
    const totalPeople = selectedFriendsData.length;
    const baseAmount = Math.floor(totalAmount / totalPeople); // 기본 분할 금액
    const remainder = totalAmount % totalPeople; // 나머지
    
    // 현재 사용자 ID 찾기
    const currentUserData = document.getElementById('currentUserData');
    const currentUserId = currentUserData ? currentUserData.getAttribute('data-current-user-id') : null;
    
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

function loadSelectedFriends() {
    // JSP에서 렌더링된 데이터를 바로 로드
    fetchFriendsData();
}

function fetchFriendsData() {
    try {
        const selectedFriendsScript = document.getElementById('selectedFriendsData');
        const cartScript = document.getElementById('cartData');
        
        if (selectedFriendsScript && cartScript) {
            selectedFriendsData = JSON.parse(selectedFriendsScript.textContent);
            const cartData = JSON.parse(cartScript.textContent);
            totalAmount = cartData.totalAmount || 0;
            
            console.log('친구 데이터 로드:', selectedFriendsData.length + '명, 총 금액:', totalAmount);
            
            if (selectedFriendsData.length > 0) {
                displayFriends();
            } else {
                displayNoFriends();
            }
        } else {
            console.error('서버 렌더링 데이터를 찾을 수 없습니다.');
            displayNoFriends();
        }
    } catch (error) {
        console.error('데이터 파싱 오류:', error);
        displayNoFriends();
    }
}

function displayFriends() {
    const friendsContainer = document.getElementById('friendsStatus');
    friendsContainer.innerHTML = '';
    
    selectedFriendsData.forEach((friend, index) => {
        const friendElement = createFriendElement(friend, index);
        friendsContainer.appendChild(friendElement);
    });
    
    // 모든 사용자 초기 상태 설정 (0에서 시작)
    initializeUserStatus();
    
    // 가격 분할 계산
    if (totalAmount > 0) {
        calculateSplitAmounts();
    }
    
    console.log('친구 표시 완료:', selectedFriendsData.length, '명');
}

function updateFriendDisplayWithAmounts() {
    selectedFriendsData.forEach(friend => {
        const friendElement = document.getElementById('friend-' + friend.usersId);
        const amount = splitAmounts[friend.usersId] || 0;
        
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
            
            // 0원인 경우 결제 버튼 숨기고 무료 표시
            if (amount === 0) {
                if (payBtn) {
                    payBtn.style.display = 'none';
                }
                if (statusBadge) {
                    statusBadge.className = 'status-badge status-accepted';
                    statusBadge.textContent = '무료';
                    statusBadge.style.background = '#28a745';
                }
                
                // 무료 사용자는 자동으로 결제 완료 처리
                setTimeout(() => {
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
                }, 500);
            } else {
                // 0원이 아닌 경우 결제 버튼 표시
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
    });
}

function createFriendElement(friend, index) {
    const div = document.createElement('div');
    const isCurrentUser = friend.usersEmail === 'CURRENT_USER';
    
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
            const currentUserData = document.getElementById('currentUserData');
            if (currentUserData) {
                friend.companyName = currentUserData.getAttribute('data-current-user-company-name') || friend.companyName;
                friend.departmentName = currentUserData.getAttribute('data-current-user-department-name') || friend.departmentName;
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
    amountDiv.textContent = '계산 중...';
    
    infoDiv.appendChild(nameDiv);
    infoDiv.appendChild(companyDiv);
    infoDiv.appendChild(amountDiv);
    
    const actionsDiv = document.createElement('div');
    actionsDiv.className = 'status-actions';
    
    const statusBadge = document.createElement('span');
    statusBadge.id = 'badge-' + friend.usersId;
    
    // 결제 버튼 생성
    const payBtn = document.createElement('button');
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
        proceedToPayment(friend.usersId);
    };
    
    // 현재 사용자든 다른 사용자든 모두 동일하게 "결제 대기" 상태로 시작
    statusBadge.className = 'status-badge status-ready';
    statusBadge.textContent = '결제 대기';
    statusBadge.style.background = '#17a2b8';
    
    // 현재 사용자인 경우 "(나)" 표시 추가
    if (isCurrentUser) {
        statusBadge.innerHTML = '결제 대기 <i class="bi bi-person" style="margin-left: 5px; font-size: 10px;"></i>';
    }
    
    actionsDiv.appendChild(statusBadge);
    actionsDiv.appendChild(payBtn);
    
    div.appendChild(avatarDiv);
    div.appendChild(infoDiv);
    div.appendChild(actionsDiv);
    
    return div;
}

function initializeUserStatus() {
    const hasGameResult = new URLSearchParams(window.location.search).has('gameResult');
    
    if (!hasGameResult) {
        acceptedFriends = 0;
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
    window.location.href = UrlConstants.Builder.fullUrl('/user/cart/invite-friends');
}

function cancelInvitation() {
    if (confirm('이전 페이지로 돌아가시겠습니까?')) {
        window.location.href = UrlConstants.Builder.fullUrl('/user/cart/invite-friends');
    }
}



function goToMiniGame() {
    if (selectedFriendsData.length === 0) {
        alert('참가자 정보를 불러오는 중입니다. 잠시 후 다시 시도해주세요.');
        return;
    }
    
    if (totalAmount <= 0) {
        alert('총 결제 금액 정보를 불러오는 중입니다. 잠시 후 다시 시도해주세요.');
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

// 결제 진행 함수
function proceedToPayment(userId) {
    const userAmount = splitAmounts[userId];
    if (!userAmount) {
        alert('결제 금액을 계산할 수 없습니다.');
        return;
    }
    
    console.log(`💳 사용자 ${userId}의 결제 진행: ₩${userAmount.toLocaleString()}`);
    
    // 결제 버튼 비활성화 및 로딩 상태로 변경
    const payBtn = document.getElementById('pay-btn-' + userId);
    if (payBtn) {
        payBtn.textContent = '결제 중...';
        payBtn.disabled = true;
        payBtn.style.background = '#6c757d';
    }
    
    // 결제 진행 확인 알림
    const confirmPayment = confirm(`결제 금액: ₩${userAmount.toLocaleString()}\n결제를 진행하시겠습니까?`);
    
    if (confirmPayment) {
        // 결제 진행 로직은 다른 사람이 작업 중이므로 임시로 처리
        console.log('결제 API 호출 예정...');
        
        // 임시: 2초 후 결제 완료 처리
        setTimeout(() => {
            markPaymentComplete(userId);
            alert('결제가 완료되었습니다!');
        }, 2000);
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
            alert(message);
        }, 100);
        
        // 콘솔에도 로그
        console.log('📢 게임 결과 알림:', message);
    }
} 