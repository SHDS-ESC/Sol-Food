/**
 * 친구 초대 페이지 AJAX 기반 관리
 * 버전: 3.0
 * 작성일: 2024-12-28
 */

// 전역 상태 관리
const InviteFriendsState = {
    selectedFriends: new Set(),
    selectedFriendsData: new Map(), // 선택된 친구들의 상세 정보 저장
    currentUser: null,
    currentPage: 1,
    pageSize: 10,
    currentFilter: 'all',
    currentSearch: '',
    totalCount: 0,
    isLoading: false
};

/**
 * 페이지 초기화
 */
document.addEventListener('DOMContentLoaded', function() {
    try {
        // 현재 사용자 정보 로드
        loadCurrentUserInfo();
        
        // 서버에서 선택된 친구 목록 로드
        loadSelectedFriendsFromServer();
        
        // 친구 목록 첫 로딩
        loadFriendsList();
        
        // 검색 이벤트 리스너
        setupSearchListener();
    } catch (error) {
        console.error('❌ 초기화 중 오류 발생:', error);
        SolFoodUtils.showToast('페이지 초기화에 실패했습니다.', 'error');
    }
});

/**
 * 현재 사용자 정보 로드
 */
function loadCurrentUserInfo() {
    const currentUserId = window.currentUserId;
    const currentUserCompanyName = window.currentUserCompanyName;
    const currentUserDepartmentName = window.currentUserDepartmentName;
    const currentUserEmail = window.currentUserEmail;
    const currentUserNickname = window.currentUserNickname;
    const currentUserTel = window.currentUserTel;
    const currentUserProfile = window.currentUserProfile;
    
    InviteFriendsState.currentUser = {
        usersId: parseInt(currentUserId),
        usersName: currentUserNickname,
        usersProfile: currentUserProfile || '',
        companyName: currentUserCompanyName,
        departmentName: currentUserDepartmentName
    };
    
    // 현재 사용자는 항상 선택된 상태
    InviteFriendsState.selectedFriends.add(InviteFriendsState.currentUser.usersId);
    
    // 현재 사용자 정보를 Map에도 저장
    InviteFriendsState.selectedFriendsData.set(InviteFriendsState.currentUser.usersId, {
        usersId: InviteFriendsState.currentUser.usersId,
        usersName: InviteFriendsState.currentUser.usersName,
        usersProfile: InviteFriendsState.currentUser.usersProfile,
        companyName: InviteFriendsState.currentUser.companyName,
        departmentName: InviteFriendsState.currentUser.departmentName
    });
}

/**
 * 서버에서 선택된 친구 목록 로드
 */
function loadSelectedFriendsFromServer() {
    SolFoodUtils.syncToServer('/user/cart/selected-friends', 'GET', null)
        .then(data => {
            if (data.selectedFriendIds && data.selectedFriendIds.length > 0) {
                data.selectedFriendIds.forEach(id => {
                    InviteFriendsState.selectedFriends.add(parseInt(id));
                });
            }
            updateSelectedFriendsDisplay();
        })
        .catch(error => {
            console.error('❌ 선택된 친구 목록 로드 실패:', error);
        });
}

/**
 * 친구 목록 AJAX 로딩
 */
function loadFriendsList() {
    if (InviteFriendsState.isLoading) return;
    
    InviteFriendsState.isLoading = true;
    
    // 로딩 표시
    document.getElementById('friendsList').innerHTML = `
        <div class="text-center py-5">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">로딩중...</span>
            </div>
            <p class="mt-3 text-muted">친구 목록을 불러오는 중...</p>
        </div>
    `;

    const params = new URLSearchParams({
        page: InviteFriendsState.currentPage,
        size: InviteFriendsState.pageSize,
        filter: InviteFriendsState.currentFilter
    });
    
    if (InviteFriendsState.currentSearch) {
        params.set('search', InviteFriendsState.currentSearch);
    }

    SolFoodUtils.syncToServer(`/user/cart/friends-api?${params.toString()}`, 'GET', null)
        .then(data => {
            displayFriendsList(data.friends);
            displayPagination(data.pageMaker, data.currentPage, data.totalCount);
            updateResultInfo(data);
            updateSearchBadge();
        })
        .catch(error => {
            console.error('❌ 친구 목록 로딩 실패:', error);
            document.getElementById('friendsList').innerHTML = `
                <div class="text-center text-muted py-5">
                    <i class="bi bi-exclamation-triangle" style="font-size: 48px; margin-bottom: 16px; opacity: 0.3;"></i>
                    <p>친구 목록을 불러오는데 실패했습니다.</p>
                    <button class="btn btn-primary btn-sm" onclick="loadFriendsList()">다시 시도</button>
                </div>
            `;
        })
        .finally(() => {
            InviteFriendsState.isLoading = false;
        });
}

