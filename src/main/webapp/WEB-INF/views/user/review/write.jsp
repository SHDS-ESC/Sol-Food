<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>리뷰 작성</title>
    
    <!-- 외부 CSS 파일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/review.css">
</head>
<body class="review-write-page">
    <div class="header">
        <h1>리뷰 작성</h1>
        <p>맛있는 식사는 어떠셨나요? 소중한 리뷰를 남겨주세요!</p>
    </div>

    <div class="form-container">
        <!-- 성공/오류 메시지 표시 -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <form id="reviewForm" action="${pageContext.request.contextPath}/user/review/write" method="post" enctype="multipart/form-data">
            <!-- 가게 ID 입력 필드 -->
            <div class="form-group">
                <label for="storeIdInput">가게 ID <span class="required">*</span></label>
                <input type="number" id="storeIdInput" name="storeId" value="${storeId}" placeholder="가게 ID를 입력해주세요" required>
                <small style="color: #666; font-size: 12px;">리뷰를 작성할 가게의 ID를 입력해주세요.</small>
            </div>

            <!-- 별점 평가 -->
            <div class="form-group">
                <label>별점 평가 <span class="required">*</span></label>
                <div class="rating-container">
                    <div class="star-rating">
                        <input type="radio" id="star5" name="reviewStar" value="5">
                        <label for="star5">★</label>
                        <input type="radio" id="star4" name="reviewStar" value="4">
                        <label for="star4">★</label>
                        <input type="radio" id="star3" name="reviewStar" value="3">
                        <label for="star3">★</label>
                        <input type="radio" id="star2" name="reviewStar" value="2">
                        <label for="star2">★</label>
                        <input type="radio" id="star1" name="reviewStar" value="1">
                        <label for="star1">★</label>
                    </div>
                    <span id="starText">별점을 선택해주세요</span>
                </div>
            </div>

            <!-- 리뷰 제목 -->
            <div class="form-group">
                <label for="reviewTitle">리뷰 제목</label>
                <input type="text" id="reviewTitle" name="reviewTitle" maxlength="100" placeholder="리뷰 제목을 입력해주세요 (선택사항)">
                <div class="char-count" id="reviewTitleCounter">0/100</div>
            </div>

            <!-- 리뷰 내용 -->
            <div class="form-group">
                <label for="reviewContent">리뷰 내용 <span class="required">*</span></label>
                <textarea id="reviewContent" name="reviewContent" maxlength="1000" placeholder="솔직한 리뷰를 작성해주세요! 음식의 맛, 서비스, 분위기 등에 대한 생생한 후기를 들려주세요." required></textarea>
                <div class="char-count" id="reviewContentCounter">0/1000</div>
            </div>

            <!-- 리뷰 이미지 -->
            <div class="form-group">
                <label for="reviewImage">리뷰 사진</label>
                <input type="file" id="reviewImage" name="reviewImage" accept="image/*">
                <small style="color: #666; font-size: 12px;">JPG, PNG 파일만 업로드 가능합니다. (최대 5MB)</small>
            </div>

            <!-- 버튼 영역 -->
            <div class="btn-container">
                <a href="${pageContext.request.contextPath}/user/mypage" class="btn btn-secondary">취소</a>
                <button type="submit" class="btn btn-primary">리뷰 등록</button>
            </div>
        </form>
    </div>

    <!-- 외부 JavaScript 파일 -->
    <script src="${pageContext.request.contextPath}/js/review.js"></script>
    
    <script>
        // 별점 텍스트 업데이트
        document.querySelectorAll('input[name="reviewStar"]').forEach(input => {
            input.addEventListener('change', function() {
                const starText = document.getElementById('starText');
                const ratings = ['', '⭐ 별로예요', '⭐⭐ 그저 그래요', '⭐⭐⭐ 좋아요', '⭐⭐⭐⭐ 맛있어요', '⭐⭐⭐⭐⭐ 최고예요!'];
                starText.textContent = ratings[this.value];
                starText.style.color = this.value >= 4 ? '#ffc107' : this.value >= 3 ? '#17a2b8' : '#dc3545';
            });
        });
        
        // 가게 ID 입력 필드 유효성 검사
        document.getElementById('storeIdInput').addEventListener('input', function() {
            const value = this.value.trim();
            if (value && !isNaN(value) && parseInt(value) > 0) {
                this.style.borderColor = '#28a745';
            } else {
                this.style.borderColor = '#dc3545';
            }
        });
        
        // 폼 제출 시 가게 ID 검증
        document.getElementById('reviewForm').addEventListener('submit', function(e) {
            const storeId = document.getElementById('storeIdInput').value.trim();
            const reviewStar = document.querySelector('input[name="reviewStar"]:checked');
            const reviewContent = document.getElementById('reviewContent').value.trim();
            const reviewTitle = document.getElementById('reviewTitle').value.trim();
            
            console.log('=== 폼 제출 데이터 ===');
            console.log('storeId:', storeId);
            console.log('reviewStar:', reviewStar ? reviewStar.value : null);
            console.log('reviewContent:', reviewContent);
            console.log('reviewTitle:', reviewTitle);
            console.log('========================');
            
            // FormData 객체로 모든 폼 데이터 확인
            const formData = new FormData(this);
            console.log('FormData 내용:');
            for (let [key, value] of formData.entries()) {
                console.log(key + ':', value);
            }
            
            if (!storeId || isNaN(storeId) || parseInt(storeId) <= 0) {
                e.preventDefault();
                alert('올바른 가게 ID를 입력해주세요.');
                document.getElementById('storeIdInput').focus();
                return false;
            }
            
            if (!reviewStar) {
                e.preventDefault();
                alert('별점을 선택해주세요.');
                return false;
            }
            
            if (!reviewContent) {
                e.preventDefault();
                alert('리뷰 내용을 입력해주세요.');
                document.getElementById('reviewContent').focus();
                return false;
            }
            
            console.log('폼 검증 통과 - 서버로 전송됩니다.');
        });
    </script>
</body>
</html> 