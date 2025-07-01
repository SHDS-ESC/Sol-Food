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
    <title>결제 완료 - Sol Food</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- 결제 완료 페이지 CSS -->
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Noto Sans KR', sans-serif;
        }
        
        .payment-complete-container {
            max-width: 500px;
            margin: 0 auto;
            padding: 20px;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .complete-header {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px 0;
        }
        
        .success-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #28a745, #20c997);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            color: white;
            font-size: 40px;
        }
        
        .complete-title {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .complete-subtitle {
            color: #666;
            font-size: 16px;
        }
        
        .order-details {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .order-details h5 {
            color: #333;
            margin-bottom: 20px;
            font-weight: bold;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .detail-row:last-child {
            border-bottom: none;
            font-weight: bold;
            font-size: 18px;
            color: #007bff;
        }
        
        .detail-label {
            color: #666;
        }
        
        .detail-value {
            color: #333;
            font-weight: 500;
        }
        
        .action-buttons {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin-top: auto;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #007bff, #0056b3);
            border: none;
            border-radius: 10px;
            padding: 15px;
            font-weight: bold;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,123,255,0.3);
        }
        
        .btn-outline-secondary {
            border: 2px solid #6c757d;
            border-radius: 10px;
            padding: 15px;
            font-weight: bold;
            font-size: 16px;
            color: #6c757d;
            background: transparent;
            transition: all 0.3s ease;
        }
        
        .btn-outline-secondary:hover {
            background: #6c757d;
            color: white;
            transform: translateY(-2px);
        }
        
        .order-number {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .order-number strong {
            color: #007bff;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <div class="payment-complete-container">
        <!-- 완료 헤더 -->
        <div class="complete-header">
            <div class="success-icon">
                <i class="bi bi-check-lg"></i>
            </div>
            <h1 class="complete-title">결제가 완료되었습니다!</h1>
            <p class="complete-subtitle">주문이 성공적으로 처리되었습니다.</p>
        </div>
        
        <!-- 주문 번호 -->
        <div class="order-number">
            <p class="mb-1">주문 번호</p>
            <strong id="orderNumber"></strong>
        </div>
        
        <!-- 주문 상세 정보 -->
        <div class="order-details">
            <h5><i class="bi bi-receipt"></i> 주문 정보</h5>
            <div class="detail-row">
                <span class="detail-label">매장명</span>
                <span class="detail-value" id="storeName"></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">주문 수량</span>
                <span class="detail-value" id="totalQuantity"></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">결제 금액</span>
                <span class="detail-value" id="totalAmount"></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">결제 방법</span>
                <span class="detail-value" id="paymentMethod"></span>
            </div>
            <div class="detail-row">
                <span class="detail-label">결제 시간</span>
                <span class="detail-value" id="paymentTime"></span>
            </div>
        </div>
        
        <!-- 액션 버튼들 -->
        <div class="action-buttons">
            <button class="btn btn-primary" onclick="goToOrderHistory()">
                <i class="bi bi-clock-history"></i> 주문 내역 보기
            </button>
            <button class="btn btn-outline-secondary" onclick="goToHome()">
                <i class="bi bi-house"></i> 홈으로 돌아가기
            </button>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/js/urlConstants.js' />"></script>
    
    <!-- JSP에서 JavaScript로 데이터 전달 -->
    <script>
        // URL 파라미터에서 주문 정보 가져오기
        const urlParams = new URLSearchParams(window.location.search);
        const orderNumber = urlParams.get('orderNumber') || 'ORDER_' + new Date().getTime();
        const storeName = urlParams.get('storeName') || '매장명';
        const totalQuantity = urlParams.get('totalQuantity') || '0';
        const totalAmount = urlParams.get('totalAmount') || '0';
        const paymentMethod = urlParams.get('paymentMethod') || '카드';
        
        // 현재 시간 포맷팅
        const now = new Date();
        const paymentTime = now.getFullYear() + '-' + 
                           String(now.getMonth() + 1).padStart(2, '0') + '-' + 
                           String(now.getDate()).padStart(2, '0') + ' ' +
                           String(now.getHours()).padStart(2, '0') + ':' + 
                           String(now.getMinutes()).padStart(2, '0');
        
        // 페이지 로드 시 정보 표시
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('orderNumber').textContent = orderNumber;
            document.getElementById('storeName').textContent = storeName;
            document.getElementById('totalQuantity').textContent = totalQuantity + '개';
            document.getElementById('totalAmount').textContent = Number(totalAmount).toLocaleString() + '원';
            document.getElementById('paymentMethod').textContent = paymentMethod;
            document.getElementById('paymentTime').textContent = paymentTime;
        });
        
        function goToOrderHistory() {
            window.location.href = UrlConstants.Builder.fullUrl('/user/mypage');
        }
        
        function goToHome() {
            window.location.href = UrlConstants.Builder.fullUrl('/user/store/list');
        }
    </script>
</body>
</html> 