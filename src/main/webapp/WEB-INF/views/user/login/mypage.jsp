<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/payment-header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypage.css">
    <script src="${pageContext.request.contextPath}/resources/js/payment.js"></script>
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
</div>
<div class="welcome">환영합니다 🎉</div>
<div>
    <button class="btn btn-logout" onclick="location.href='logout'">로그아웃</button>
    <button class="btn btn-main" onclick="location.href='${pageContext.request.contextPath}/'">메인으로</button>
    <button class="btn btn-charge" onclick="location.href='${pageContext.request.contextPath}/user/mypage/charge'">충전하기</button>
    <button class="btn btn-cancel" onclick="location.href='${pageContext.request.contextPath}/user/mypage/charge-history'">충전내역보기</button>
    <!-- <a href="${pageContext.request.contextPath}/">메인으로</a> -->
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
            <div class="menu-item" onclick="location.href='${pageContext.request.contextPath}/user/mypage/payment-history'">
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