// document.addEventListener('DOMContentLoaded', function() {
//     const slides = document.querySelectorAll('.banner-slide');
//     const dotsContainer = document.querySelector('.banner-dots');
//     const prevBtn = document.querySelector('.banner-arrow.prev');
//     const nextBtn = document.querySelector('.banner-arrow.next');
//     let currentIdx = 0;
//     let timer;
//
//     // Dot 생성
//     slides.forEach((_, i) => {
//         const dot = document.createElement('span');
//         if (i === 0) dot.classList.add('active');
//         dotsContainer.appendChild(dot);
//         dot.addEventListener('click', () => showSlide(i));
//     });
//     const dots = dotsContainer.querySelectorAll('span');
//
//     function showSlide(idx) {
//         slides[currentIdx].classList.remove('active');
//         dots[currentIdx].classList.remove('active');
//         currentIdx = idx;
//         slides[currentIdx].classList.add('active');
//         dots[currentIdx].classList.add('active');
//     }
//
//     function nextSlide() {
//         let nextIdx = (currentIdx + 1) % slides.length;
//         showSlide(nextIdx);
//     }
//     function prevSlide() {
//         let prevIdx = (currentIdx - 1 + slides.length) % slides.length;
//         showSlide(prevIdx);
//     }
//     function autoSlide() {
//         timer = setInterval(nextSlide, 4000);
//     }
//     function stopAuto() {
//         clearInterval(timer);
//     }
//
//     nextBtn.addEventListener('click', () => { stopAuto(); nextSlide(); autoSlide(); });
//     prevBtn.addEventListener('click', () => { stopAuto(); prevSlide(); autoSlide(); });
//
//     // 슬라이더 위에서 마우스 멈추면 자동 멈춤
//     document.querySelector('.banner-slider').addEventListener('mouseenter', stopAuto);
//     document.querySelector('.banner-slider').addEventListener('mouseleave', autoSlide);
//
//     autoSlide();
// });

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
                        <div class="popular-card-category">${store.categoryName || ''}</div>
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

