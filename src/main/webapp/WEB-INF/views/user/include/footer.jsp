<%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 2025-07-08
  Time: 오전 10:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<div class="footer flex flex-sa">
    <div class="bottom-nav">
        <a href="${pageContext.request.contextPath}/"><i class="bi bi-house"></i>홈</a>

        <a href="${pageContext.request.contextPath}/user/mypage/like"><i class="bi bi-heart-fill"></i>찜</a>

        <a href="${pageContext.request.contextPath}/user/cart" class="cart-nav-item">
            <i class="bi bi-bag" id="nav"></i>장바구니
            <span class="cart-nav-badge">
                <c:choose>
                    <c:when test="${not empty sessionScope.userLoginSession}">
                        <c:choose>
                            <c:when test="${not empty sessionScope.userCart}">
                                <c:out value="${sessionScope.userCart.totalQuantity}" />
                            </c:when>
                            <c:otherwise>0</c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>0</c:otherwise>
                </c:choose>
            </span>
        </a>

        <a href="${pageContext.request.contextPath}/user/mypage"><i class="bi bi-person-circle"></i>마이</a>
    </div>
</div>
