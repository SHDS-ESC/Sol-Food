<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
        crossorigin="anonymous"></script>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <link href="<c:url value='/css/mypage.css' />" rel="stylesheet">
</head>
<body>
<div class="mypage-app">
    <script>
        // Context Path를 JavaScript에서 사용할 수 있도록 설정
        var contextPath = '${pageContext.request.contextPath}';
    </script>
    <div class="mypage-header">
        <button class="mypage-btn" onclick="location.href='${pageContext.request.contextPath}/user/login/logout'">로그아웃</button>
        <span class="menu-text">전체메뉴</span>
        <div class="profile-thumb"></div>
    </div>
    <div class="profile-section">
        <img class="profile-img" src='${not empty userLoginSession.usersProfile ? userLoginSession.usersProfile :
        "https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800"}' alt='프로필 이미지'>
        <div class="nickname">${userLoginSession.usersNickname } 님</div>
    </div>
    <div class="point-box" onclick="showComingSoonAlert('point')">
        <div class="point-title">포인트 충전</div>
        <div class="point-amount">10000p <span class="arrow">&gt;</span></div>
    </div>
    <div class="mypage-menu">
        <div class="menu-row">
            <div class="menu-item" onclick="location.href='${pageContext.request.contextPath}/user/mypage/info'">
                <div class="icon user"></div>
                <div>내 정보</div>
            </div>
            <div class="menu-item" onclick="location.href='${pageContext.request.contextPath}/user/mypage/like'">
                <div class="icon heart"></div>
                <div>찜</div>
            </div>
        </div>

        <div class="menu-row">
            <div class="menu-item" onclick="showComingSoonAlert('reservation')">
                <div class="icon doc"></div>
                <div>예약 내역</div>
            </div>
            <div class="menu-item" onclick="showComingSoonAlert('payment')">
                <div class="icon pay"></div>
                <div>결제 내역</div>
            </div>
        </div>
    </div>
    <div class="nav">
        <button class="nav-btn"><span class="icon home"></span></button>
        <button class="nav-btn"><span class="icon doc"></span></button>
        <button class="nav-btn"><span class="icon user"></span></button>
        <button class="nav-btn active"><span class="icon profile"></span></button>
    </div>
</div>
<script src="<c:url value='/js/urlConstants.js' />"></script>
<script>
// 준비 중인 기능 알림
function showComingSoonAlert(type) {
    const messages = {
        point: '포인트 충전 기능 구현 예정!',
        reservation: '예약 내역 페이지로 이동!',
        payment: '결제 내역 페이지로 이동!'
    };
    alert(messages[type] || '준비 중인 기능입니다.');
}
</script>
<script src="<c:url value='/js/mypage.js' />"></script>
</body>
</html>