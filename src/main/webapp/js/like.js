document.addEventListener('DOMContentLoaded', function() {
    // 더보기 버튼 클릭 이벤트
    document.getElementById('loadMoreBtn').addEventListener('click', loadMoreStores);

    // 최초 데이터 로딩
    loadMoreStores();
});

let page = 1;
const pageSize = 10;
let isEnd = false;

function goToStoreDetail(storeId) {
    window.location.href = UrlConstants.Builder.storeDetail(storeId);
}

function loadMoreStores() {
    if (isEnd) return;

    let url = UrlConstants.Builder.fullUrl(`/user/mypage/like/api?currentPage=${page}&pageSize=${pageSize}`);

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
                page++; // 다음 페이지 요청 준비
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
            console.error(err);
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
        <img src="${store.storeMainimage ? store.storeMainimage : '/img/default-restaurant.jpg'}"
            alt="${store.storeName}" class="store-img"
            onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
        <div class="store-img" style="background-color: #f8f9fa; display: none; align-items: center; justify-content: center; color: #6c757d;">
            <i class="bi bi-shop" style="font-size: 40px;"></i>
        </div>
        <div class="store-body">
            <div class="store-name">${store.storeName}</div>
            <div class="store-category">${store.storeCategory}</div>
            <div style="font-size:11px; color:#666; margin-bottom:3px;">
                📍 ${store.storeAddress}
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

    div.addEventListener('click', () => goToStoreDetail(store.storeId));
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
                    btn.classList.remove('liked');
                    btn.querySelector('i').className = 'bi bi-heart';
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
