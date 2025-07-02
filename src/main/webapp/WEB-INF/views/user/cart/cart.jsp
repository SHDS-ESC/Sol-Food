<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>장바구니 - Sol Food</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- Cart CSS -->
    <link rel="stylesheet" href="<c:url value='/css/cart.css' />?v=${pageContext.session.creationTime}">
</head>
<body>
    <div class="cart-container">
        <!-- 헤더 -->
        <div class="cart-header">
            <div class="d-flex justify-content-between align-items-center">
                <h2><i class="bi bi-cart3"></i> 장바구니</h2>
                <a href="${pageContext.request.contextPath}/user/store" class="btn btn-outline-primary">
                    <i class="bi bi-arrow-left"></i> 계속 주문하기
                </a>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${empty cart || empty cart.items}">
                <!-- 빈 장바구니 -->
                <div class="empty-cart">
                    <i class="bi bi-cart-x"></i>
                    <h4>장바구니가 비어있습니다</h4>
                    <p class="text-muted">맛있는 메뉴를 담아보세요!</p>
                    <a href="${pageContext.request.contextPath}/user/store" class="btn btn-primary btn-lg mt-3">
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
                    <div class="cart-item" data-menu-id="${item.menuId}">
                        <div class="row align-items-center">
                            <!-- 메뉴 이미지 -->
                            <div class="col-auto">
                                <img src="${item.menuImage}" alt="${item.menuName}" class="item-image"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                <div class="item-image" style="display: none; background: #f8f9fa; align-items: center; justify-content: center;">
                                    <i class="bi bi-image" style="font-size: 24px; color: #dee2e6;"></i>
                                </div>
                            </div>
                            
                            <!-- 메뉴 정보 -->
                            <div class="col">
                                <div class="item-name">${item.menuName}</div>

                                
                                <!-- 옵션 정보 표시 (안전한 JSON 출력) -->
                                <c:if test="${not empty item.options and item.options != '{}' and item.options != 'null'}">
                                    <div class="item-options" data-menu-id="${item.menuId}">
                                        <script type="application/json" class="options-data">${item.options}</script>
                                        <small class="text-muted">옵션 로딩 중...</small>
                                    </div>
                                </c:if>
                                <div class="item-price">
                                    <c:choose>
                                        <c:when test="${item.unitPrice != item.menuPrice}">
                                            <span class="original-price text-muted text-decoration-line-through">
                                                <fmt:formatNumber value="${item.menuPrice}" pattern="#,###"/>원
                                            </span>
                                            <span class="final-price ms-2">
                                                <fmt:formatNumber value="${item.unitPrice}" pattern="#,###"/>원
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${item.menuPrice}" pattern="#,###"/>원
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <!-- 수량 조절 -->
                            <div class="col-auto">
                                <div class="quantity-controls">
                                    <button class="quantity-btn" onclick="changeQuantity('${item.menuId}', -1)">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                    <input type="number" class="quantity-input" 
                                           value="${item.quantity}" 
                                           min="1" 
                                           onchange="updateQuantity('${item.menuId}', this.value)">
                                    <button class="quantity-btn" onclick="changeQuantity('${item.menuId}', 1)">
                                        <i class="bi bi-plus"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <!-- 소계 -->
                            <div class="col-auto">
                                <div class="fw-bold">
                                    <fmt:formatNumber value="${item.totalPrice}" pattern="#,###"/>원
                                </div>
                            </div>
                            
                            <!-- 삭제 버튼 -->
                            <div class="col-auto">
                                <i class="bi bi-trash remove-btn" onclick="removeItem('${item.menuId}')"></i>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                
                <!-- 장바구니 요약 -->
                <div class="cart-summary">
                    <div class="row align-items-center">
                        <div class="col">
                            <h5>총 주문 금액</h5>
                            <div class="total-amount">
                                <fmt:formatNumber value="${cart.totalAmount}" pattern="#,###"/>원
                            </div>
                            <small class="text-muted">총 ${cart.totalQuantity}개 상품</small>
                        </div>
                        <div class="col-auto">
                            <div class="d-flex gap-2">
                                <button class="btn btn-clear text-white" onclick="clearCart()">
                                    <i class="bi bi-trash"></i> 전체 삭제
                                </button>
                                <button class="btn btn-order text-white" onclick="proceedToPayment()">
                                    <i class="bi bi-credit-card"></i> 주문하기
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
</body>
</html> 