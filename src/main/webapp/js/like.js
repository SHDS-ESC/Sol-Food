document.addEventListener('DOMContentLoaded', function() {
    // 더보기 버튼 클릭 이벤트
    document.getElementById('loadMoreBtn').addEventListener('click', loadMoreStores);

    // 최초 데이터 로딩
    loadMoreStores();
});

let offset = 0;
const pageSize = 10;
let isEnd = false;

function goToStoreDetail(storeId) {
    window.location.href = UrlConstants.Builder.storeDetail(storeId);
}

function loadMoreStores() {
    if (isEnd) return;

    let url = UrlConstants.Builder.fullUrl(`/user/mypage/like/api?offset=${offset}&pageSize=${pageSize}`);

    fetch(url)
        .then(res => res.json())
        .then(data => {
            const grid = document.getElementById('storeGrid');
            let loaded = 0;

            data.list.forEach(store => {
                const card = createStoreCard(store);
                grid.appendChild(card);
                loaded++;
            });

            // 마지막 페이지 판별
            if (data.list.length < pageSize || !data.hasNext) {
                isEnd = true;
                document.getElementById('loadMoreBtn').style.display = 'none';
            } else {
                offset += data.list.length; // 다음 페이지 요청 준비
                document.getElementById('loadMoreBtn').style.display = '';
            }

            // 아무것도 없으면 안내
            if (grid.childElementCount === 0) {
                grid.innerHTML = `
                    <div style="width:100%; text-align:center; color:#999; margin-top:60px;">
                        <i class="bi bi-emoji-frown" style="font-size:40px"></i><br>
                        찜한 가게가 없습니다!
                    </div>
                `;
                document.getElementById('loadMoreBtn').style.display = 'none';
            }
        })
        .catch(err => {
            alert("서버와 통신 중 오류가 발생했습니다.");
        });
}


// 카드 생성 함수
function createStoreCard(store) {
    const div = document.createElement('div');
    div.className = 'store-card';
    const likedClass = store.liked ? 'liked' : '';
    const heartIcon = store.liked ? 'bi-heart-fill' : 'bi-heart';
    const usersId = window.loginUserId;

    div.innerHTML = `
                        <img src="${store.storeMainimage ? store.storeMainimage : 'https://images.unsplash.com/photo-1514933651103-005eec06c04b?w=200&h=120&fit=crop&crop=center'}"
            alt="${store.storeName}" class="store-img"
            onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
        <div class="store-img" style="background-color: #f8f9fa; display: none; align-items: center; justify-content: center; color: #6c757d;">
            <i class="bi bi-shop" style="font-size: 40px;"></i>
        </div>
        <div class="store-body">
            <div class="store-name">${store.storeName || '이름 없음'}</div>
            <div class="store-category">${store.storeCategory || '기타'}</div>
            <div style="font-size:11px; color:#666; margin-bottom:3px;">
                📍 ${store.storeAddress || '주소 정보 없음'}
            </div>
            <div style="font-size:12px;">
                ${store.storeAvgstar > 0 ? `⭐ ${store.storeAvgstar}점` : '⭐ 신규매장'}
            </div>
            ${store.storeTel && store.storeTel !== '정보없음' ? `<div style="font-size:10px; color:#28a745; margin-top:2px;">
                📞 ${store.storeTel}
            </div>` : ''}
             <button
                class="like-btn ${likedClass}"
                data-store-id="${store.storeId}"
                data-users-id="${usersId}"
                aria-label="찜">
                <i class="bi ${heartIcon}"></i>
            </button>
        </div>
    `;

    // 카드 클릭 이벤트 (상세 페이지로 이동)
    div.addEventListener('click', () => goToStoreDetail(store.storeId));
    
    // 찜 버튼 클릭 이벤트 (버블링 방지)
    const likeBtn = div.querySelector('.like-btn');
    likeBtn.addEventListener('click', function(event) {
        event.stopPropagation();
        toggleLike(this);
    });
    
    return div;
}

function toggleLike(btn) {
    const storeId = btn.dataset.storeId;
    const isLiked = btn.classList.contains('liked');
    const url = isLiked ? UrlConstants.Builder.fullUrl('/user/like/cancel') : UrlConstants.Builder.fullUrl('/user/like/add');
    const urlWithParams = `${url}?storeId=${encodeURIComponent(storeId)}`;

    fetch(urlWithParams)
        .then(res => res.json())
        .then(res => {
            if (res.result === "success") {
                if (isLiked) {
                    // 찜 목록 페이지에서는 찜을 해제하면 카드를 제거
                    const storeCard = btn.closest('.store-card');
                    if (storeCard) {
                        storeCard.remove();
                        
                        // 찜 개수 업데이트
                        const likeCountElement = document.getElementById('likeCount');
                        if (likeCountElement) {
                            const currentCount = parseInt(likeCountElement.textContent);
                            likeCountElement.textContent = (currentCount - 1) + '개';
                        }
                        
                        // 목록이 비었는지 확인
                        const grid = document.getElementById('storeGrid');
                        if (grid.childElementCount === 0) {
                            grid.innerHTML = `
                                <div style="width:100%; text-align:center; color:#999; margin-top:60px;">
                                    <i class="bi bi-emoji-frown" style="font-size:40px"></i><br>
                                    찜한 가게가 없습니다!
                                </div>
                            `;
                            document.getElementById('loadMoreBtn').style.display = 'none';
                        }
                    }
                } else {
                    btn.classList.add('liked');
                    btn.querySelector('i').className = 'bi bi-heart-fill';
                }
            } else {
                alert('찜 처리 중 오류가 발생했습니다.');
            }
        })
        .catch(() => {
            alert('서버와 통신 중 오류가 발생했습니다.');
        });
}
