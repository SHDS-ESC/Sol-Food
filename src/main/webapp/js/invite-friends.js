// 친구 초대 페이지 JavaScript
let selectedFriends = [];
let selectedFriendsData = {}; // 선택된 친구들의 정보를 저장

// 페이지 로드 시 초기 설정
document.addEventListener('DOMContentLoaded', function() {
    console.log('페이지 로드 시작');
    
    // DOM이 완전히 로드될 때까지 잠시 대기
    setTimeout(function() {
        initializePage();
    }, 100);
});

function initializePage() {
    console.log('페이지 초기화 시작');
    
    // URL 파라미터에서만 선택된 친구들 복원 (세션 사용 안함)
    const urlParams = new URLSearchParams(window.location.search);
    const selectedParam = urlParams.get('selected');
    
    console.log('URL 파라미터 selected:', selectedParam);
    
    if (selectedParam) {
        selectedFriends = selectedParam.split(',').filter(id => id.trim() !== '');
        console.log('URL에서 선택된 친구들 복원:', selectedFriends);
        
        // 먼저 현재 페이지의 친구들 정보 수집
        collectCurrentPageFriendsData();
        
        // 세션 스토리지에서 친구 정보 복원
        restoreSelectedFriendsData();
        
        // 선택된 친구가 있으면 섹션 표시
        if (selectedFriends.length > 0) {
            const selectedFriendsSection = document.getElementById('selectedFriendsSection');
            if (selectedFriendsSection) {
                selectedFriendsSection.style.display = 'block';
            }
        }
        
        // 친구들 복원
        restoreSelectedFriends();
    } else {
        // 선택된 친구가 없으면 섹션 숨김
        const selectedFriendsSection = document.getElementById('selectedFriendsSection');
        if (selectedFriendsSection) {
            selectedFriendsSection.style.display = 'none';
        }
    }
    
    const friendItems = document.querySelectorAll('.friend-item');
    console.log('친구 수:', friendItems.length);
    
    updateSelectedCount();
    updateSelectedFriendsSection();
    
    // 페이지 로드 시 페이징 링크도 업데이트
    updatePaginationLinks();
    
    console.log('초기화 완료, 선택된 친구 수:', selectedFriends.length);
    
    // 이벤트 리스너 설정
    setupEventListeners();
}

// 현재 페이지의 친구들 정보 수집
function collectCurrentPageFriendsData() {
    const friendItems = document.querySelectorAll('.friend-item');
    friendItems.forEach(item => {
        const friendId = item.getAttribute('data-friend-id');
        const friendName = item.getAttribute('data-user-name');
        const friendProfile = item.getAttribute('data-user-profile');
        const friendAvatar = item.querySelector('.friend-avatar');
        const friendCompanyInfo = item.getAttribute('data-company-info');
        
        if (friendId && friendName) {
            selectedFriendsData[friendId] = {
                id: friendId,
                name: friendName,
                profileUrl: friendProfile || '',
                avatarStyle: friendAvatar ? friendAvatar.style.backgroundImage : '',
                companyInfo: friendCompanyInfo || ''
            };
            
            console.log('친구 정보 수집:', friendId, selectedFriendsData[friendId]);
        }
    });
    
    // 세션 스토리지에 저장
    saveSelectedFriendsData();
}

// 선택된 친구들 정보를 세션 스토리지에 저장
function saveSelectedFriendsData() {
    try {
        sessionStorage.setItem('selectedFriendsData', JSON.stringify(selectedFriendsData));
    } catch (e) {
        console.warn('세션 스토리지 저장 실패:', e);
    }
}

// 세션 스토리지에서 선택된 친구들 정보 복원
function restoreSelectedFriendsData() {
    try {
        const saved = sessionStorage.getItem('selectedFriendsData');
        if (saved) {
            const savedData = JSON.parse(saved);
            selectedFriendsData = { ...selectedFriendsData, ...savedData };
            console.log('세션 스토리지에서 친구 정보 복원:', selectedFriendsData);
        }
    } catch (e) {
        console.warn('세션 스토리지 복원 실패:', e);
    }
}

