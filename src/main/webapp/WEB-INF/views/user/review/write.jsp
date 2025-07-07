<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>리뷰 작성</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/review.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
</head>
<body>
    <div class="header">
        <div class="header-inner">
            <a href="${pageContext.request.contextPath}/" class="header-logo-link">
                <img src="${pageContext.request.contextPath}/img/logo.png" alt="SolFood 로고" class="header-logo" />
            </a>
            <button id="darkmode-toggle" class="header-darkmode-btn">
                <i class="bi bi-moon"></i>
            </button>
        </div>
    </div>
    <div class="wrap">
        <div class="content">
            <div class="review-container">
                <div class="review-intro">
                    <i class="bi bi-chat-quote"></i>
                    맛있는 식사는 어떠셨나요? <br/>소중한 리뷰를 남겨주세요!
                </div>
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${successMessage}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger">${errorMessage}</div>
                </c:if>
                <form id="reviewForm" action="${pageContext.request.contextPath}/user/review/write" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="storeIdInput">가게 ID <span class="required">*</span></label>
                        <input type="number" id="storeIdInput" name="storeId" value="${storeId}" placeholder="가게 ID를 입력해주세요" required>
                        <small class="form-hint">리뷰를 작성할 가게의 ID를 입력해주세요.</small>
                    </div>
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
                    <div class="form-group">
                        <label for="reviewTitle">리뷰 제목</label>
                        <input type="text" id="reviewTitle" name="reviewTitle" maxlength="100" placeholder="리뷰 제목을 입력해주세요 (선택사항)">
                        <div class="char-count" id="reviewTitleCounter">0/100</div>
                    </div>
                    <div class="form-group">
                        <label for="reviewContent">리뷰 내용 <span class="required">*</span></label>
                        <textarea id="reviewContent" name="reviewContent" maxlength="1000" placeholder="솔직한 리뷰를 작성해주세요! 음식의 맛, 서비스, 분위기 등에 대한 생생한 후기를 들려주세요." required></textarea>
                        <div class="char-count" id="reviewContentCounter">0/1000</div>
                    </div>
                    <div class="form-group">
                        <label for="reviewImage">리뷰 사진</label>
                        <input type="file" id="reviewImage" name="reviewImage" accept="image/*">
                        <small class="form-hint">JPG, PNG 파일만 업로드 가능합니다. (최대 5MB)</small>
                    </div>
                </form>
                <div class="review-btns">
                    <a href="${pageContext.request.contextPath}/user/mypage" class="btn cancel"><i class="bi bi-x-circle"></i> 취소</a>
                    <button type="submit" form="reviewForm" class="btn submit"><i class="bi bi-check-circle"></i> 리뷰 등록</button>
                </div>
            </div>
        </div>
        <div class="bottom-nav">
            <a href="${pageContext.request.contextPath}/"><i class="bi bi-house" id="nav"></i>홈</a>
            <a href="${pageContext.request.contextPath}/user/cart" class="cart-nav-item">
                <i class="bi bi-bag" id="nav"></i>장바구니
                <span class="cart-nav-badge">0</span>
            </a>
            <a href="${pageContext.request.contextPath}/user/mypage/like"><i class="bi bi-heart-fill" id="nav"></i>찜</a>
            <a href="${pageContext.request.contextPath}/user/mypage"><i class="bi bi-person-circle" id="nav"></i>마이</a>
        </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/review.js"></script>
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
</body>
</html> 