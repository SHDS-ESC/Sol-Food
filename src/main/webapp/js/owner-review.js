// 전역 변수
let currentReviewId = null;
let currentStoreId = null;
let allReviews = [];
let filteredReviews = [];

// 페이지 로드 시 초기화
$(document).ready(function() {
    // 필터 이벤트 바인딩
    bindFilterEvents();
    
    // 기본 리뷰 목록 로드
    loadReviews();
});

// 필터 이벤트 바인딩
function bindFilterEvents() {
    loadReviews();
    // $('#storeFilter').on('change', function() {
    //     loadReviews();
    // });
    
    $('#ratingFilter').on('change', filterReviews);
    $('#responseFilter').on('change', filterReviews);
    $('#sortFilter').on('change', filterReviews);
    
    $('#filterBtn').on('click', function() {
        loadReviews();
    });
    
    $('#resetBtn').on('click', function() {
        $('#ratingFilter').val('');
        $('#responseFilter').val('');
        $('#sortFilter').val('latest');
        loadReviews();
    });
}

// 리뷰 목록 로드
function loadReviews() {
    // currentStoreId = $('#storeFilter').val();
    currentStoreId = $('#storeIdInput').val();

    if (!currentStoreId) {
        return;
    }
    
    // 로딩 상태 표시
    showLoadingInReviewList();
    
    // AJAX 요청
    $.ajax({
        url: contextPath + '/owner/review/api/list',
        type: 'GET',
        data: {
            storeId: currentStoreId
        },
        success: function(response) {
            allReviews = response.reviews || [];
            filteredReviews = [...allReviews];
            
            displayStoreInfo(response.store);
            filterReviews();
        },
        error: function(xhr, status, error) {
            showErrorInReviewList('리뷰 목록을 불러올 수 없습니다.');
        }
    });
}

// 가게 정보 표시
function displayStoreInfo(store) {
    if (store) {
        $('.store-info').text(store.storeName || '가게 정보 없음');
    }
}

// 리뷰 필터링
function filterReviews() {
    if (!allReviews || allReviews.length === 0) {
        return;
    }
    
    let rating = $('#ratingFilter').val();
    let responseStatus = $('#responseFilter').val();
    let sortOrder = $('#sortFilter').val();
    
    // 필터링
    filteredReviews = allReviews.filter(function(review) {
        // 별점 필터
        if (rating && review.reviewStar != rating) {
            return false;
        }
        
        // 답글 상태 필터
        if (responseStatus === 'completed' && !review.reviewResponse) {
            return false;
        }
        if (responseStatus === 'pending' && review.reviewResponse) {
            return false;
        }
        
        return true;
    });
    
    // 정렬
    filteredReviews.sort(function(a, b) {
        if (sortOrder === 'latest') {
            return new Date(b.reviewDate) - new Date(a.reviewDate);
        } else if (sortOrder === 'oldest') {
            return new Date(a.reviewDate) - new Date(b.reviewDate);
        } else if (sortOrder === 'rating_high') {
            return b.reviewStar - a.reviewStar;
        } else if (sortOrder === 'rating_low') {
            return a.reviewStar - b.reviewStar;
        }
        return 0;
    });
    
    displayReviewList();
}

// 리뷰 목록 표시
function displayReviewList() {
    const $reviewList = $('.review-list');
    $reviewList.empty();
    
    if (filteredReviews.length === 0) {
        $reviewList.append(`
            <div class="empty-state" style="padding: 40px 20px; text-align: center; color: #9ca3af;">
                <i class="fas fa-star" style="font-size: 2rem; margin-bottom: 10px;"></i>
                <p>조건에 맞는 리뷰가 없습니다.</p>
            </div>
        `);
        return;
    }
    
    filteredReviews.forEach(function(review) {
        const reviewItem = createReviewItem(review);
        $reviewList.append(reviewItem);
    });
    
    // 리뷰 아이템 클릭 이벤트
    $('.review-item').on('click', function() {
        const reviewId = $(this).data('review-id');
        selectReview(reviewId);
    });
}