function setupEventListeners() {
    // 탭 전환 이벤트 리스너
    document.querySelectorAll('.status-tab').forEach(tab => {
        tab.addEventListener('click', function() {
            const filter = this.dataset.filter;
            console.log('탭 클릭:', filter);
            
            // 선택된 친구들 정보 업데이트
            updateSelectedInput();
            
            // 필터 파라미터 업데이트
            const filterInput = document.getElementById('filterInput');
            if (filterInput) {
                filterInput.value = filter;
            }
            
            // 페이지를 1로 리셋하고 서버에 요청
            const searchForm = document.getElementById('searchForm');
            if (searchForm) {
                // 페이지를 1로 리셋
                const pageInput = searchForm.querySelector('input[name="page"]');
                if (pageInput) {
                    pageInput.value = '1';
                }
                
                // 폼 제출
                searchForm.submit();
            }
        });
    });
    
    // Enter 키 검색 이벤트
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                updateSelectedInput();
                this.closest('form').submit();
            }
        });
    }
    
    // 검색 폼 제출 이벤트
    const searchForm = document.getElementById('searchForm');
    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            updateSelectedInput();
        });
    }
}

// 선택된 친구들 복원 (URL 파라미터에서)
function restoreSelectedFriends() {
    console.log('친구들 복원 시작, 선택된 친구 수:', selectedFriends.length);
    
    const currentPageFriends = [];
    const missingFriends = [];
    
    selectedFriends.forEach(friendId => {
        // 현재 페이지에 있는 친구인지 확인
        const friendElement = document.querySelector(`[data-friend-id="${friendId}"]`);
        if (friendElement) {
            console.log('현재 페이지에서 친구 복원:', friendId);
            friendElement.classList.add('selected');
            addSelectedFriendDisplay(friendElement);
            currentPageFriends.push(friendId);
        } else {
            // 현재 페이지에 없는 친구는 저장된 정보로 먼저 시도
            console.log('저장된 정보로 친구 복원 시도:', friendId);
            const friendData = selectedFriendsData[friendId];
            if (friendData) {
                addSelectedFriendDisplayFromData(friendData);
            } else {
                console.log('저장된 정보 없음, 서버에서 가져와야 함:', friendId);
                missingFriends.push(friendId);
            }
        }
    });
    
    // 서버에서 가져와야 하는 친구들이 있으면 AJAX 호출
    if (missingFriends.length > 0) {
        console.log('서버에서 친구 정보 가져오기:', missingFriends);
        fetchMissingFriendsFromServer(missingFriends);
    }
    
    updateSelectedFriendsSection();
}

// 서버에서 누락된 친구들의 정보를 가져오기
function fetchMissingFriendsFromServer(friendIds) {
    console.log('서버에서 친구 정보 요청:', friendIds);
    
    // 로딩 표시 추가
    const selectedFriendsList = document.getElementById('selectedFriendsList');
    const loadingElement = document.createElement('div');
    loadingElement.id = 'loading-friends';
    loadingElement.className = 'selected-friend-item';
    loadingElement.innerHTML = `
        <div class="selected-friend-avatar" style="background: #f8f9fa; border: 2px dashed #dee2e6;">
            <i class="bi bi-hourglass-split" style="color: #6c757d; animation: spin 2s linear infinite;"></i>
        </div>
        <div class="selected-friend-name" style="color: #6c757d; font-size: 11px;">로딩중...</div>
    `;
    selectedFriendsList.appendChild(loadingElement);
    
    fetch(UrlConstants.Builder.fullUrl('/user/cart/get-friends-by-ids'), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify(friendIds)
    })
    .then(response => response.json())
    .then(data => {
        console.log('서버 응답:', data);
        
        // 로딩 표시 제거
        const loadingEl = document.getElementById('loading-friends');
        if (loadingEl) {
            loadingEl.remove();
        }
        
        if (data.result === 'success') {
            data.friends.forEach(friend => {
                // 친구 정보 저장
                selectedFriendsData[friend.usersId] = {
                    id: friend.usersId.toString(),
                    name: friend.usersName,
                    profileUrl: friend.usersProfile || '',
                    companyInfo: `${friend.companyName} - ${friend.departmentName}`
                };
                
                // 상단에 표시
                addSelectedFriendDisplayFromData(selectedFriendsData[friend.usersId]);
            });
            
            // 세션 스토리지에 저장
            saveSelectedFriendsData();
            
            console.log('서버에서 친구 정보 로드 완료:', data.friends.length + '명');
        } else {
            console.error('친구 정보 가져오기 실패:', data.message);
        }
    })
    .catch(error => {
        console.error('서버 통신 오류:', error);
        
        // 오류 시에도 로딩 표시 제거
        const loadingEl = document.getElementById('loading-friends');
        if (loadingEl) {
            loadingEl.remove();
        }
    });
}

