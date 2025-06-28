<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>리뷰 수정</title>
    
    <!-- 외부 CSS 파일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/review.css">
</head>
<body class="review-write-page">
    <div class="header">
        <h1>리뷰 수정</h1>
        <p>리뷰를 수정해주세요!</p>
    </div>

    <div class="form-container">
        <!-- 성공/오류 메시지 표시 -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <form id="reviewForm" action="${pageContext.request.contextPath}/user/review/edit" method="post" enctype="multipart/form-data">
            <!-- 숨겨진 필드들 -->
            <input type="hidden" name="reviewId" value="${review.reviewId}">
            <input type="hidden" name="usersId" value="${review.usersId}">
            <input type="hidden" name="storeId" value="${review.storeId}">

            <!-- 별점 평가 -->
            <div class="form-group">
                <label for="rating">별점 평가 <span class="required">*</span></label>
                <div class="rating-container">
                    <div class="star-rating">
                        <input type="radio" id="star5" name="reviewStar" value="5" ${review.reviewStar == 5 ? 'checked' : ''}>
                        <label for="star5">★</label>
                        <input type="radio" id="star4" name="reviewStar" value="4" ${review.reviewStar == 4 ? 'checked' : ''}>
                        <label for="star4">★</label>
                        <input type="radio" id="star3" name="reviewStar" value="3" ${review.reviewStar == 3 ? 'checked' : ''}>
                        <label for="star3">★</label>
                        <input type="radio" id="star2" name="reviewStar" value="2" ${review.reviewStar == 2 ? 'checked' : ''}>
                        <label for="star2">★</label>
                        <input type="radio" id="star1" name="reviewStar" value="1" ${review.reviewStar == 1 ? 'checked' : ''}>
                        <label for="star1">★</label>
                    </div>
                    <span id="starText">별점을 선택해주세요</span>
                </div>
            </div>

            <!-- 리뷰 제목 -->
            <div class="form-group">
                <label for="reviewTitle">리뷰 제목</label>
                <input type="text" id="reviewTitle" name="reviewTitle" maxlength="100" placeholder="리뷰 제목을 입력해주세요 (선택사항)" value="${review.reviewTitle}">
                <div class="char-count" id="reviewTitleCounter">0/100</div>
            </div>

            <!-- 리뷰 내용 -->
            <div class="form-group">
                <label for="reviewContent">리뷰 내용 <span class="required">*</span></label>
                <textarea id="reviewContent" name="reviewContent" maxlength="1000" placeholder="솔직한 리뷰를 작성해주세요! 음식의 맛, 서비스, 분위기 등에 대한 생생한 후기를 들려주세요." required>${review.reviewContent}</textarea>
                <div class="char-count" id="reviewContentCounter">0/1000</div>
            </div>

            <!-- 현재 리뷰 이미지 표시 -->
            <c:if test="${not empty review.reviewImage}">
                <div class="form-group">
                    <label>현재 리뷰 사진</label>
                    <div class="current-image">
                        <img src="${review.reviewImage}" alt="현재 리뷰 이미지" style="max-width: 200px; max-height: 200px; object-fit: cover; border-radius: 8px;">
                        <p style="font-size: 12px; color: #666;">새 이미지를 선택하면 기존 이미지가 교체됩니다.</p>
                    </div>
                </div>
            </c:if>

            <!-- 리뷰 이미지 -->
            <div class="form-group">
                <label for="reviewImage">리뷰 사진 ${not empty review.reviewImage ? '변경' : '추가'}</label>
                <input type="file" id="reviewImage" name="reviewImage" accept="image/*">
                <small style="color: #666; font-size: 12px;">JPG, PNG 파일만 업로드 가능합니다. (최대 5MB)</small>
            </div>

            <!-- 버튼 영역 -->
            <div class="btn-container">
                <a href="${pageContext.request.contextPath}/user/store/detail?storeId=${review.storeId}" class="btn btn-secondary">취소</a>
                <button type="submit" class="btn btn-primary">리뷰 수정</button>
            </div>
        </form>
    </div>

    <!-- 외부 JavaScript 파일 -->
    <script src="${pageContext.request.contextPath}/js/review.js"></script>
    
    <script>
        // 페이지 로드 시 기존 별점에 따른 텍스트 설정
        document.addEventListener('DOMContentLoaded', function() {
            const checkedStar = document.querySelector('input[name="reviewStar"]:checked');
            if (checkedStar) {
                const starText = document.getElementById('starText');
                const ratings = ['', '⭐ 별로예요', '⭐⭐ 그저 그래요', '⭐⭐⭐ 좋아요', '⭐⭐⭐⭐ 맛있어요', '⭐⭐⭐⭐⭐ 최고예요!'];
                starText.textContent = ratings[checkedStar.value];
                starText.style.color = checkedStar.value >= 4 ? '#ffc107' : checkedStar.value >= 3 ? '#17a2b8' : '#dc3545';
            }
        });

        // 별점 텍스트 업데이트
        document.querySelectorAll('input[name="reviewStar"]').forEach(input => {
            input.addEventListener('change', function() {
                const starText = document.getElementById('starText');
                const ratings = ['', '⭐ 별로예요', '⭐⭐ 그저 그래요', '⭐⭐⭐ 좋아요', '⭐⭐⭐⭐ 맛있어요', '⭐⭐⭐⭐⭐ 최고예요!'];
                starText.textContent = ratings[this.value];
                starText.style.color = this.value >= 4 ? '#ffc107' : this.value >= 3 ? '#17a2b8' : '#dc3545';
            });
        });
    </script>
</body>
</html> 