// 리뷰 아이템 HTML 생성
function createReviewItem(review) {
    const hasResponse = review.reviewResponse && review.reviewResponse.trim() !== '';
    const responseBadge = hasResponse ? 
        '<span class="response-badge completed">답글완료</span>' :
        '<span class="response-badge pending">미답글</span>';
    
    const stars = generateStarRating(review.reviewStar);
    const formattedDate = formatDate(review.reviewDate);
    
    // 사용자 닉네임 표시
    const userNickname = review.usersNickname || '익명';
    
    // 리뷰 사진 표시 (썸네일)
    let imageIndicator = '';
    if (review.reviewImage && review.reviewImage.trim() !== '') {
        imageIndicator = '<span style="color: #3b82f6; margin-left: 5px;">📷</span>';
    }
    
    return `
        <div class="review-item" data-review-id="${review.reviewId}">
            <div class="review-meta">
                <div class="star-rating">${stars}</div>
                ${responseBadge}
            </div>
            <div class="review-title">
                ${escapeHtml(review.reviewTitle || '제목 없음')}
                ${imageIndicator}
            </div>
            <div class="review-author">${escapeHtml(userNickname)}</div>
            <div class="review-date">${formattedDate}</div>
        </div>
    `;
}

// 별점 HTML 생성
function generateStarRating(rating) {
    let stars = '';
    for (let i = 1; i <= 5; i++) {
        if (i <= rating) {
            stars += '<i class="fas fa-star"></i>';
        } else {
            stars += '<i class="far fa-star"></i>';
        }
    }
    return stars;
}

// 리뷰 선택
function selectReview(reviewId) {
    // 이전 선택 해제
    $('.review-item').removeClass('selected');
    
    // 새로운 선택
    $(`.review-item[data-review-id="${reviewId}"]`).addClass('selected');
    
    currentReviewId = reviewId;
    const review = allReviews.find(r => r.reviewId == reviewId);
    
    if (review) {
        displayReviewDetail(review);
        displayResponsePanel(review);
    }
}

// 리뷰 상세 표시
function displayReviewDetail(review) {
    $('.review-detail-empty').hide();
    $('.review-detail-content').show();
    
    // 사용자 프로필 이미지 (실제 프로필 사진 또는 닉네임 첫 글자)
    let profileImage = '';
    if (review.usersProfile && review.usersProfile.trim() !== '') {
        profileImage = `<img src="${review.usersProfile}" alt="프로필" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">`;
    } else {
        const profileInitial = review.usersNickname ? review.usersNickname.charAt(0).toUpperCase() : 
                              (review.usersId ? review.usersId.toString().charAt(0) : 'U');
        profileImage = profileInitial;
    }
    
    // 별점 HTML
    const stars = generateStarRating(review.reviewStar);
    
    // 날짜 포맷
    const formattedDate = formatDateTime(review.reviewDate);
    
    // 리뷰 사진 HTML
    let reviewImageHtml = '';
    if (review.reviewImage && review.reviewImage.trim() !== '') {
        reviewImageHtml = `
            <div class="review-image-container" style="margin: 15px 0;">
                <img src="${review.reviewImage}" alt="리뷰 사진" style="max-width: 100%; max-height: 300px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
            </div>
        `;
    }
    
    $('.review-detail-content').html(`
        <div class="user-profile">
            <div class="profile-image">${profileImage}</div>
            <div class="user-info-detail">
                <div class="user-name">${escapeHtml(review.usersNickname || '익명')}</div>
                <div class="review-datetime">${formattedDate}</div>
            </div>
        </div>
        <div class="review-rating">
            <div class="star-rating">${stars}</div>
            <span>${review.reviewStar}점</span>
        </div>
        <div class="review-content">
            ${escapeHtml(review.reviewContent || '내용이 없습니다.').replace(/\n/g, '<br>')}
        </div>
        ${reviewImageHtml}
    `);
}

// 답글 패널 표시
function displayResponsePanel(review) {
    $('.response-empty').hide();
    $('.response-input-area').show();
    
    const hasResponse = review.reviewResponse && review.reviewResponse.trim() !== '';
    
    if (hasResponse) {
        $('.current-response-content').html(escapeHtml(review.reviewResponse).replace(/\n/g, '<br>')).show();
        $('#responseText').val(review.reviewResponse);
        $('#deleteResponseBtn').show();
    } else {
        $('.current-response-content').hide();
        $('#responseText').val('');
        $('#deleteResponseBtn').hide();
    }
    
    // 답글 작성/수정 버튼 이벤트
    $('#submitResponseBtn').off('click').on('click', function() {
        submitResponse();
    });
    
    // 답글 삭제 버튼 이벤트
    $('#deleteResponseBtn').off('click').on('click', function() {
        deleteResponse();
    });
}

