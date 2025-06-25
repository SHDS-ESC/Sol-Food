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
    <div class="mypage-header">
        <button class="mypage-btn" onclick="location.href='logout'">로그아웃</button>
        <span class="menu-text">전체메뉴</span>
        <div class="profile-thumb"></div>
    </div>
    <div class="profile-section">
        <img class="profile-img" src='${userLoginSession.usersProfile }' alt='카카오 프로필 이미지'>
        <div class="nickname">${userLoginSession.usersNickname } 님</div>
    </div>
    <div class="point-box" onclick="alert('포인트 충전 기능 구현 예정!')">
        <div class="point-title">포인트 충전</div>
        <div class="point-amount">10000p <span class="arrow">&gt;</span></div>
    </div>
    <div class="mypage-menu">
        <div class="menu-row">
            <div class="menu-item" onclick="location.href='mypage/info'">
                <div class="icon user"></div>
                <div>내 정보</div>
            </div>
            <div class="menu-item" onclick="alert('찜 페이지로 이동!')">
                <div class="icon heart"></div>
                <div>찜</div>
            </div>
        </div>
        <div class="menu-row">
            <div class="menu-item" onclick="alert('예약 내역 페이지로 이동!')">
                <div class="icon doc"></div>
                <div>예약 내역</div>
            </div>
            <div class="menu-item" onclick="alert('결제 내역 페이지로 이동!')">
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
</body>
</html>
