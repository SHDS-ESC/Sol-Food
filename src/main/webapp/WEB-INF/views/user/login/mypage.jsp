<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sol-Food</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/reset.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/mypage.css" rel="stylesheet"/>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

</head>
<body>
<div class="wrap">
    <%@ include file="/WEB-INF/views/user/include/header.jsp" %>
    <div class="content mypage">
    <div class="mypage-header">
        <c:choose>
            <c:when test="${not empty userLoginSession.usersProfile}">
                <img class="profile-img"
                     src="${userLoginSession.usersProfile}"
                     alt="프로필 이미지">
            </c:when>
            <c:otherwise>
                <img class="profile-img"
                     src="/img/main-character.png"
                     alt="프로필 이미지">
            </c:otherwise>
        </c:choose>
        <div class="nickname">${userLoginSession.usersNickname} 님</div>
        <div class="welcome-msg">오늘도 SolFood와 함께 맛있는 하루!</div>
    </div>

    <main>
        <section class="point-section">
            <a class="point-card" href="${pageContext.request.contextPath}/user/mypage/charge">
                💰 마이포인트
                <span class="point-value">
                <c:choose>
                    <c:when test="${not empty userLoginSession.usersPoint}">
                        ${userLoginSession.usersPoint}
                    </c:when>
                    <c:otherwise>100</c:otherwise>
                </c:choose> 원
                </span>
            </a>
        </section>
        <div class="main-menu-grid">
            <a class="menu-card" href="${pageContext.request.contextPath}/user/mypage/edit">
                <span><span class="menu-icon">👤</span>내 정보 수정</span>
                <div class="menu-arrow">&gt;</div>
            </a>
            <a class="menu-card" href="${pageContext.request.contextPath}/user/mypage/like">
                <span><span class="menu-icon">❤️</span>내 찜 </span>
                <div class="menu-arrow">&gt;</div>
            </a>
            <a class="menu-card" href="${pageContext.request.contextPath}/user/mypage/payment-history">
                <span><span class="menu-icon">💳</span>결제 내역</span>
                <span class="menu-arrow">&gt;</span>
            </a>
            <a class="menu-card" href="${pageContext.request.contextPath}/user/review/my-review">
                <span><span class="menu-icon">💬</span>리뷰 관리</span>
                <span class="menu-arrow">&gt;</span>
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty sessionScope.userLoginSession}">
                <a href="<c:url value="/user/login/logout"/>" class="btn btn-primary">로그아웃</a>
            </c:when>
        </c:choose>
    </main>
    </div>
    <%@ include file="/WEB-INF/views/user/include/footer.jsp" %>
</div>

<script src="${pageContext.request.contextPath}/js/store.js?v=${pageContext.session.creationTime}"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
<script src="<c:url value='/js/urlConstants.js' />?v=${pageContext.session.creationTime}"></script>

</body>
</html>