// 답글 제출
function submitResponse() {
    if (!currentReviewId) {
        alert('리뷰를 선택해주세요.');
        return;
    }
    
    const responseText = $('#responseText').val().trim();
    if (!responseText) {
        alert('답글 내용을 입력해주세요.');
        return;
    }
    
    const $submitBtn = $('#submitResponseBtn');
    $submitBtn.prop('disabled', true).text('저장 중...');
    

    
    $.ajax({
        url: contextPath + '/owner/review/response',
        type: 'POST',
        data: {
            reviewId: currentReviewId,
            response: responseText,
            currentStoreId: currentStoreId
        },
        success: function(response) {
            alert('답글이 저장되었습니다.');
            
            // 현재 리뷰 데이터 업데이트
            const reviewIndex = allReviews.findIndex(r => r.reviewId == currentReviewId);
            if (reviewIndex !== -1) {
                allReviews[reviewIndex].reviewResponse = responseText;
                filterReviews(); // 목록 갱신
                displayResponsePanel(allReviews[reviewIndex]); // 답글 패널 갱신
            }
        },
        error: function(xhr, status, error) {
            alert('답글 저장에 실패했습니다: ' + (xhr.responseJSON?.message || error));
        },
        complete: function() {
            $submitBtn.prop('disabled', false).text('답글 저장');
        }
    });
}

// 답글 삭제
function deleteResponse() {
    if (!currentReviewId) {
        alert('리뷰를 선택해주세요.');
        return;
    }
    
    if (!confirm('답글을 삭제하시겠습니까?')) {
        return;
    }
    
    const $deleteBtn = $('#deleteResponseBtn');
    $deleteBtn.prop('disabled', true).text('삭제 중...');
    
    $.ajax({
        url: contextPath + '/owner/review/response/' + currentReviewId,
        type: 'DELETE',
        data: {
            currentStoreId: currentStoreId
        },
        success: function(response) {
            alert('답글이 삭제되었습니다.');
            
            // 현재 리뷰 데이터 업데이트
            const reviewIndex = allReviews.findIndex(r => r.reviewId == currentReviewId);
            if (reviewIndex !== -1) {
                allReviews[reviewIndex].reviewResponse = null;
                filterReviews(); // 목록 갱신
                displayResponsePanel(allReviews[reviewIndex]); // 답글 패널 갱신
            }
        },
        error: function(xhr, status, error) {
            alert('답글 삭제에 실패했습니다: ' + (xhr.responseJSON?.message || error));
        },
        complete: function() {
            $deleteBtn.prop('disabled', false).text('답글 삭제');
        }
    });
}

// 로딩 상태 표시
function showLoadingInReviewList() {
    $('.review-list').html(`
        <div class="loading-state" style="padding: 40px 20px; text-align: center; color: #9ca3af;">
            <i class="fas fa-spinner fa-spin" style="font-size: 2rem; margin-bottom: 10px;"></i>
            <p>리뷰를 불러오는 중...</p>
        </div>
    `);
}

// 에러 상태 표시
function showErrorInReviewList(message) {
    $('.review-list').html(`
        <div class="error-state" style="padding: 40px 20px; text-align: center; color: #ef4444;">
            <i class="fas fa-exclamation-triangle" style="font-size: 2rem; margin-bottom: 10px;"></i>
            <p>${message}</p>
        </div>
    `);
}

// 로그아웃 함수
function logout() {
    if (confirm("로그아웃 하시겠습니까?")) {
        window.location.href = contextPath + "/owner/logout";
    }
}

// 유틸리티 함수들
function formatDate(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toLocaleDateString('ko-KR');
}

function formatDateTime(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toLocaleDateString('ko-KR') + ' ' + date.toLocaleTimeString('ko-KR', { 
        hour: '2-digit', 
        minute: '2-digit' 
    });
}

function escapeHtml(text) {
    if (!text) return '';
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, function(m) { return map[m]; });
} 