/**
 * 찜 목록 JavaScript (경량화 버전)
 * common-utils.js 활용
 */

let likeCurrentPage = 1;
const likePageSize = 10;
let isEnd = false;

document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('loadMoreBtn').addEventListener('click', loadMoreStores);
    loadMoreStores();
});

function goToStoreDetail(storeId) {
    window.location.href = UrlConstants.Builder.storeDetail(storeId);
}

async function loadMoreStores() {
    if (isEnd) return;

    try {
        const url = UrlConstants.Builder.fullUrl(`/user/mypage/like/api?currentPage=${likeCurrentPage}&pageSize=${likePageSize}`);
        
        const response = await fetch(url);
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const data = await response.json();
        
        const grid = document.getElementById('storeGrid');
        
        if (data.list && Array.isArray(data.list)) {
            data.list.forEach(store => {
                const card = createStoreCard(store);
                grid.appendChild(card);
            });

            // 마지막 페이지 판별
            if (data.list.length < likePageSize || !data.hasNext) {
                isEnd = true;
                document.getElementById('loadMoreBtn').style.display = 'none';
            } else {
                likeCurrentPage++;
                document.getElementById('loadMoreBtn').style.display = '';
            }

            // 빈 목록 처리
            if (grid.childElementCount === 0) {
                showEmptyLikeList(grid);
            }
        } else {
            showEmptyLikeList(grid);
        }
        
    } catch (error) {
        SolFoodUtils.showToast('서버와 통신 중 오류가 발생했습니다.', 'error');
    }
}

function createStoreCard(store) {
    const div = document.createElement('div');
    div.className = 'store-card';
    const likedClass = store.liked ? 'liked' : '';
    const heartIcon = store.liked ? 'bi-heart-fill' : 'bi-heart';
    const usersId = window.loginUserId;

    // 안전한 문자열 처리
    const safeName = SolFoodUtils.truncateText(store.storeName || '이름 없음', 20);
    const safeCategory = store.storeCategory || '기타';
    const safeImage = store.storeMainimage || 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=200&h=120&fit=crop&crop=center';
    const safeAddress = SolFoodUtils.truncateText(store.storeAddress || '주소 정보 없음', 15);
    const safeRating = Number(store.storeAvgstar || 0);
    const safeTel = store.storeTel;

    div.innerHTML = `
        <img src="${safeImage}" alt="${safeName}" class="store-img"
             onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
        <div class="store-img" style="background-color: #f8f9fa; display: none; align-items: center; justify-content: center; color: #6c757d;">
            <i class="bi bi-shop" style="font-size: 40px;"></i>
        </div>
        <div class="store-body">
            <div class="store-name">${safeName}</div>
            <div class="store-category">${safeCategory}</div>
            <div style="font-size:11px; color:#666; margin-bottom:3px;">
                📍 ${safeAddress}
            </div>
            <div style="font-size:12px;">
                ${safeRating > 0 ? `⭐ ${safeRating}점` : '⭐ 신규매장'}
            </div>
            ${safeTel && safeTel !== '정보없음' ? `<div style="font-size:10px; color:#28a745; margin-top:2px;">
                📞 ${safeTel}
            </div>` : ''}
            <button class="like-btn ${likedClass}"
                    data-store-id="${store.storeId}"
                    data-users-id="${usersId}"
                    aria-label="찜">
                <i class="bi ${heartIcon}"></i>
            </button>
        </div>
    `;

    // 카드 클릭 이벤트
    div.addEventListener('click', () => goToStoreDetail(store.storeId));
    
    // 찜 버튼 클릭 이벤트 (버블링 방지)
    const likeBtn = div.querySelector('.like-btn');
    likeBtn.addEventListener('click', function(event) {
        event.stopPropagation();
        toggleLike(this);
    });
    
    return div;
}

async function toggleLike(btn) {
    const storeId = btn.dataset.storeId;
    const isLiked = btn.classList.contains('liked');
    const url = isLiked ? '/user/like/cancel' : '/user/like/add';
    const urlWithParams = `${UrlConstants.Builder.fullUrl(url)}?storeId=${encodeURIComponent(storeId)}`;

    try {
        const response = await fetch(urlWithParams);
        const result = await response.json();
        
        if (result.result === "success") {
            if (isLiked) {
                // 찜 해제 시 카드 제거 (찜 목록 페이지에서)
                removeLikedStoreCard(btn);
                SolFoodUtils.showToast('찜이 해제되었습니다.', 'info');
            } else {
                // 찜 추가
                btn.classList.add('liked');
                btn.querySelector('i').className = 'bi bi-heart-fill';
                SolFoodUtils.showToast('찜 목록에 추가되었습니다.', 'success');
            }
        } else {
            SolFoodUtils.showToast('찜 처리 중 오류가 발생했습니다.', 'error');
        }
    } catch (error) {
        SolFoodUtils.showToast('서버와 통신 중 오류가 발생했습니다.', 'error');
    }
}

function removeLikedStoreCard(btn) {
    const storeCard = btn.closest('.store-card');
    if (storeCard) {
        // 페이드 아웃 효과
        storeCard.style.transition = 'opacity 0.3s ease-out';
        storeCard.style.opacity = '0';
        
        setTimeout(() => {
            storeCard.remove();
            
            // 찜 개수 업데이트
            updateLikeCount();
            
            // 빈 목록 체크
            checkEmptyList();
        }, 300);
    }
}

function updateLikeCount() {
    const likeCountElement = document.getElementById('likeCount');
    if (likeCountElement) {
        const currentCount = parseInt(likeCountElement.textContent) || 0;
        const newCount = Math.max(0, currentCount - 1);
        likeCountElement.textContent = newCount + '개';
    }
}

function checkEmptyList() {
    const grid = document.getElementById('storeGrid');
    if (grid.childElementCount === 0) {
        showEmptyLikeList(grid);
    }
}

function showEmptyLikeList(grid) {
    grid.innerHTML = `
        <div style="width:100%; text-align:center; color:#999; margin-top:60px;">
            <i class="bi bi-emoji-frown" style="font-size:40px"></i><br>
            찜한 가게가 없습니다!
        </div>
    `;
    document.getElementById('loadMoreBtn').style.display = 'none';
}
