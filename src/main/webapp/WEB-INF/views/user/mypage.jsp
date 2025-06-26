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
</head>
<body>
<div class="profile-container">
    <img class="profile-img" src='${userLoginSession.usersProfile }' alt='카카오 프로필 이미지'>
    <div class="nickname">${userLoginSession.usersNickname }님</div>
    <div class="welcome">환영합니다 🎉</div>
    <div>
        <button class="btn btn-logout" onclick="location.href='logout'">로그아웃</button>
        <button class="btn btn-main" onclick="location.href='${pageContext.request.contextPath}/'">메인으로</button>
    </div>
    <hr>
    <div>
        <button class="btn btn-charge" onclick="location.href='${pageContext.request.contextPath}/user/mypage/charge'">충전하기</button>
        <button class="btn btn-cancel" onclick="location.href='${pageContext.request.contextPath}/user/mypage/charge-history'">충전내역보기</button>
    </div>
    <!-- <a href="${pageContext.request.contextPath}/">메인으로</a> -->
</div>
</body>
</html>