
/*
// 슬라이더 자동 전환 (예: 3초마다)
document.addEventListener('DOMContentLoaded', function() {
    const slider = document.querySelector('.banner-slider');
    const banners = document.querySelectorAll('.banner-img');
    let current = 0;
    const total = banners.length;
    let intervalId;

    function showBanner(idx) {
        slider.style.transform = `translateX(-${idx * 100}%)`;
    }

    function nextBanner() {
        current = (current + 1) % total;
        showBanner(current);
    }

    // 자동 슬라이드 (3초 간격)
    intervalId = setInterval(nextBanner, 3000);

    // (선택) 마우스 올리면 멈추고, 내리면 다시 시작
    slider.addEventListener('mouseenter', () => clearInterval(intervalId));
    slider.addEventListener('mouseleave', () => intervalId = setInterval(nextBanner, 3000));

    // 반응형 리셋
    window.addEventListener('resize', () => showBanner(current));
});
*/

document.addEventListener('DOMContentLoaded', function() {
    const banners = document.querySelectorAll('.banner-item');
    const dots = document.querySelectorAll('.banner-dots .dot');
    let current = 0;
    let intervalId;

    function showBanner(idx) {
        banners.forEach((b, i) => {
            b.classList.toggle('active', i === idx);
            dots[i].classList.toggle('active', i === idx);
        });
        current = idx;
    }

    function nextBanner() {
        let next = (current + 1) % banners.length;
        showBanner(next);
    }

    function startAuto() {
        intervalId = setInterval(nextBanner, 3000);
    }
    function stopAuto() {
        clearInterval(intervalId);
    }

    // dot 클릭 시 이동
    dots.forEach((dot, i) => {
        dot.onclick = () => {
            showBanner(i);
            stopAuto();
            startAuto();
        };
    });

    // 자동 시작/멈춤
    document.querySelector('.banner-slider').addEventListener('mouseenter', stopAuto);
    document.querySelector('.banner-slider').addEventListener('mouseleave', startAuto);

    startAuto();
});


// 인기순위(Top 10) 동적 카드 렌더링 및 슬라이더 버튼

document.addEventListener("DOMContentLoaded", function() {
    const slider = document.getElementById("popularSlider");
    const prevBtn = document.getElementById("prevBtn");
    const nextBtn = document.getElementById("nextBtn");

    // 좌우 스크롤(카드 한 장씩)
    prevBtn.addEventListener('click', function() {
        slider.scrollBy({ left: -220, behavior: 'smooth' });
    });
    nextBtn.addEventListener('click', function() {
        slider.scrollBy({ left: 220, behavior: 'smooth' });
    });

    fetch("/solfood/user/store/api/popular")
        .then(response => response.json())
        .then(data => {
            slider.innerHTML = "";
            data.forEach((store, idx) => {
                const card = document.createElement("div");
                card.className = "popular-card";
                card.innerHTML = `
                    <div class="popular-card-image">
                        <img src="${store.storeMainimage || '/img/default-restaurant.jpg'}" alt="${store.storeName}">
                        <span class="popular-badge">TOP ${idx + 1}</span>
                    </div>
                    <div class="popular-card-content">
                        <div class="popular-card-name">${store.storeName}</div>
                        <div class="popular-card-category">${store.storeCategory || ''}</div>
                        <div class="popular-card-stats">
                            <div class="popular-card-rating"><span class="star">★</span> ${store.storeAvgstar ?? 0}</div>
                            <div class="popular-card-likes">${store.likeCount}</div>
                        </div>
                        <div class="popular-card-actions">
                            <a class="popular-card-btn secondary" href="/solfood/user/store/detail?storeId=${store.storeId}&order=1"><i class="bi bi-bag"></i>주문하기</a>
                        </div>
                    </div>
                `;
                slider.appendChild(card);
            });
            // 상세보기 버튼에 클릭 이벤트 연결
            document.querySelectorAll('.go-detail-btn').forEach(btn => {
                btn.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const storeId = this.getAttribute('data-id');
                    location.href = "/solfood/user/store/detail?storeId=" + storeId;
                });
            });
        })
        .catch(err => {
            console.error("인기식당 API 에러:", err);
        });
});

