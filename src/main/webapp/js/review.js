/**
 * ==========================================
 * 리뷰 작성/수정 JavaScript
 * ==========================================
 * Sol-Food 프로젝트의 리뷰 작성 및 수정 관련 기능을 담당
 */

/* ===========================
   전역 상수 및 설정
   =========================== */

// 리뷰 작성 페이지 설정
const REVIEW_CONFIG = {
    // 글자 수 제한
    MAX_CONTENT_LENGTH: 1000,
    MAX_TITLE_LENGTH: 100,
    
    // 별점 관련
    MIN_STAR_RATING: 1,
    MAX_STAR_RATING: 5
};

/* ===========================
   리뷰 폼 검증 함수들
   =========================== */

/**
 * 리뷰 폼 유효성 검사
 * @returns {boolean} 유효성 검사 결과
 */
function validateReviewForm() {
    const starRating = document.querySelector('input[name="reviewStar"]:checked');
    const reviewContent = document.getElementById('reviewContent');
    
    // 별점 검사
    if (!starRating) {
        alert('별점을 선택해주세요.');
        return false;
    }
    
    const starValue = parseInt(starRating.value);
    if (starValue < REVIEW_CONFIG.MIN_STAR_RATING || starValue > REVIEW_CONFIG.MAX_STAR_RATING) {
        alert('올바른 별점을 선택해주세요.');
        return false;
    }
    
    // 내용 검사
    if (!reviewContent || !reviewContent.value.trim()) {
        alert('리뷰 내용을 입력해주세요.');
        if (reviewContent) reviewContent.focus();
        return false;
    }
    
    if (reviewContent.value.length > REVIEW_CONFIG.MAX_CONTENT_LENGTH) {
        alert(`리뷰 내용은 ${REVIEW_CONFIG.MAX_CONTENT_LENGTH}자 이하로 입력해주세요.`);
        reviewContent.focus();
        return false;
    }
    
    // 제목 검사 (선택사항이지만 길이 제한)
    const reviewTitle = document.getElementById('reviewTitle');
    if (reviewTitle && reviewTitle.value.length > REVIEW_CONFIG.MAX_TITLE_LENGTH) {
        alert(`리뷰 제목은 ${REVIEW_CONFIG.MAX_TITLE_LENGTH}자 이하로 입력해주세요.`);
        reviewTitle.focus();
        return false;
    }
    
    return true;
}

/* ===========================
   글자 수 카운터 함수들
   =========================== */

/**
 * 글자 수 카운터 초기화
 */
function initializeCharCounters() {
    // 리뷰 제목 카운터
    const reviewTitle = document.getElementById('reviewTitle');
    const titleCounter = document.getElementById('reviewTitleCounter');
    
    // 리뷰 내용 카운터
    const reviewContent = document.getElementById('reviewContent');
    const contentCounter = document.getElementById('reviewContentCounter');
    
    if (reviewTitle && titleCounter) {
        function updateTitleCounter() {
            const currentLength = reviewTitle.value.length;
            titleCounter.textContent = `${currentLength}/${REVIEW_CONFIG.MAX_TITLE_LENGTH}`;
            
            if (currentLength > REVIEW_CONFIG.MAX_TITLE_LENGTH) {
                titleCounter.style.color = '#dc3545';
            } else {
                titleCounter.style.color = '#6c757d';
            }
        }
        
        reviewTitle.addEventListener('input', updateTitleCounter);
        updateTitleCounter(); // 초기값 설정
    }
    
    if (reviewContent && contentCounter) {
        function updateContentCounter() {
            const currentLength = reviewContent.value.length;
            contentCounter.textContent = `${currentLength}/${REVIEW_CONFIG.MAX_CONTENT_LENGTH}`;
            
            if (currentLength > REVIEW_CONFIG.MAX_CONTENT_LENGTH) {
                contentCounter.style.color = '#dc3545';
            } else {
                contentCounter.style.color = '#6c757d';
            }
        }
        
        reviewContent.addEventListener('input', updateContentCounter);
        updateContentCounter(); // 초기값 설정
    }
}

/* ===========================
   리뷰 작성 폼 관련 함수들
   =========================== */

/**
 * 리뷰 작성 폼 초기화
 */
function initializeReviewWriteForm() {
    const reviewForm = document.getElementById('reviewForm');
    
    if (reviewForm) {
        reviewForm.addEventListener('submit', function(e) {
        if (!validateReviewForm()) {
            e.preventDefault();
                return false;
            }
        });
    }
    
    // 별점 선택 시 텍스트 업데이트
    const starInputs = document.querySelectorAll('input[name="reviewStar"]');
    const starText = document.getElementById('starText');
    
    if (starInputs.length > 0 && starText) {
        starInputs.forEach(input => {
            input.addEventListener('change', function() {
                const ratings = ['', '⭐ 별로예요', '⭐⭐ 그저 그래요', '⭐⭐⭐ 좋아요', '⭐⭐⭐⭐ 맛있어요', '⭐⭐⭐⭐⭐ 최고예요!'];
                starText.textContent = ratings[this.value] || '별점을 선택해주세요';
                starText.style.color = this.value >= 4 ? '#ffc107' : this.value >= 3 ? '#17a2b8' : '#dc3545';
            });
        });
    }
}

/* ===========================
   초기화 함수들
   =========================== */

/**
 * 리뷰 작성/수정 페이지 초기화
 */
function initializeReviewWritePage() {

    
    // 글자 수 카운터 초기화
    initializeCharCounters();
    
    // 리뷰 작성 폼 초기화
    initializeReviewWriteForm();
    

}

/**
 * 페이지 로드 완료 후 초기화
 */
function initializeReviewSystem() {
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initializeReviewWritePage);
    } else {
        initializeReviewWritePage();
    }
}

// 시스템 초기화 실행
    initializeReviewSystem();
