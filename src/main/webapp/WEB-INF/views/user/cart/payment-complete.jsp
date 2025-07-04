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
    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    
    <style>
        .payment-complete-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        
        .success-icon {
            font-size: 80px;
            color: #28a745;
            margin-bottom: 20px;
        }
        
        .order-info {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
        }
        
        .order-item {
            display: flex;
            justify-content: space-between;
            margin: 10px 0;
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .order-item:last-child {
            border-bottom: none;
            font-weight: bold;
            font-size: 18px;
            color: #ff6b35;
        }
        
        .btn-home {
            background: #ff6b35;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: bold;
            margin: 10px;
        }
        
        .btn-home:hover {
            background: #e55a2b;
            color: white;
        }
    </style>
</head>
<body style="background: #f5f5f5;">
    <div class="payment-complete-container">
        <!-- 성공 아이콘 -->
        <div class="text-center">
            <i class="bi bi-check-circle-fill success-icon"></i>
            <h2 class="mb-3">결제가 완료되었습니다!</h2>
            <p class="text-muted">주문이 성공적으로 처리되었습니다.</p>
        </div>
        
        <!-- 주문 정보 -->
        <div class="order-info">
            <h5 class="mb-3"><i class="bi bi-receipt"></i> 주문 정보</h5>
            
            <div class="order-item">
                <span>주문번호:</span>
                <span>${param.orderNumber}</span>
            </div>
            
            <div class="order-item">
                <span>매장명:</span>
                <span>${param.storeName}</span>
            </div>
            
            <div class="order-item">
                <span>주문 수량:</span>
                <span>${param.totalQuantity}개</span>
            </div>
            
            <div class="order-item">
                <span>결제 수단:</span>
                <span>${param.paymentMethod}</span>
            </div>
            
            <div class="order-item">
                <span>결제 금액:</span>
                <span>₩${param.totalAmount}</span>
            </div>
        </div>
        
        <!-- 액션 버튼 -->
        <div class="text-center">
            <a href="<c:url value='/user/store/list' />" class="btn btn-home">
                <i class="bi bi-house"></i> 홈으로 돌아가기
            </a>
            <a href="<c:url value='/user/cart' />" class="btn btn-home">
                <i class="bi bi-cart"></i> 장바구니 보기
            </a>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    
    <script>
        // 페이지 로드 시 성공 메시지 표시
        document.addEventListener('DOMContentLoaded', function() {
            Swal.fire({
                title: '결제 완료!',
                text: '주문이 성공적으로 처리되었습니다.',
                icon: 'success',
                confirmButtonText: '확인',
                timer: 2000,
                timerProgressBar: true
            });
        });
    </script>
</body>
</html> 