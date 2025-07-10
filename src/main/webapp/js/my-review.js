/**
 * 내 리뷰 관리 페이지 JavaScript
 */

// 전역 변수
let currentPage = 1;
let currentFilter = 'all';
let currentSort = 'latest';
let hasMoreReviews = true;
let isLoading = false;

// 페이지 로드 시 초기화
document.addEventListener('DOMContentLoaded', function() {
    initializePage();
    loadReviews();
    setupEventListeners();
});

/**
 * 페이지 초기화
 */
function initializePage() {
    // 필터 탭 이벤트 리스너
    const filterTabs = document.querySelectorAll('.filter-tab');
    filterTabs.forEach(tab => {
        tab.addEventListener('click', function() {
            const filter = this.dataset.filter;
            changeFilter(filter);
        });
    });
}

/**
 * 이벤트 리스너 설정
 */
function setupEventListeners() {
    // 별점 클릭 이벤트
    const starRating = document.getElementById('editStarRating');
    if (starRating) {
        const stars = starRating.querySelectorAll('i');
        stars.forEach(star => {
            star.addEventListener('click', function() {
                const rating = parseInt(this.dataset.rating);
                setStarRating(rating);
            });
        });
    }
}

/**
 * 리뷰 목록 로드
 */
function loadReviews(reset = true) {
    if (isLoading) return;
    
    if (reset) {
        currentPage = 1;
        hasMoreReviews = true;
        document.getElementById('reviewList').innerHTML = '';
    }
    
    isLoading = true;
    showLoading(true);
    
    const params = new URLSearchParams({
        page: currentPage,
        filter: currentFilter,
        sort: currentSort
    });
    
    fetch(UrlConstants.Builder.fullUrl(`/user/review/my-reviews?${params}`))
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                if (reset) {
                    updateStats(data.stats);
                }
                renderReviews(data.reviews);
                hasMoreReviews = data.hasMore;
                updateLoadMoreButton();
            } else {
                showError(data.message || '리뷰를 불러오는데 실패했습니다.');
            }
        })
        .catch(error => {
            console.error('리뷰 로드 실패:', error);
            showError('리뷰를 불러오는데 실패했습니다.');
        })
        .finally(() => {
            isLoading = false;
            showLoading(false);
        });
}

/**
 * 통계 업데이트
 */
function updateStats(stats) {
    document.getElementById('totalReviews').textContent = stats.totalReviews || 0;
    document.getElementById('avgRating').textContent = (stats.avgRating || 0).toFixed(1);
    document.getElementById('thisMonth').textContent = stats.thisMonth || 0;
}

/**
 * 리뷰 렌더링
 */
function renderReviews(reviews) {
    const reviewList = document.getElementById('reviewList');
    const emptyState = document.getElementById('emptyState');
    
    if (reviews.length === 0 && currentPage === 1) {
        reviewList.style.display = 'none';
        emptyState.style.display = 'block';
        return;
    }
    
    reviewList.style.display = 'flex';
    emptyState.style.display = 'none';
    
    reviews.forEach(review => {
        const reviewCard = createReviewCard(review);
        reviewList.appendChild(reviewCard);
    });
}

/**
 * 리뷰 카드 생성
 */
function createReviewCard(review) {
    const card = document.createElement('div');
    card.className = 'review-card';
    card.dataset.reviewId = review.reviewId;
    
    const stars = '★'.repeat(review.reviewRating) + '☆'.repeat(5 - review.reviewRating);
    
    card.innerHTML = `
        <div class="review-header">
            <div class="review-store-info">
                <div class="review-store-name">${review.storeName}</div>
                <div class="review-date">${formatDate(review.reviewDate)}</div>
            </div>
            <div class="review-actions">
                <button class="action-btn edit-btn" onclick="editReview(${review.reviewId})">
                    <i class="bi bi-pencil"></i> 수정
                </button>
                <button class="action-btn delete-btn" onclick="deleteReview(${review.reviewId})">
                    <i class="bi bi-trash"></i> 삭제
                </button>
            </div>
        </div>
        <div class="review-title">${review.reviewTitle}</div>
        <div class="review-content">${review.reviewContent}</div>
        <div class="review-rating">
            <div class="stars">${stars}</div>
            <div class="rating-text">${review.reviewRating}점</div>
        </div>
        ${review.reviewImage ? `
            <div class="review-image">
                <img src="${review.reviewImage}" alt="리뷰 이미지" onerror="this.style.display='none'">
            </div>
        ` : ''}
    `;
    
    return card;
}

/**
 * 필터 변경
 */
function changeFilter(filter) {
    currentFilter = filter;
    
    // 탭 활성화 상태 변경
    document.querySelectorAll('.filter-tab').forEach(tab => {
        tab.classList.remove('active');
    });
    document.querySelector(`[data-filter="${filter}"]`).classList.add('active');
    
    // 리뷰 다시 로드
    loadReviews();
}

/**
 * 정렬 변경
 */
function changeSort() {
    currentSort = document.getElementById('sortSelect').value;
    loadReviews();
}

/**
 * 더 많은 리뷰 로드
 */
