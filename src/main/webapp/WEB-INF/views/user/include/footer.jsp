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
            <span class="cart-nav-badge">0</span>
        </a>

        <a href="${pageContext.request.contextPath}/user/mypage"><i class="bi bi-person-circle"></i>마이</a>
    </div>
</div>

<script>
function updateCartBadge() {
    fetch("${pageContext.request.contextPath}/user/cart/count", {
        credentials: 'include',
        cache: 'no-cache',
        headers: {
            'Cache-Control': 'no-cache'
        }
    })
    .then(function(response) { 
        if (!response.ok) {
            throw new Error('Network response was not ok: ' + response.status);
        }
        return response.json(); 
    })
    .then(function(data) {
        document.querySelectorAll('.cart-nav-badge').forEach(function(badge) {
            badge.textContent = data.count || 0;
        });
    })
    .catch(function(error) {
        document.querySelectorAll('.cart-nav-badge').forEach(function(badge) {
            badge.textContent = 0;
        });
    });
}

window.addEventListener('load', updateCartBadge);
window.addEventListener('popstate', updateCartBadge);
document.addEventListener('DOMContentLoaded', updateCartBadge);
document.addEventListener('visibilitychange', function() {
    if (!document.hidden) {
        updateCartBadge();
    }
});
window.addEventListener('focus', updateCartBadge);
</script>
