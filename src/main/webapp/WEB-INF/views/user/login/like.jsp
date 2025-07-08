<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>찜 목록</title>
    <script>
        // Context Path를 JavaScript에서 사용할 수 있도록 설정
        var contextPath = '${pageContext.request.contextPath}';
        // 로그인한 사용자 ID를 JavaScript에서 사용할 수 있도록 설정
        window.loginUserId = '${sessionScope.userLoginSession.usersId}';
    </script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link href="<c:url value='/css/reset.css' />" rel="stylesheet">
    <link href="<c:url value='/css/like.css' />" rel="stylesheet">
    <link href="<c:url value='/css/style.css' />" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<div class="wrap">
    <div class="header flex flex-sb">
        <div><strong>로고</strong></div>
        <div class="like-title">찜</div>
        <div style="display: flex; gap: 12px; align-items: center">
            <button
                    id="darkmode-toggle"
                    style="
                  background: none;
                  border: none;
                  cursor: pointer;
                  font-size: 20px;
                  color: var(--color-black);
                "
            >
                <i class="bi bi-moon"></i>
            </button>
            <i class="bi bi-list" style="font-size: 20px"></i>
        </div>
    </div>
    <div class="content like-list">

        <div class="store-count">
            <span>총 : <span id="likeCount">${totalCount}개</span></span>
        </div>
        <div class="store-grid" id="storeGrid">
            <!-- JS로 동적으로 store 목록이 추가될 것 -->
        </div>
        <button id="loadMoreBtn" class="more-btn" style="width:100%;margin:20px auto;display:none;">더보기</button>
    </div>
    <div class="footer flex flex-sa">
        <div class="bottom-nav">
            <a href="${pageContext.request.contextPath}/"
            ><i class="bi bi-house"></i>홈</a
            >
            <a
                    href="${pageContext.request.contextPath}/user/cart"
                    class="cart-nav-item"
            >
                <i class="bi bi-bag"></i>장바구니
                <span class="cart-nav-badge">0</span>
            </a>
            <a href="#"><i class="bi bi-calendar2-week"></i>캘린더</a>
            <a href="${pageContext.request.contextPath}/user/mypage/like"
            ><i class="bi bi-heart-fill"></i>찜</a
            >
            <a href="${pageContext.request.contextPath}/user/mypage"
            ><i class="bi bi-person-circle"></i>마이</a
            >
        </div>
    </div>
</div>

<script src="<c:url value='/js/urlConstants.js' />"></script>
<script src="<c:url value='/js/common-utils.js' />"></script>
<script src="<c:url value='/js/like.js' />"></script>
<script src="<c:url value='/js/darkmode.js' />"></script>

</body>
</html>