function loadMoreReviews() {
    if (!hasMoreReviews || isLoading) return;
    
    currentPage++;
    loadReviews(false);
}

/**
 * 더보기 버튼 업데이트
 */
function updateLoadMoreButton() {
    const loadMoreSection = document.getElementById('loadMoreSection');
    loadMoreSection.style.display = hasMoreReviews ? 'block' : 'none';
}

/**
 * 로딩 상태 표시/숨김
 */
function showLoading(show) {
    const loadingState = document.getElementById('loadingState');
    loadingState.style.display = show ? 'block' : 'none';
}

/**
 * 에러 메시지 표시
 */
function showError(message) {
    SolFoodUtils.showToast(message, 'error');
}

/**
 * 날짜 포맷팅
 */
function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('ko-KR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });
}

/**
 * 리뷰 수정 모달 열기
 */
function editReview(reviewId) {
    // 리뷰 데이터 로드
    fetch(UrlConstants.Builder.fullUrl(`/user/review/detail/${reviewId}`))
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                populateEditForm(data.review);
                openEditModal();
            } else {
                showError('리뷰 정보를 불러오는데 실패했습니다.');
            }
        })
        .catch(error => {
            console.error('리뷰 정보 로드 실패:', error);
            showError('리뷰 정보를 불러오는데 실패했습니다.');
        });
}

/**
 * 수정 폼에 데이터 채우기
 */
function populateEditForm(review) {
    document.getElementById('editReviewId').value = review.reviewId;
    document.getElementById('editReviewTitle').value = review.reviewTitle;
    document.getElementById('editReviewContent').value = review.reviewContent;
    document.getElementById('editReviewRating').value = review.reviewRating;
    
    // 별점 설정
    setStarRating(review.reviewRating);
    
    // 현재 이미지 표시
    const currentImageSection = document.getElementById('currentImageSection');
    const currentImage = document.getElementById('currentImage');
    
    if (review.reviewImage) {
        currentImage.src = review.reviewImage;
        currentImageSection.style.display = 'block';
    } else {
        currentImageSection.style.display = 'none';
    }
}

/**
 * 별점 설정
 */
function setStarRating(rating) {
    const stars = document.querySelectorAll('#editStarRating i');
    const ratingInput = document.getElementById('editReviewRating');
    
    stars.forEach((star, index) => {
        if (index < rating) {
            star.classList.add('filled');
            star.classList.remove('bi-star');
            star.classList.add('bi-star-fill');
        } else {
            star.classList.remove('filled');
            star.classList.remove('bi-star-fill');
            star.classList.add('bi-star');
        }
    });
    
    ratingInput.value = rating;
}

/**
 * 수정 모달 열기
 */
function openEditModal() {
    document.getElementById('editReviewModal').style.display = 'block';
    document.body.style.overflow = 'hidden';
}

/**
 * 수정 모달 닫기
 */
function closeEditModal() {
    document.getElementById('editReviewModal').style.display = 'none';
    document.body.style.overflow = 'auto';
}

/**
 * 리뷰 수정
 */
function updateReview() {
    const form = document.getElementById('editReviewForm');
    const formData = new FormData(form);
    
    // 파일 추가
    const imageFile = document.getElementById('editReviewImage').files[0];
    if (imageFile) {
        formData.append('reviewImage', imageFile);
    }
    
    fetch(UrlConstants.Builder.fullUrl('/user/review/update'), {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            SolFoodUtils.showToast('리뷰가 수정되었습니다.', 'success');
            closeEditModal();
            loadReviews(); // 목록 새로고침
        } else {
            showError(data.message || '리뷰 수정에 실패했습니다.');
        }
    })
    .catch(error => {
        console.error('리뷰 수정 실패:', error);
        showError('리뷰 수정에 실패했습니다.');
    });
}

/**
 * 현재 이미지 제거
 */
function removeCurrentImage() {
    document.getElementById('currentImageSection').style.display = 'none';
    document.getElementById('editReviewImage').value = '';
}

/**
 * 리뷰 삭제 확인
 */
function deleteReview(reviewId) {
    document.getElementById('deleteConfirmModal').style.display = 'block';
    document.body.style.overflow = 'hidden';
    
    // 삭제할 리뷰 ID 저장
    window.deleteReviewId = reviewId;
}

/**
 * 삭제 확인 모달 닫기
 */
function closeDeleteModal() {
    document.getElementById('deleteConfirmModal').style.display = 'none';
    document.body.style.overflow = 'auto';
    window.deleteReviewId = null;
}

/**
 * 리뷰 삭제 실행
 */
function confirmDeleteReview() {
    const reviewId = window.deleteReviewId;
    if (!reviewId) return;
    
    fetch(UrlConstants.Builder.fullUrl(`/user/review/delete/${reviewId}`), {
        method: 'DELETE'
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            SolFoodUtils.showToast('리뷰가 삭제되었습니다.', 'success');
            closeDeleteModal();
            loadReviews(); // 목록 새로고침
        } else {
            showError(data.message || '리뷰 삭제에 실패했습니다.');
        }
    })
    .catch(error => {
        console.error('리뷰 삭제 실패:', error);
        showError('리뷰 삭제에 실패했습니다.');
    });
} 