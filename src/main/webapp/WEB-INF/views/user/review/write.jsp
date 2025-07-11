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
    <div class="wrap">
        <jsp:include page="../include/header.jsp" />
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
                    <!-- 가게 정보 -->
                    <div class="form-group">
                        <label>가게 정보</label>
                        <div class="store-info">
                            <strong>${store.storeName}</strong>
                            <small class="store-address">${store.storeAddress}</small>
                        </div>
                        <input type="hidden" name="storeId" value="${storeId}">
                        <c:if test="${not empty paymentId}">
                            <input type="hidden" name="paymentId" value="${paymentId}">
                        </c:if>
                        <small class="form-hint">결제 내역에서 자동으로 가져온 가게 정보입니다.</small>
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
        <jsp:include page="../include/footer.jsp" />
    </div>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/popup.js"></script>
    <script src="${pageContext.request.contextPath}/js/review.js"></script>
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
</body>
</html> 