<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="${pageContext.request.contextPath}/css/header.css" rel="stylesheet">
<div class="header flex flex-sb">
  <div>
    <img id="mainLogo" src="${pageContext.request.contextPath}/img/logo.png" alt="SolFood 로고" style="height: 130px; margin-top:-10px">
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
    <i class="bi bi-envelope active" style="font-size: 22px"></i>
    <i class="bi bi-list" id="all-menu-btn" style="font-size: 20px"></i>
  </div>
</div>

<!-- 전체 메뉴 오버레이 -->
<div id="all-menu-overlay" style="display:none; position:fixed; top:0; left:0; width:100vw; height:100vh; background:rgba(0,0,0,0.6); z-index:9999;">
  <div class="all-menu-panel">
    <button id="close-all-menu" style="background:none; border:none; font-size:24px; float:right; cursor:pointer;">&times;</button>
    <h2 style="margin-top:0;">전체 메뉴</h2>
    <ul style="list-style:none; padding:0; margin:24px 0 0 0; font-size:18px;">
      <li><a href="${pageContext.request.contextPath}/user/mypage">마이페이지</a></li>
      <li><a href="${pageContext.request.contextPath}/user/cart">장바구니</a></li>
      <li><a href="${pageContext.request.contextPath}/user/mypage/payment-history">결제내역</a></li>
      <li><a href="${pageContext.request.contextPath}/user/like">찜한가게</a></li>
      <li><a href="${pageContext.request.contextPath}/user/review/my-review">리뷰관리</a></li>
      <li><a href="${pageContext.request.contextPath}/user/store/list">가게목록</a></li>
      <li><a href="${pageContext.request.contextPath}/user/board/list">게시판</a></li>
    </ul>
  </div>
</div>
<script src="${pageContext.request.contextPath}/js/header.js"></script>
<script>
  window.contextPath = '${pageContext.request.contextPath}';
</script>
