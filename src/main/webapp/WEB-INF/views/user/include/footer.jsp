<%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 2025-07-08
  Time: 오전 10:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
</head>
<body>
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

</body>
</html>