// 저장된 데이터로 선택된 친구 표시
function addSelectedFriendDisplayFromData(friendData) {
    console.log('저장된 데이터로 친구 표시:', friendData);
    
    const selectedFriendsList = document.getElementById('selectedFriendsList');
    
    if (!selectedFriendsList) {
        console.error('selectedFriendsList 요소를 찾을 수 없습니다!');
        return;
    }
    
    // 이미 존재하는지 확인
    if (selectedFriendsList.querySelector(`[data-selected-friend-id="${friendData.id}"]`)) {
        console.log('이미 표시된 친구:', friendData.id);
        return;
    }
    
    const selectedFriendItem = document.createElement('div');
    selectedFriendItem.className = 'selected-friend-item';
    selectedFriendItem.setAttribute('data-selected-friend-id', friendData.id);
    
    // 프로필 이미지 처리
    let avatarContent = '';
    let avatarStyle = '';
    
    if (friendData.profileUrl && friendData.profileUrl.trim() !== '') {
        // 프로필 이미지가 있는 경우
        avatarStyle = `background-image: url('${friendData.profileUrl}');`;
        avatarContent = '';
    } else {
        // 프로필 이미지가 없는 경우 이름 첫 글자
        avatarContent = friendData.name.substring(0, 1);
        avatarStyle = '';
    }
    
    selectedFriendItem.innerHTML = `
        <div class="selected-friend-avatar" style="${avatarStyle}">
            ${avatarContent}
            <div class="remove-friend-btn" onclick="removeFriend('${friendData.id}')">
                <i class="bi bi-dash"></i>
            </div>
        </div>
        <div class="selected-friend-name">${friendData.name}</div>
    `;
    
    selectedFriendsList.appendChild(selectedFriendItem);
    console.log('저장된 데이터로 친구 표시 완료:', friendData.id);
}

// 뒤로가기 기능
function goBack() {
    window.history.back();
}

function toggleFriend(element) {
    console.log('toggleFriend 호출됨', element);
    
    const friendId = element.getAttribute('data-friend-id');
    const friendName = element.getAttribute('data-user-name');
    const friendProfile = element.getAttribute('data-user-profile');
    
    console.log('친구 ID:', friendId, '이름:', friendName, '프로필:', friendProfile);
    
    if (!friendId) {
        alert('친구 정보를 찾을 수 없습니다. 페이지를 새로고침 해주세요.');
        return;
    }
    
    // 친구 정보 저장
    const friendAvatar = element.querySelector('.friend-avatar');
    const friendCompanyInfo = element.getAttribute('data-company-info');
    
    selectedFriendsData[friendId] = {
        id: friendId,
        name: friendName,
        profileUrl: friendProfile || '',
        avatarStyle: friendAvatar ? friendAvatar.style.backgroundImage : '',
        companyInfo: friendCompanyInfo || ''
    };
    
    if (element.classList.contains('selected')) {
        console.log('친구 선택 해제:', friendId);
        element.classList.remove('selected');
        selectedFriends = selectedFriends.filter(id => id !== friendId);
        removeSelectedFriendDisplay(friendId);
        
        // 선택 해제된 친구 정보는 저장된 데이터에서 제거하지 않음 (다른 페이지에서 선택될 수 있음)
    } else {
        console.log('친구 선택:', friendId);
        element.classList.add('selected');
        selectedFriends.push(friendId);
        addSelectedFriendDisplay(element);
    }
    
    console.log('현재 선택된 친구들:', selectedFriends);
    
    // 세션 스토리지에 저장
    saveSelectedFriendsData();
    
    updateSelectedCount();
    updateSelectedInput();
    updateSelectedFriendsSection();
}

