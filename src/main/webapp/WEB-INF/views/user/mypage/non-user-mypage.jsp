<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    /> -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    <title>solfood</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/reset.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/mypage/non-user-mypage.css"
    />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    
    <!-- Context Path 설정 -->
    <script>
        var contextPath = '${pageContext.request.contextPath}';
    </script>
  </head>
  <body>
    <div class="wrap">
      <div class="header flex flex-sb">
        <div><strong>로고</strong></div>
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
      <div class="content login">
        <div class="login-title">로그인</div>
        <div class="login-desc">지금 가입하면 5천원 즉시 할인!</div>
        <div class="benefit-box">
          <div class="benefit-label">회원가입 즉시 할인</div>
          <div class="benefit-amount">5,000원</div>
        </div>
        <button class="quick-join">5초만에 빠른 회원가입</button>


        <img style="margin-bottom: 12px" src="${pageContext.request.contextPath}/img/kakao_login_medium_wide.png" onclick="location.href=`https://kauth.kakao.com/oauth/authorize?client_id=${apiKey}&redirect_uri=https://${serverMap.ip}${pageContext.request.contextPath}/user/login/kakao-login&response_type=code`">

        <button
          class="sns-btn sns-email"
          onclick="location.href='<c:url value='/user/login'/>'"
        >
          이메일로 로그인
        </button>
        <div class="form-row">
          <a href="<c:url value='/user/login/register'/>" class="form-link"
            >회원가입</a
          >
        </div>
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
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
  </body>
</html>
