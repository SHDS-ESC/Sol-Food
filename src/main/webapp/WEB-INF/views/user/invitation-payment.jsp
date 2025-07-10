<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>초대받은 결제 - SolFood</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/invitation-payment.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="include/header.jsp" />
    
    <div class="container">
        <div class="page-header">
            <h1>초대받은 결제</h1>
            <p>진행 중인 그룹 결제에 참여하세요</p>
        </div>
        
        <div class="invitation-list" id="invitationList">
            <!-- 동적으로 로드될 초대 결제 목록 -->
        </div>
        
        <div class="empty-state" id="emptyState" style="display: none;">
            <div class="empty-icon">
                <i class="bi bi-envelope-open"></i>
            </div>
            <h3>초대받은 결제가 없습니다</h3>
            <p>새로운 그룹 결제 초대를 기다려보세요!</p>
        </div>
        
        <div class="loading" id="loading">
            <div class="spinner"></div>
            <p>결제 목록을 불러오는 중...</p>
        </div>
    </div>
    
    <jsp:include page="include/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/js/invitation-payment.js"></script>
</body>
</html> 