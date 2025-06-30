// 친구 초대 페이지 JavaScript
let selectedFriends = [];

// 페이지 로드 시 초기 설정
document.addEventListener('DOMContentLoaded', function() {
    // URL 파라미터에서만 선택된 친구들 복원 (세션 사용 안함)
    const urlParams = new URLSearchParams(window.location.search);
    const selectedParam = urlParams.get('selected');
    
    if (selectedParam) {
        selectedFriends = selectedParam.split(',').filter(id => id.trim() !== '');
        console.log('URL에서 선택된 친구들 복원:', selectedFriends);
        restoreSelectedFriends();
    }
    
    const friendItems = document.querySelectorAll('.friend-item');
    console.log('친구 수:', friendItems.length);
    updateSelectedCount();
    
    // 페이지 로드 시 페이징 링크도 업데이트
    updatePaginationLinks();
    
    // 탭 전환 이벤트 리스너
    document.querySelectorAll('.status-tab').forEach(tab => {
        tab.addEventListener('click', function() {
            document.querySelectorAll('.status-tab').forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            
            const filter = this.dataset.filter;
            filterUsers(filter);
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
});

function restoreSelectedFriends() {
    selectedFriends.forEach(friendId => {
        const friendElement = document.querySelector(`[data-friend-id="${friendId}"]`);
        if (friendElement) {
            friendElement.classList.add('selected');
        }
    });
}

function goBack() {
    // 뒤로 갈 때는 선택 상태를 전달하지 않음 (초기화)
    window.location.href = UrlConstants.Builder.fullUrl('/user/cart/payment-method');
}

function toggleFriend(element) {
    const friendId = element.getAttribute('data-friend-id');
    
    if (!friendId) {
        alert('친구 정보를 찾을 수 없습니다. 페이지를 새로고침 해주세요.');
        return;
    }
    
    if (element.classList.contains('selected')) {
        element.classList.remove('selected');
        selectedFriends = selectedFriends.filter(id => id !== friendId);
    } else {
        element.classList.add('selected');
        selectedFriends.push(friendId);
    }
    
    updateSelectedCount();
    updateSelectedInput();
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
    
    // 모든 페이징 링크 업데이트
    const paginationLinks = document.querySelectorAll('.pagination .page-link');
    paginationLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (href && href.startsWith('?')) {
            // 기존 selected 파라미터 제거
            let newHref = href.replace(/&selected=[^&]*/g, '');
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

function filterUsers(filter) {
    const friendsList = document.getElementById('friendsList');
    if (!friendsList) return;
    
    const friendItems = friendsList.querySelectorAll('.friend-item');
    
    if (filter === 'all') {
        friendItems.forEach(item => {
            item.style.display = 'flex';
        });
    } else if (filter === 'department') {
        // 현재 사용자의 부서 ID 가져오기
        const currentUserData = document.getElementById('currentUserData');
        const currentUserDepartmentId = currentUserData ? 
            currentUserData.dataset.currentUserDepartment : '';
        
        friendItems.forEach(item => {
            const itemDepartmentId = item.dataset.departmentId;
            if (itemDepartmentId === currentUserDepartmentId) {
                item.style.display = 'flex';
            } else {
                item.style.display = 'none';
            }
        });
    }
}

function clearSearch() {
    const selectedParam = selectedFriends.length > 0 ? '&selected=' + selectedFriends.join(',') : '';
    const contextPath = document.querySelector('meta[name="contextPath"]');
    const baseUrl = contextPath ? contextPath.content : '';
    window.location.href = baseUrl + '/user/cart/invite-friends?page=1' + selectedParam;
} 