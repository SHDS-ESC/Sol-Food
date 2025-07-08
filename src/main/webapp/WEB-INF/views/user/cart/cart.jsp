<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니 - Sol Food</title>
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- Common CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/cart.css?v=${pageContext.session.creationTime}" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
    <div class="wrap">
        <!-- 헤더 -->
        <jsp:include page="../include/backbtn-header.jsp" />

        <!-- 컨텐츠 -->
        <div class="content cart">
            <div class="cart-container">
                <div class="info">
                    <h1><i class="bi bi-cart3"></i> 장바구니</h1>
                </div>
                <div class="cart-scroll-area"></div>
                <c:choose>
                    <c:when test="${empty cart || empty cart.items}">
                        <!-- 빈 장바구니 -->
                        <div class="empty-cart">
                            <i class="bi bi-cart-x"></i>
                            <h4>장바구니가 비어있습니다</h4>
                            <p class="text-muted">맛있는 메뉴를 담아보세요!</p>
                            <a href="${pageContext.request.contextPath}/user/store" class="btn mt-3">
                                <i class="bi bi-shop"></i> 가게 둘러보기
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- 가게 정보 -->
                        <div class="store-name">
                            <i class="bi bi-shop"></i> ${cart.storeName}
                        </div>
                        <!-- 장바구니 아이템들 -->
                        <c:forEach var="item" items="${cart.items}">
                            <div class="cart-item" data-menu-id="${item.menuId}" data-total-price="${item.totalPrice}">
                                <!-- 메뉴 이미지 -->
                                <img src="${item.menuImage}" alt="${item.menuName}" class="item-image"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                <div class="item-image-placeholder" style="display: none;">
                                    <i class="bi bi-image"></i>
                                </div>
                                <!-- 상품 정보 -->
                                <div class="item-info">
                                    <div class="item-header">
                                        <div class="item-name">${item.menuName}</div>
                                        <div class="item-price">
                                            <c:if test="${item.unitPrice != item.menuPrice}">
                                                <span class="original-price">
                                                    <fmt:formatNumber value="${item.menuPrice}" pattern="#,###"/>원
                                                </span>
                                            </c:if>
                                            <span class="final-price">
                                                <fmt:formatNumber value="${item.unitPrice}" pattern="#,###"/>원
                                            </span>
                                        </div>
                                    </div>
                                    <!-- 옵션 정보 -->
                                    <c:if test="${not empty item.options}">
                                        <div class="item-options" data-menu-id="${item.menuId}">
                                            <script type="application/json" class="options-data">
                                                ${item.options}
                                            </script>
                                            <c:if test="${not empty item.menuExtra}">
                                                <script type="application/json" class="menu-extra-data">
                                                    ${item.menuExtra}
                                                </script>
                                            </c:if>
                                        </div>
                                        <div class="options-price" data-options-price="${item.optionsPrice}"></div>
                                    </c:if>
                                    <!-- 수량 조절 -->
                                    <div class="quantity-controls">
                                        <button type="button" class="quantity-btn minus" onclick="changeQuantity('${item.menuId}', -1)">
                                            <i class="bi bi-dash"></i>
                                        </button>
                                        <input type="number" class="quantity-input" 
                                               value="${item.quantity}" 
                                               min="1" 
                                               onchange="updateQuantity('${item.menuId}', this.value)">
                                        <button type="button" class="quantity-btn plus" onclick="changeQuantity('${item.menuId}', 1)">
                                            <i class="bi bi-plus"></i>
                                        </button>
                                    </div>
                                </div>
                                <!-- 삭제 버튼 -->
                                <button type="button" class="remove-btn" onclick="removeItem('${item.menuId}')">
                                    <i class="bi bi-trash"></i>
                                </button>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </div>
            </div>
        </div>

        <!-- 결제 버튼: 푸터 위에 고정 -->
    <div class="footer-btn-bar">
        <button class="footer-btn" onclick="proceedToPayment()">
            <span class="total-amount"><fmt:formatNumber value="${cart.totalAmount}" pattern="#,###"/>원</span>
            결제하기
        </button>
    </div>

    </div>

    <!-- 팝업 -->
    <div class="popup-overlay">
        <div class="popup-box">
            <p class="popup-text">장바구니가 비었습니다.</p>
            <div class="flex">
                <button class="btn submit popup-close">확인</button>
            </div>
        </div>
    </div>

    <!-- Context Path 설정 -->
    <script>
        var contextPath = '${pageContext.request.contextPath}';
    </script>
    <!-- URL Constants -->
    <script src="<c:url value='/js/urlConstants.js' />?v=${pageContext.session.creationTime}"></script>
    <!-- Common Utils (SolFoodUtils) -->
    <script src="<c:url value='/js/common-utils.js' />?v=${pageContext.session.creationTime}"></script>
    <!-- Cart JavaScript -->
    <script src="<c:url value='/js/cart.js' />?v=${pageContext.session.creationTime}"></script>
    <script src="<c:url value='/js/darkmode.js' />"></script>
    
    <script>
    // 페이지 로드 시 장바구니 개수 조회
    document.addEventListener('DOMContentLoaded', function() {
        // 로그인된 사용자인 경우에만 장바구니 개수 조회
        <c:if test="${not empty sessionScope.userLoginSession}">
            fetchCartCount();
        </c:if>
    });

    // 장바구니 개수 조회 함수
    function fetchCartCount() {
        fetch(UrlConstants.Builder.fullUrl(UrlConstants.API.CART_COUNT))
            .then(response => response.json())
            .then(data => {
                const count = data.count || 0;
                SolFoodUtils.updateBadge('.cart-nav-badge', count);
            })
            .catch(error => {
                console.log('장바구니 개수 조회 실패 (로그인하지 않은 경우 등):', error);
            });
    }
    </script>
</body>
</html> 