<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/payment-header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 방식 선택 - Sol Food</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- 결제 방법 선택 페이지 CSS -->
    <link rel="stylesheet" href="<c:url value='/css/payment-method.css' />">
</head>
<body>
    <div class="payment-container">
        <!-- 헤더 -->
        <div class="payment-header">
            <i class="bi bi-arrow-left back-btn" onclick="goBack()"></i>
            <h3 class="mb-0">결제 방식 선택</h3>
        </div>
        
        <!-- 주문 요약 -->
        <div class="order-summary">
            <h5><i class="bi bi-receipt"></i> 주문 요약</h5>
            <div class="d-flex justify-content-between align-items-center mt-3">
                <span class="text-muted">${cart.storeName}</span>
                <span class="fw-bold">총 ${cart.totalQuantity}개</span>
            </div>
            <div class="d-flex justify-content-between align-items-center mt-2">
                <span class="h5 mb-0">총 결제 금액</span>
                <span class="h4 mb-0 text-primary">
                    <fmt:formatNumber value="${cart.totalAmount}" pattern="#,###"/>원
                </span>
            </div>
        </div>
        
        <!-- 결제 방식 선택 -->
        <div class="payment-methods">
            <div class="payment-option" data-method="solo">
                <div class="emoji">😊</div>
                <div class="payment-title">혼자 결제하기</div>
                <div class="payment-desc">
                    일반적인 개인 결제 방식입니다.<br>
                    바로 결제를 진행합니다.
                </div>
            </div>
            
            <div class="payment-option" data-method="group">
                <div class="emoji">👥</div>
                <div class="payment-title">함께 결제하기</div>
                <div class="payment-desc">
                    친구들과 함께 나눠서 결제합니다.<br>
                    더치페이 및 미니게임을 즐길 수 있어요!
                </div>
            </div>
        </div>
        
        <!-- 계속하기 버튼 -->
        <button class="continue-btn" id="continueBtn" disabled>
            다음 단계로
        </button>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/js/urlConstants.js' />"></script>
    <!-- SweetAlert2 CDN 추가 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <!-- JSP에서 JavaScript로 데이터 전달 -->
    <script>
        // JSP에서 전달받은 cart 데이터를 JavaScript 변수로 설정
        const cartTotalAmount = ${cart.totalAmount};
        const cartStoreId = '${cart.storeId}';
        const cartStoreName = '${cart.storeName}';
        const cartTotalQuantity = ${cart.totalQuantity};
        const userEmail = '${userLoginSession.usersEmail}';
        const userNickname = '${userLoginSession.usersNickname}';
        const userTel = '${userLoginSession.usersTel}';
        const impCode = '${impCode}';

        // var cartTotalAmount = <c:out value="${cart.totalAmount}" default="0"/>;
        // var cartStoreId = "<c:out value='${cart.storeId}' default='' />";
        // var cartStoreName = "<c:out value='${cart.storeName}' default='' />";
        // var cartTotalQuantity = <c:out value="${cart.totalQuantity}" default="0"/>;
        // var userEmail = "<c:out value='${userLoginSession.usersEmail}' default='' />";
        // var userNickname = "<c:out value='${userLoginSession.usersNickname}' default='' />";
        // var userTel = "<c:out value='${userLoginSession.usersTel}' default='' />";
        // var impCode = "<c:out value='${impCode}' default='' />";

    </script>
    
    <!-- 결제 방법 선택 페이지 JavaScript -->
    <script src="<c:url value='/js/payment-method.js' />"></script>
</body>
</html> 