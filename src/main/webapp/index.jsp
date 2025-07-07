<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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


</head>
<body>
<style>
.logo{display:block;width: 50px;height: 50px;background-image: url('<c:url value="/img/logo.png" />');background-size: cover;background-position: center;}
</style>
<div class="wrap">
    <div class="header">
        <div>
            <span class = "logo"></span>
        </div>
        <div class="login-btns">
           <c:choose>
               <c:when test="${not empty sessionScope.userLoginSession}">
                   <a class="welcome-message">
                       <i class="fas fa-user-circle"></i>
                       ${sessionScope.userLoginSession.usersName}님 환영합니다!
                   </a>
                   <span>
                   <a href="<c:url value="/user/login/logout"/>" class="btn btn-primary">로그아웃</a>
               </c:when>
               <c:otherwise>
                   <a href="<c:url value="/user/login"/>" class="btn btn-primary">
                       <i class="fas fa-user"></i> 로그인
                   </a>
                   <a href="<c:url value="/user/login/register"/>" class="btn btn-secondary">
                       <i class="fas fa-user-plus"></i> 회원가입
                   </a>
               </c:otherwise>
           </c:choose>
        </div>
        <div><i class="bi bi-list" style="font-size: 20px;"></i></div>
    </div>

<div class="content">
    <!-- 메인 컨텐츠 -->
         <main class="main-content">
             <!-- 배너 -->
             <section class="main-banner">
                  <!-- <img src="./img/event.png" alt="배너" class = "main-banner-img" >-->
             </section>

             <!-- 포인트 카드/코드등록 -->
             <section class="point-section">
                 <div class="point-card">
                       마이포인트
                   <div class="point-value">
                       <span class="point-num">235,000원</span>
                    </div>
                 <span class="menu-icon">💰</span>

                 </div>

             </section>

             <div class="main-menu-grid">
                 <a class="menu-card food"  href="<c:url value='/user/store/list'/>">
                     식사하기
                     <span class="menu-icon">🥗</span>
                 </a>
                  <div class="menu-card">
                      커뮤니티
                      <span class="menu-icon">🗨️</span>
                  </div>
                 <div class="menu-card exercise">
                     제휴 문의
                     <span class="menu-icon">🏋️‍♂️</span>
                 </div>
                  <div class="menu-card exercise">
                     후원
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
