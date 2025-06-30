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
    
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', sans-serif;
        }
        
        .cart-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .cart-header {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .cart-item {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #007bff;
        }
        
        .item-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }
        
        .item-name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 3px;
            line-height: 1.3;
        }
        
        .item-price {
            font-size: 16px;
            color: #007bff;
            font-weight: 600;
        }
        
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .quantity-btn {
            width: 35px;
            height: 35px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .quantity-btn:hover {
            background: #007bff;
            color: white;
            border-color: #007bff;
        }
        
        .quantity-input {
            width: 60px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 8px;
        }
        
        .remove-btn {
            color: #dc3545;
            cursor: pointer;
            font-size: 20px;
            transition: color 0.2s;
        }
        
        .remove-btn:hover {
            color: #b02a37;
        }
        
        .cart-summary {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-left: 4px solid #28a745;
        }
        
        .total-amount {
            font-size: 24px;
            font-weight: 700;
            color: #28a745;
        }
        
        .btn-order {
            background: linear-gradient(135deg, #007bff, #0056b3);
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-order:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,123,255,0.3);
        }
        
        .btn-clear {
            background: linear-gradient(135deg, #dc3545, #c82333);
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-clear:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(220,53,69,0.3);
        }
        
        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .empty-cart i {
            font-size: 64px;
            color: #dee2e6;
            margin-bottom: 20px;
        }
        
        .store-name {
            color: #6c757d;
            font-size: 14px;
            margin-bottom: 15px;
        }
        
        .item-options {
            margin: 8px 0 5px 0;
            font-size: 13px;
            line-height: 1.4;
        }
        
        .option-item {
            display: inline-block;
            background: #e7f3ff;
            padding: 3px 10px;
            margin: 2px 3px 2px 0;
            border-radius: 15px;
            color: #0056b3;
            border: 1px solid #b3d9ff;
            font-size: 12px;
            font-weight: 500;
        }
        
        .option-price {
            color: #007bff;
            font-weight: 600;
        }
        
        .original-price {
            font-size: 14px;
        }
        
        .final-price {
            color: #007bff;
            font-weight: 600;
        }
    </style>
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

                                
                                <!-- 옵션 정보 표시 -->
                                <c:if test="${not empty item.options}">
                                    <div class="item-options" data-menu-id="${item.menuId}" data-options-raw="${item.options}">
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
    <script>
        // 결제 페이지로 이동
        function proceedToPayment() {
            window.location.href = UrlConstants.Builder.fullUrl('/user/cart/payment-method');
        }
        
                // 옵션 정보 표시 (간단 버전)
        function displayOptions() {
            const allOptionElements = document.querySelectorAll('.item-options');
            
            allOptionElements.forEach((element, index) => {
                const rawOptions = element.getAttribute('data-options-raw');
                
                if (rawOptions) {
                    // 옵션이 있으면 간단히 "선택 옵션 적용" 표시
                    const optionHtml = '<span class="option-item">선택 옵션 적용</span>';
                    const small = element.querySelector('small');
                    if (small) {
                        small.outerHTML = optionHtml;
                    }
                } else {
                    // 옵션이 없는 경우 숨김
                    element.style.display = 'none';
                }
            });
        }
        
        // 페이지 로드 완료 후 옵션 정보 표시
        document.addEventListener('DOMContentLoaded', function() {
            displayOptions();
        });
    </script>
    <!-- Cart JavaScript -->
    <script src="<c:url value='/js/cart.js' />?v=${pageContext.session.creationTime}"></script>
</body>
</html> 