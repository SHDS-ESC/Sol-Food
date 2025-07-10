<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>찜 목록</title>
    <script>
        // Context Path를 JavaScript에서 사용할 수 있도록 설정
        var contextPath = '${pageContext.request.contextPath}';
        // 로그인한 사용자 ID를 JavaScript에서 사용할 수 있도록 설정
        window.loginUserId = '${sessionScope.userLoginSession.usersId}';
    </script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <link href="${pageContext.request.contextPath}/css/reset.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/like.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<div class="wrap">

    <%@ include file="../include/header.jsp" %>

    <div class="content like-list">
        <div class="title">찜</div>
        <div class="store-count">
            <span>총 : <span id="likeCount">${totalCount}개</span></span>
        </div>
        <div class="store-grid" id="storeGrid">
            <!-- JS로 동적으로 store 목록이 추가될 것 -->
        </div>
        <button id="loadMoreBtn" class="more-btn">더보기</button>
    </div>

    <%@ include file="../include/footer.jsp" %>

</div>

<script src="${pageContext.request.contextPath}/js/urlConstants.js"></script>
<script src="${pageContext.request.contextPath}/js/common-utils.js"></script>
<script src="${pageContext.request.contextPath}/js/like.js"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
</body>
</html>