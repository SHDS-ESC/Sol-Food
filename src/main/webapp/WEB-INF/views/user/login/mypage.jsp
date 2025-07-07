<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/payment-header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sol-Food</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="<c:url value='/css/reset.css' />" rel="stylesheet">
    <link href="<c:url value='/css/style.css' />" rel="stylesheet">
    <link href="<c:url value='/css/store.css' />" rel="stylesheet">
    <link href="<c:url value='/css/index.css' />" rel="stylesheet">
    <link href="<c:url value='/css/mypage.css' />" rel="stylesheet">
</head>
<body>
<style>
.logo{display:block;width: 50px;height: 50px;background-image: url('<c:url value="/img/logo.png" />');background-size: cover;background-position: center;}
</style>
<div class="wrap">
    <div class="header">
        <div>
            <span class = "logo"></span>
            <span>마이페이지</span>
        </div>
</div>
<div class="content">
    <!-- 메인 컨텐츠 -->
     <section class="profile-section">
                   <img class="profile-img" src='${not empty userLoginSession.usersProfile ? userLoginSession.usersProfile :
                   "https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800"}' alt='프로필 이미지'>
                   <div class="nickname">${userLoginSession.usersNickname } 님</div>
               </section>
         <main class="main-content">

             <!-- 포인트 카드/코드등록 -->
             <section class="point-section">
                 <div class="point-card">
                       포인트 충전
                   <div class="point-value">
                       <span class="point-num">235,000원</span>
                    </div>
                 <span class="menu-icon">💰</span>

                 </div>

             </section>

             <div class="main-menu-grid">
                 <a class="menu-card food"  href="<c:url value='/user/mypage/info'/>">
                     내 정보 수정
                     <span class="menu-icon">🥗</span>
                 </a>
                  <div class="menu-card">
                      내 찜
                      <span class="menu-icon">🗨️</span>
                  </div>
                 <a class="menu-card exercise" href="<c:url value='/user/mypage/payment-history'/>">
                     결제 내역
                     <span class="menu-icon">🏋️‍♂️</span>
                 </a>
                  <div class="menu-card exercise">
                     리뷰 관리
                     <span class="menu-icon">🥤</span>
                 </div>
             </div>
         </main>

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


<script src="<c:url value='/js/common-utils.js' />?v=${pageContext.session.creationTime}"></script>
<script src="<c:url value='/js/cart.js' />?v=${pageContext.session.creationTime}"></script>
<script src="<c:url value='/js/store.js' />?v=${pageContext.session.creationTime}"></script>

</body>
</html>