// 선택된 친구를 상단에 표시
function addSelectedFriendDisplay(friendElement) {
    console.log('addSelectedFriendDisplay 호출됨', friendElement);
    
    const friendId = friendElement.getAttribute('data-friend-id');
    const friendName = friendElement.getAttribute('data-user-name');
    const friendProfile = friendElement.getAttribute('data-user-profile');
    const friendAvatar = friendElement.querySelector('.friend-avatar');
    
    console.log('표시할 친구 정보:', friendId, friendName, '프로필:', friendProfile);
    
    const selectedFriendsList = document.getElementById('selectedFriendsList');
    
    if (!selectedFriendsList) {
        console.error('selectedFriendsList 요소를 찾을 수 없습니다!');
        return;
    }
    
    // 이미 존재하는지 확인
    if (selectedFriendsList.querySelector(`[data-selected-friend-id="${friendId}"]`)) {
        console.log('이미 표시된 친구:', friendId);
        return;
    }
    
    const selectedFriendItem = document.createElement('div');
    selectedFriendItem.className = 'selected-friend-item';
    selectedFriendItem.setAttribute('data-selected-friend-id', friendId);
    
    // 프로필 이미지 처리
    let avatarContent = '';
    let avatarStyle = '';
    
    if (friendProfile && friendProfile.trim() !== '') {
        // 프로필 이미지가 있는 경우
        avatarStyle = `background-image: url('${friendProfile}');`;
        avatarContent = '';
    } else {
        // 프로필 이미지가 없는 경우 이름 첫 글자
        avatarContent = friendName.substring(0, 1);
        avatarStyle = '';
    }
    
    selectedFriendItem.innerHTML = `
        <div class="selected-friend-avatar" style="${avatarStyle}">
            ${avatarContent}
            <div class="remove-friend-btn" onclick="removeFriend('${friendId}')">
                <i class="bi bi-dash"></i>
            </div>
        </div>
        <div class="selected-friend-name">${friendName}</div>
    `;
    
    selectedFriendsList.appendChild(selectedFriendItem);
    console.log('친구 표시 추가 완료:', friendId);
}

// 선택된 친구를 상단에서 제거
function removeSelectedFriendDisplay(friendId) {
    const selectedFriendsList = document.getElementById('selectedFriendsList');
    const selectedFriendItem = selectedFriendsList.querySelector(`[data-selected-friend-id="${friendId}"]`);
    
    if (selectedFriendItem) {
        selectedFriendItem.remove();
    }
}

// 친구 제거 (빨간 - 버튼 클릭 시)
function removeFriend(friendId) {
    // 선택 목록에서 제거
    selectedFriends = selectedFriends.filter(id => id !== friendId);
    
    // 상단 표시에서 제거
    removeSelectedFriendDisplay(friendId);
    
    // 친구 목록에서 selected 클래스 제거
    const friendElement = document.querySelector(`[data-friend-id="${friendId}"]`);
    if (friendElement) {
        friendElement.classList.remove('selected');
    }
    
    updateSelectedCount();
    updateSelectedInput();
    updateSelectedFriendsSection();
}

// 선택된 친구들 섹션 표시/숨김 업데이트
function updateSelectedFriendsSection() {
    console.log('updateSelectedFriendsSection 호출됨, 선택된 친구 수:', selectedFriends.length);
    
    const selectedFriendsSection = document.getElementById('selectedFriendsSection');
    const selectedCountBadge = document.getElementById('selectedCountBadge');
    
    if (!selectedFriendsSection) {
        console.error('selectedFriendsSection 요소를 찾을 수 없습니다!');
        return;
    }
    
    if (!selectedCountBadge) {
        console.error('selectedCountBadge 요소를 찾을 수 없습니다!');
        return;
    }
    
    if (selectedFriends.length > 0) {
        console.log('선택된 친구들 섹션 표시');
        selectedFriendsSection.classList.add('show');
        selectedFriendsSection.style.display = 'block';
        selectedCountBadge.textContent = selectedFriends.length;
    } else {
        console.log('선택된 친구들 섹션 숨김');
        selectedFriendsSection.classList.remove('show');
        selectedFriendsSection.style.display = 'none';
    }
}

