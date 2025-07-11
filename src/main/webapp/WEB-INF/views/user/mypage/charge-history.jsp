<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>충전 내역</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/reset.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/charge-history.css" rel="stylesheet"/>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.all.min.js"></script>
    <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
    <script src="${pageContext.request.contextPath}/js/urlConstants.js"></script>
    <script src="${pageContext.request.contextPath}/js/common-utils.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/payment.js"></script>
    <script src="${pageContext.request.contextPath}/js/charge-history.js"></script>
</head>
<body>
<div class="wrap">
    <%@ include file="/WEB-INF/views/user/include/header.jsp" %>

        <div class="content history-container">
            <h1>충전 내역</h1>
            
            <div id="loading" class="loading">
                <p>충전 내역을 불러오는 중...</p>
            </div>
            
            <div id="history-content" style="display: none;">
                <div class="history-list" id="history-list"></div>
                
                <div id="pagination" class="pagination">
                </div>
            </div>
            
            <div id="no-data" class="no-data" style="display: none;">
                <p>충전 내역이 없습니다.</p>
            </div>
            
            <div class="button-group">
                <button class="back-btn" onclick="location.href='${pageContext.request.contextPath}/user/mypage'">
                    마이페이지로<br>돌아가기
                </button>
                <button class="charge-btn" onclick="location.href='${pageContext.request.contextPath}/user/mypage/charge'">
                    충전하기
                </button>
            </div>
        </div>

    <%@ include file="/WEB-INF/views/user/include/footer.jsp" %>
</div>

<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
</body>
</html> 