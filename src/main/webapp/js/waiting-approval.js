// 수락 대기 페이지 JavaScript
let totalFriends = 0;
let acceptedFriends = 0;
let selectedFriendsData = [];

// 페이지 로드 시 선택된 친구들 정보 로드
document.addEventListener('DOMContentLoaded', function() {
    // 안전하게 데이터 가져오기
    const friendCountElement = document.getElementById('friendCountData');
    totalFriends = friendCountElement ? parseInt(friendCountElement.value) || 0 : 0;
    
    console.log('페이지 로드, 총 친구 수:', totalFriends);
    loadSelectedFriends();
    updateProgress();
});

function loadSelectedFriends() {
    if (totalFriends > 0) {
        fetchFriendsData();
    } else {
        console.log('선택된 친구가 없음 (혼자 결제)');
        displayNoFriends();
    }
}

function fetchFriendsData() {
    fetch(UrlConstants.Builder.fullUrl('/user/cart/get-selected-friends'), {
        method: 'GET',
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            selectedFriendsData = data.friends;
            console.log('친구 데이터 로드 성공:', selectedFriendsData);
            displayFriends();
        } else {
            console.error('친구 데이터 로드 실패:', data.message);
            displayNoFriends();
        }
    })
    .catch(error => {
        console.error('친구 데이터 로드 오류:', error);
        displayNoFriends();
    });
}

function displayFriends() {
    const friendsContainer = document.getElementById('friendsStatus');
    friendsContainer.innerHTML = '';
    
    selectedFriendsData.forEach((friend, index) => {
        const friendElement = createFriendElement(friend, index);
        friendsContainer.appendChild(friendElement);
    });
}

function createFriendElement(friend, index) {
    const div = document.createElement('div');
    div.className = 'friend-status pending';
    div.setAttribute('data-friend-id', friend.usersId);
    div.id = 'friend-' + friend.usersId;
    
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
    nameDiv.textContent = friend.usersName;
    
    const companyDiv = document.createElement('div');
    companyDiv.className = 'friend-company';
    companyDiv.textContent = friend.companyName + ' - ' + friend.departmentName;
    
    infoDiv.appendChild(nameDiv);
    infoDiv.appendChild(companyDiv);
    
    const actionsDiv = document.createElement('div');
    actionsDiv.className = 'status-actions';
    
    const statusBadge = document.createElement('span');
    statusBadge.className = 'status-badge status-pending';
    statusBadge.textContent = '대기중';
    statusBadge.id = 'badge-' + friend.usersId;
    
    const acceptBtn = document.createElement('button');
    acceptBtn.className = 'accept-btn';
    acceptBtn.textContent = '수락';
    acceptBtn.id = 'btn-' + friend.usersId;
    acceptBtn.onclick = function() {
        acceptFriend(friend.usersId, index);
    };
    
    actionsDiv.appendChild(statusBadge);
    actionsDiv.appendChild(acceptBtn);
    
    div.appendChild(avatarDiv);
    div.appendChild(infoDiv);
    div.appendChild(actionsDiv);
    
    return div;
}

function acceptFriend(friendId, index) {
    console.log('친구 수락:', friendId, 'index:', index);
    
    const friendElement = document.querySelector(`[data-friend-id="${friendId}"]`) || document.getElementById('friend-' + friendId);
    
    if (friendElement) {
        friendElement.classList.remove('pending');
        friendElement.classList.add('accepted');
        friendElement.style.background = '#d1edff';
        friendElement.style.borderLeft = '4px solid #28a745';
        
        const statusBadge = friendElement.querySelector('.status-badge') || document.getElementById('badge-' + friendId);
        if (statusBadge) {
            statusBadge.className = 'status-badge status-accepted';
            statusBadge.textContent = '수락 완료';
        }
        
        const acceptBtn = friendElement.querySelector('.accept-btn') || document.getElementById('btn-' + friendId);
        if (acceptBtn) {
            acceptBtn.style.display = 'none';
        }
        
        acceptedFriends++;
        updateProgress();
        
        if (statusBadge) {
            addCheckIcon(statusBadge);
        }
        
        if (acceptedFriends === totalFriends) {
            completeAllAcceptance();
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
    completeAllAcceptance();
}

function updateProgress() {
    const acceptedElement = document.getElementById('acceptedCount');
    const totalElement = document.getElementById('totalCount');
    
    if (acceptedElement) acceptedElement.textContent = acceptedFriends;
    if (totalElement) totalElement.textContent = totalFriends;
    
    const continueBtn = document.getElementById('continueBtn');
    if (continueBtn) {
        if (acceptedFriends === totalFriends) {
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

function completeAllAcceptance() {
    console.log('모든 친구가 수락 완료!');
    
    const statusIcon = document.getElementById('statusIcon');
    if (statusIcon) {
        statusIcon.className = 'bi bi-check-circle-fill status-icon';
        statusIcon.style.color = '#28a745';
        statusIcon.style.animation = 'none';
    }
    
    const statusTitle = document.getElementById('statusTitle');
    if (statusTitle) {
        statusTitle.textContent = '모든 친구가 수락했습니다! 🎉';
    }
    
    const statusDesc = document.getElementById('statusDesc');
    if (statusDesc) {
        statusDesc.innerHTML = '이제 함께 결제를 진행할 수 있습니다.<br>아래 버튼을 클릭해주세요!';
    }
    
    const continueBtn = document.getElementById('continueBtn');
    if (continueBtn) {
        continueBtn.classList.add('active');
        continueBtn.disabled = false;
        continueBtn.innerHTML = '<i class="bi bi-credit-card"></i> 함께 결제하기';
        continueBtn.style.background = 'linear-gradient(135deg, #28a745, #20c997)';
    }
}

function goBack() {
    window.location.href = UrlConstants.Builder.fullUrl('/user/cart/invite-friends');
}

function cancelInvitation() {
    if (confirm('초대를 취소하시겠습니까?')) {
        window.location.href = UrlConstants.Builder.fullUrl('/user/cart/payment-method');
    }
}

function proceedToPayment() {
    if (acceptedFriends === totalFriends) {
        alert('결제 기능은 추후 구현 예정입니다.');
    } else {
        alert('모든 친구의 수락을 기다려주세요.');
    }
}

function goToMiniGame() {
    const messageElement = document.getElementById('miniGameMessageData');
    const message = messageElement ? messageElement.value : '준비중입니다';
    alert(message);
} 