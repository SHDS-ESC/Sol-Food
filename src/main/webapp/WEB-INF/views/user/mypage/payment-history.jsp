<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 내역</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/reset.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/payment-history.css" rel="stylesheet"/>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
    <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
    <script src="${pageContext.request.contextPath}/js/urlConstants.js"></script>
    <script src="${pageContext.request.contextPath}/js/common-utils.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/payment.js"></script>
    <script src="${pageContext.request.contextPath}/js/payment-history.js"></script>
</head>
<body>
<div class="wrap">
    <%@ include file="/WEB-INF/views/user/include/header.jsp" %>

    <div class="content history-container">
            <h1>결제 내역</h1>
            
            <div id="loading" class="loading">
                <p>결제 내역을 불러오는 중...</p>
            </div>
            
            <div id="history-content" style="display: none;">
                <div class="history-list" id="history-list"></div>
                
                <div id="pagination" class="pagination">
                </div>
            </div>
            
            <div id="no-data" class="no-data" style="display: none;">
                <p>결제 내역이 없습니다.</p>
            </div>
            
            <div class="button-group">
                <button class="back-btn" onclick="location.href='${pageContext.request.contextPath}/user/mypage'">
                    마이페이지로<br>돌아가기
                </button>
            </div>
        </div>

    <!-- 가게 ID 입력 모달 -->
    <div id="storeIdModal" class="modal">
        <div class="modal-content">
            <h3>리뷰 작성</h3>
            <p>리뷰를 작성할 가게의 ID를 입력해주세요:</p>
            <input type="number" id="storeIdInput" placeholder="가게 ID를 입력하세요">
            <div class="modal-buttons">
                <button id="confirmStoreId">확인</button>
                <button id="cancelStoreId">취소</button>
            </div>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/user/include/footer.jsp" %>
</div>

<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
</body>
</html> 