function updateSelectedInput() {
    const selectedInput = document.getElementById('selectedInput');
    if (selectedInput) {
        selectedInput.value = selectedFriends.join(',');
    }
    
    // 페이징 링크들도 실시간 업데이트
    updatePaginationLinks();
}

function updatePaginationLinks() {
    const selectedParam = selectedFriends.length > 0 ? '&selected=' + selectedFriends.join(',') : '';
    
    // 현재 필터 값 가져오기
    const filterInput = document.getElementById('filterInput');
    const currentFilter = filterInput ? filterInput.value : 'all';
    const filterParam = '&filter=' + currentFilter;
    
    // 모든 페이징 링크 업데이트
    const paginationLinks = document.querySelectorAll('.pagination .page-link');
    paginationLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (href && href.startsWith('?')) {
            // 기존 selected 파라미터 제거
            let newHref = href.replace(/&selected=[^&]*/g, '');
            // 기존 filter 파라미터 확인하고 업데이트
            if (newHref.includes('&filter=')) {
                newHref = newHref.replace(/&filter=[^&]*/g, filterParam);
            } else {
                newHref += filterParam;
            }
            // 새로운 selected 파라미터 추가
            newHref += selectedParam;
            link.setAttribute('href', newHref);
        }
    });
}

function updateSelectedCount() {
    const count = selectedFriends.length;
    const selectedCountElement = document.getElementById('selectedCount');
    if (selectedCountElement) {
        selectedCountElement.textContent = count + '명';
    }
    
    const inviteBtn = document.getElementById('inviteBtn');
    if (inviteBtn) {
        inviteBtn.classList.add('active');
        inviteBtn.disabled = false;
        
        if (count > 0) {
            inviteBtn.textContent = '선택한 친구들(' + count + '명)에게 초대 보내기';
        } else {
            inviteBtn.textContent = '나 혼자 결제하기';
        }
    }
    
    // 선택된 친구들 섹션 업데이트
    updateSelectedFriendsSection();
}

function inviteFriends() {
    // 선택된 친구들을 서버에 임시 저장하고 다음 페이지로 이동
    if (selectedFriends.length > 0) {
        saveFriendIdsToServer(selectedFriends, function() {
            window.location.href = UrlConstants.Builder.fullUrl('/user/cart/waiting-approval');
        });
    } else {
        // 혼자 결제하는 경우 빈 배열로 저장
        saveFriendIdsToServer([], function() {
            window.location.href = UrlConstants.Builder.fullUrl('/user/cart/waiting-approval');
        });
    }
}

// 서버에 친구 ID 배열 임시 저장 (waiting-approval 페이지에서만 사용)
function saveFriendIdsToServer(friendIds, callback) {
    fetch(UrlConstants.Builder.fullUrl('/user/cart/save-selected-friend-ids'), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify(friendIds)
    })
    .then(response => response.json())
    .then(data => {
        if (data.result === 'success') {
            if (callback) callback();
        } else {
            alert('친구 정보 저장에 실패했습니다: ' + data.message);
        }
    })
    .catch(error => {
        console.error('서버 통신 오류:', error);
        alert('서버 통신 중 오류가 발생했습니다.');
    });
}

// 검색 초기화 기능
function clearSearch() {
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.value = '';
    }
    
    // 선택된 친구들 유지하며 검색 초기화
    updateSelectedInput();
    
    // 폼 제출하여 페이지 새로고침
    const searchForm = document.getElementById('searchForm');
    if (searchForm) {
        searchForm.submit();
    }
}

// 디버깅용 테스트 함수 (브라우저 콘솔에서 사용)
function testAddFriend() {
    console.log('테스트: 친구 추가');
    const firstFriend = document.querySelector('.friend-item');
    if (firstFriend) {
        toggleFriend(firstFriend);
    } else {
        console.log('친구 아이템을 찾을 수 없습니다');
    }
}

// 전역 함수로 등록 (디버깅용)
window.testAddFriend = testAddFriend;
window.selectedFriends = selectedFriends; 