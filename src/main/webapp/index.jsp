<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Sol-Food</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script>
        // Context Path를 JavaScript에서 사용할 수 있도록 설정
        var contextPath = '${pageContext.request.contextPath}';
    </script>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/reset.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/index.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

</head>
<body>
<div class="wrap">
     <div class="header flex flex-sb">
        <div><strong>로고</strong></div>
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
               </c:choose>
            </div>
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

<div class="content main">
         <main class="main-content">
             <section class="main-banner">
                  <!-- <img src="./img/event.png" alt="배너" class = "main-banner-img" >-->
             </section>

             <!-- 포인트 카드/코드등록 -->
             <section class="point-section">
                 <a class="point-card" onclick="location.href='${pageContext.request.contextPath}/user/mypage/charge'">
                       마이포인트
                  <span class="point-value">
                    <c:choose>
                       <c:when test="${not empty userLoginSession.usersPoint}">
                           ${userLoginSession.usersPoint}
                       </c:when>
                       <c:otherwise>
                           100
                       </c:otherwise>
                   </c:choose>
                   원
                    </span>
                 <span class="menu-icon">💰</span>
             </a>

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
      <c:choose>

        <c:when test="${not empty sessionScope.userLoginSession}">
          <a href="${pageContext.request.contextPath}/user/mypage">
            <i class="bi bi-person-circle"></i>마이
          </a>
        </c:when>

        <c:otherwise>
          <a href="${pageContext.request.contextPath}/user/login">
            <i class="bi bi-box-arrow-in-right"></i>로그인
          </a>
        </c:otherwise>
      </c:choose>

    </div>
  </div>
</div>


<script src="<c:url value='/js/common-utils.js' />?v=${pageContext.session.creationTime}"></script>
<script src="<c:url value='/js/cart.js' />?v=${pageContext.session.creationTime}"></script>
<script src="<c:url value='/js/store.js' />?v=${pageContext.session.creationTime}"></script>
<script src="<c:url value='/js/darkmode.js' />"></script>
</body>
</html>