<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/payment-header.jsp" %>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
            rel="stylesheet"
    />

    <title>충전하기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/charge.css"/>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="<c:url value='/js/urlConstants.js' />"></script>
    <script src="<c:url value='/js/payment.js' />"></script>
    <script src="<c:url value='/js/charge.js' />"></script>
</head>
<body>
<div class="wrap">

    <%@ include file="/WEB-INF/views/user/include/header.jsp" %>

    <div class="content charge-container">
        <!-- 상단: 현재 충전된 금액 -->
        <div class="current-balance">
            <div class="balance-label">현재 잔액</div>
            <div class="balance-amount">
                <c:choose>
                    <c:when test="${not empty userLoginSession.usersPoint}">
                        ${userLoginSession.usersPoint}
                    </c:when>
                    <c:otherwise>
                        0
                    </c:otherwise>
                </c:choose>
                <span class="balance-unit">원</span>
            </div>
        </div>

        <!-- 중단: 충전 금액 입력 -->
        <div class="charge-input-section">
            <label class="charge-label">충전할 금액</label>
            <input type="number" id="chargeAmount" class="charge-input"
                   placeholder="충전할 금액을 입력하세요" min="100" max="1000000">

            <!-- 빠른 금액 선택 -->
            <div class="quick-amounts">
                <button class="quick-amount-btn" data-amount="10000">10,000원</button>
                <button class="quick-amount-btn" data-amount="30000">30,000원</button>
                <button class="quick-amount-btn" data-amount="50000">50,000원</button>
                <button class="quick-amount-btn" data-amount="100000">100,000원</button>
            </div>
            <div class="error-message"></div>
        </div>

        <!-- 하단: 충전하기 버튼 -->
        <button id="chargeBtn" class="charge-btn" disabled>충전하기</button>

        <div class="button-group">
            <button class="back-btn" onclick="location.href='${pageContext.request.contextPath}/user/mypage'">
                마이페이지로<br>돌아가기
            </button>
            <button class="history-btn" onclick="location.href='${pageContext.request.contextPath}/user/mypage/charge-history'">
                충전내역 보기
            </button>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/user/include/footer.jsp" %>

</div>

<script>
    // 전역 변수 설정
    window.currentBalance = <c:choose>
        <c:when test="${not empty userLoginSession.usersPoint}">${userLoginSession.usersPoint}</c:when>
        <c:otherwise>0</c:otherwise>
    </c:choose>;
    window.impCode = '${impCode}';
    window.userEmail = '${userLoginSession.usersEmail}';
    window.userName = '${userLoginSession.usersNickname}';
    window.userTel = '${userLoginSession.usersTel}';
</script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
</body>
</html> 