/**
 * 친구 목록 화면 표시
 */
function displayFriendsList(friends) {
    const friendsList = document.getElementById('friendsList');
    
    if (!friends || friends.length === 0) {
        friendsList.innerHTML = `
            <div class="text-center text-muted py-5">
                <i class="bi bi-search" style="font-size: 48px; margin-bottom: 16px; opacity: 0.3;"></i>
                <p>
                    ${InviteFriendsState.currentSearch 
                        ? `"${InviteFriendsState.currentSearch}" 검색 결과가 없습니다.`
                        : '같은 회사에 초대할 수 있는 사용자가 없습니다.'
                    }
                </p>
            </div>
        `;
        return;
    }

    friendsList.innerHTML = friends.map(user => {
        const isSelected = InviteFriendsState.selectedFriends.has(Number(user.usersId));
        const isCurrentUser = Number(user.usersId) === Number(InviteFriendsState.currentUser?.usersId);
        // 페이지에 표시되는 친구 정보를 Map에 저장 (이미 선택된 친구든 아니든)
        if (!isCurrentUser) { // 현재 사용자는 이미 저장됨
            InviteFriendsState.selectedFriendsData.set(Number(user.usersId), {
                usersId: Number(user.usersId),
                usersName: user.usersName,
                usersProfile: user.usersProfile,
                companyName: user.companyName,
                departmentName: user.departmentName
            });
        }
        return `
            <div class="friend-card${isSelected ? ' selected' : ''}" 
                 data-friend-id="${user.usersId}" 
                 data-user-name="${user.usersName}"
                 data-user-profile="${user.usersProfile || ''}"
                 data-company-name="${user.companyName}"
                 data-department-name="${user.departmentName}"
                 onclick="toggleFriend(this)">
                <div class="friend-avatar" 
                     ${user.usersProfile ? `style=\"background-image: url('${user.usersProfile}');\"` : ''}>
                    ${!user.usersProfile ? user.usersName.substring(0, 1) : ''}
                </div>
                <div class="friend-info">
                    <div class="friend-name">${user.usersName}${isCurrentUser ? ' (나)' : ''}</div>
                    <div class="friend-meta">${user.companyName} - ${user.departmentName}</div>
                </div>
                <button class="select-btn${isSelected ? ' selected' : ''}" tabindex="-1" onclick="event.stopPropagation(); toggleFriend(this.parentElement); return false;">
                  <i class="bi ${isSelected ? 'bi-check-circle-fill' : 'bi-circle'}"></i>
                </button>
            </div>
        `;
    }).join('');
    // 선택된 친구들 표시 업데이트
    updateSelectedFriendsDisplay();
}

/**
 * 페이징 표시
 */
function displayPagination(pageMaker, currentPage, totalCount) {
    const paginationSection = document.getElementById('paginationSection');
    if (!pageMaker || pageMaker.pageCount <= 1) {
        paginationSection.innerHTML = '';
        return;
    }
    let html = '';
    // 이전 페이지
    html += `<li class="page-item${currentPage === 1 ? ' disabled' : ''}">
        <a class="page-link" href="#" tabindex="-1" onclick="goToPage(${currentPage - 1}); return false;" aria-label="이전"><span aria-hidden="true">&laquo;</span></a>
    </li>`;
    // 페이지 번호들
    for (let pageNum = pageMaker.firstPage; pageNum <= pageMaker.lastPage; pageNum++) {
        html += `<li class="page-item${currentPage === pageNum ? ' active' : ''}">
            <a class="page-link" href="#" onclick="goToPage(${pageNum}); return false;">${pageNum}</a>
        </li>`;
    }
    // 다음 페이지
    html += `<li class="page-item${currentPage === pageMaker.pageCount ? ' disabled' : ''}">
        <a class="page-link" href="#" tabindex="-1" onclick="goToPage(${currentPage + 1}); return false;" aria-label="다음"><span aria-hidden="true">&raquo;</span></a>
    </li>`;
    paginationSection.innerHTML = html;
}

/**
 * 결과 정보 업데이트
 */
function updateResultInfo(data) {
    const resultInfo = document.getElementById('resultInfo');
    resultInfo.innerHTML = '';
}

/**
 * 검색 배지 업데이트
 */
function updateSearchBadge() {
    const searchBadge = document.getElementById('searchBadge');
    if (InviteFriendsState.currentSearch) {
        searchBadge.textContent = `"${InviteFriendsState.currentSearch}" 검색 결과`;
        searchBadge.style.display = 'inline-block';
    } else {
        searchBadge.style.display = 'none';
    }
}

/**
 * 페이지 이동 (AJAX)
 */
function goToPage(page) {
    InviteFriendsState.currentPage = page;
    loadFriendsList();
}

/**
 * 필터 변경 (AJAX)
 */
function changeFilter(element, filter) {
    // 탭 UI 업데이트
    document.querySelectorAll('.status-tab').forEach(tab => {
        tab.classList.remove('active');
    });
    element.classList.add('active');
    
    // 상태 업데이트 및 리로드
    InviteFriendsState.currentFilter = filter;
    InviteFriendsState.currentPage = 1;
    loadFriendsList();
}

/**
 * 검색 이벤트 리스너 설정
 */
function setupSearchListener() {
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        // 디바운스된 검색
        searchInput.addEventListener('input', SolFoodUtils.debounce(function() {
            InviteFriendsState.currentSearch = this.value.trim();
            InviteFriendsState.currentPage = 1;
            loadFriendsList();
        }, 300));
        
        // Enter 키 처리
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                performSearch();
            }
        });
    }
}

/**
 * 검색 실행
 */
function performSearch() {
    const searchInput = document.getElementById('searchInput');
    InviteFriendsState.currentSearch = searchInput.value.trim();
    InviteFriendsState.currentPage = 1;
    loadFriendsList();
}

/**
 * 검색 초기화
 */
function clearSearch() {
    document.getElementById('searchInput').value = '';
    InviteFriendsState.currentSearch = '';
    InviteFriendsState.currentPage = 1;
    loadFriendsList();
}

/**
 * 선택된 친구 제거
 */
function removeFriend(friendId, friendName) {
    friendId = Number(friendId); // 항상 숫자로 변환
    // 현재 사용자는 제거할 수 없음
    if (friendId === Number(InviteFriendsState.currentUser?.usersId)) {
        SolFoodUtils.showToast('본인은 제거할 수 없습니다.', 'warning');
        return;
    }
    // 선택에서 제거
    InviteFriendsState.selectedFriends.delete(friendId);
    // 친구 목록에서도 선택 상태 해제 (현재 페이지에 표시된 경우)
    // 서버 동기화 (디바운스)
    syncToServerDebounced();
    // UI 업데이트
    updateSelectedFriendsDisplay();
    loadFriendsList(); // 친구 리스트도 즉시 다시 렌더링
    // 제거 알림
    SolFoodUtils.showToast(`${friendName}님을 제거했습니다.`, 'info');
}

/**
 * 친구 선택 토글
 */
function toggleFriend(element) {
    const friendId = Number(element.dataset.friendId);
    const friendName = element.dataset.userName;
    const friendProfile = element.dataset.userProfile;
    const companyName = element.dataset.companyName;
    const departmentName = element.dataset.departmentName;
    // 이미 선택된 친구라면 아무 동작도 하지 않음 (X버튼으로만 제거)
    if (InviteFriendsState.selectedFriends.has(friendId)) {
        return;
    }
    InviteFriendsState.selectedFriends.add(friendId);
    if (!InviteFriendsState.selectedFriendsData.has(friendId)) {
        InviteFriendsState.selectedFriendsData.set(friendId, {
            usersId: friendId,
            usersName: friendName,
            usersProfile: friendProfile,
            companyName: companyName,
            departmentName: departmentName
        });
    }
    syncToServerDebounced();
    loadFriendsList();
}

/**
 * 디바운스된 서버 동기화
 */
const syncToServerDebounced = SolFoodUtils.debounce(function() {
    const selectedArray = Array.from(InviteFriendsState.selectedFriends);
    
    SolFoodUtils.syncToServer('/user/cart/friends/sync', 'POST', {
        selectedFriendIds: selectedArray
    })
    .then(response => {
        console.log('✅ 서버 동기화 완료:', response);
    })
    .catch(error => {
        console.error('❌ 서버 동기화 실패:', error);
        SolFoodUtils.showToast('선택 상태 저장에 실패했습니다.', 'error');
    });
}, 500);

/**
 * 선택된 친구들 표시 업데이트
 */
function updateSelectedFriendsDisplay() {
    const selectedFriendsList = document.getElementById('selectedFriendsList');
    const selectedCountBadge = document.getElementById('selectedCountBadge');
    const selectedCount = document.getElementById('selectedCount');
    const selectedMessage = document.getElementById('selectedMessage');
    const inviteBtn = document.getElementById('inviteBtn');
    
    const count = InviteFriendsState.selectedFriends.size;
    
    // 선택된 친구들 리스트 업데이트 (저장된 데이터 기반)
    if (count === 0) {
        selectedFriendsList.innerHTML = '';
    } else {
        let listHTML = '';
        // 현재 사용자 먼저 표시
        if (InviteFriendsState.currentUser && InviteFriendsState.selectedFriends.has(InviteFriendsState.currentUser.usersId)) {
            const user = InviteFriendsState.currentUser;
            listHTML += `
                <div class="selected-friend-tag" data-selected-friend-id="${user.usersId}">
                  <span class="avatar" style="background-image:${user.usersProfile ? `url('${user.usersProfile}')` : 'none'};">
                    ${!user.usersProfile ? user.usersName.substring(0, 1) : ''}
                    <span class="badge-me"><i class="bi bi-person-fill"></i></span>
                  </span>
                  <span class="name">${user.usersName}</span>
                </div>
            `;
        }
        // 다른 선택된 친구들 표시
        InviteFriendsState.selectedFriendsData.forEach((friendData, friendId) => {
            if (friendId !== InviteFriendsState.currentUser?.usersId && InviteFriendsState.selectedFriends.has(friendId)) {
                const friendProfile = friendData.usersProfile;
                const friendName = friendData.usersName;
                listHTML += `
                  <div class="selected-friend-tag" data-selected-friend-id="${friendId}">
                    <span class="avatar" style="background-image:${friendProfile ? `url('${friendProfile}')` : 'none'};">
                      ${!friendProfile ? friendName.substring(0, 1) : ''}
                      <button class="remove-btn" title="제거" onclick="removeFriend('${friendId}', '${friendName}');event.stopPropagation();"><i class="bi bi-x"></i></button>
                    </span>
                    <span class="name">${friendName}</span>
                  </div>
                `;
            }
        });
        selectedFriendsList.innerHTML = listHTML;
    }
    
    // 카운트 업데이트
    selectedCountBadge.textContent = count;
    selectedCount.textContent = count + '명';
    
    // 메시지 업데이트
    if (count === 0) {
        selectedMessage.textContent = '친구를 선택해주세요.';
    } else if (count === 1) {
        selectedMessage.textContent = '나 혼자 결제합니다.';
    } else {
        selectedMessage.textContent = `총 ${count}명이 함께 결제합니다.`;
    }
    
    // 버튼 상태 업데이트
    if (count > 0) {
        inviteBtn.disabled = false;
        inviteBtn.classList.add('active');
        inviteBtn.textContent = count === 1 ? '혼자 결제하기' : `${count}명에게 초대 보내기`;
    } else {
        inviteBtn.disabled = true;
        inviteBtn.classList.remove('active');
        inviteBtn.textContent = '친구를 선택해주세요';
    }
}

/**
 * 초대하기 처리
 */
function handleInvite() {
    if (InviteFriendsState.selectedFriends.size === 0) {
        SolFoodUtils.showToast('친구를 선택해주세요.', 'warning');
        return;
    }
    
    const selectedArray = Array.from(InviteFriendsState.selectedFriends);
    console.log('🎯 초대 처리 중:', selectedArray);
    
    // 로딩 표시
    const inviteBtn = document.getElementById('inviteBtn');
    const originalText = inviteBtn.textContent;
    inviteBtn.disabled = true;
    inviteBtn.textContent = '처리 중...';
    
    // 서버로 최종 확정 요청
    SolFoodUtils.syncToServer('/user/cart/invite-confirm', 'POST', {
        selectedFriendIds: selectedArray
    })
    .then(response => {
        console.log('✅ 초대 완료:', response);
        
        if (response.result === 'success') {
            SolFoodUtils.showToast('친구 초대가 완료되었습니다!', 'success');
            
            // 수락 대기 페이지로 이동
            setTimeout(() => {
                window.location.href = UrlConstants.Builder.fullUrl('/user/cart/make-bill');
            }, 1000);
        } else {
            throw new Error(response.message || '초대 처리에 실패했습니다.');
        }
    })
    .catch(error => {
        console.error('❌ 초대 실패:', error);
        SolFoodUtils.showToast('초대 처리에 실패했습니다.', 'error');
        
        // 버튼 복구
        inviteBtn.disabled = false;
        inviteBtn.textContent = originalText;
    });
}

/**
 * 뒤로가기
 */
function goBack() {
    history.back();
}

// 전역 함수들 export
window.removeFriend = removeFriend;
window.toggleFriend = toggleFriend;
window.goToPage = goToPage;
window.changeFilter = changeFilter;
window.performSearch = performSearch;
window.clearSearch = clearSearch;
window.handleInvite = handleInvite;
window.goBack = goBack;

// 뒤로가기(bfcache) 등으로 복원될 때 버튼 상태 초기화
window.addEventListener('pageshow', function() {
    updateSelectedFriendsDisplay();
}); 