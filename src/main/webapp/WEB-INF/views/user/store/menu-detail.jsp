<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${menu.menuName} 상세</title>
    <link href="<c:url value='/css/menudetail.css' />" rel="stylesheet">
</head>
<body>
    <div class="app-view">
        <div class="top-bar">
            <button class="btn simple">로고</button>
            <span class="all-menu">전체메뉴</span>
            <div class="profile-circle"></div>
        </div>

        <div class="menu-image-area">
            <img src="${menu.menuMainimage}" alt="${menu.menuName}" class="menu-image"
                onerror="this.src='https://images.unsplash.com/photo-1590301157890-4810ed352733?w=300&h=200&fit=crop'">
            <div class="menu-name-box">${menu.menuName}</div>
        </div>

        <div class="menu-info">
            <div class="price-row">
                <span>가격</span>
                <span class="menu-price">
                    ₩<fmt:formatNumber value="${menu.menuPrice}" type="number" groupingUsed="true"/>
                </span>
            </div>
            <hr>
            <div class="intro-row" style="margin: 6px 0 18px 0;">
                <span style="color:#888">${menu.menuIntro}</span>
            </div>
            <div class="qty-row">
                <span>수량</span>
                <div class="qty-box">
                    <button class="qty-btn" onclick="changeQty(-1)">-</button>
                    <span id="qty">1개</span>
                    <button class="qty-btn" onclick="changeQty(1)">+</button>
                </div>
            </div>
        </div>

        <button class="add-btn" id="addCartBtn">1개 담기</button>

        <div class="bottom-nav">
            <button class="nav-btn"><i class="bi bi-person"></i></button>
            <button class="nav-btn"><i class="bi bi-list-check"></i></button>
            <button class="nav-btn"><i class="bi bi-house"></i></button>
            <button class="nav-btn"><i class="bi bi-calendar"></i></button>
            <button class="nav-btn donut-btn">🍩</button>
        </div>
    </div>
    <script>
        const menuId = ${menu.menuId};
    </script>
    <script src="<c:url value='/js/menudetail.js' />"></script>
</body>
</html>
