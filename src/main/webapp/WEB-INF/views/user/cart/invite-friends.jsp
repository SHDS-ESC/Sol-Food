<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<c:set var="PAGE_SIZE" value="10" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>함께 결제할 친구 초대 - Sol Food</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/invite-friends.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="wrap">
    <!-- 헤더 -->
    <jsp:include page="../include/backbtn-header.jsp" />
    <div class="content" style="padding:16px; padding-top:72px;">
        <!-- 선택된 친구들 -->
        <div class="selected-friends" style="margin-bottom:16px;">
            <div class="flex flex-sb" style="align-items:center;">
                <span style="font-weight:600;"><i class="bi bi-people-fill"></i> 선택된 친구</span>
                <span class="selected-count-badge" id="selectedCountBadge" style="background:var(--color-main); color:#fff; border-radius:12px; padding:2px 10px; font-size:13px;">0</span>
            </div>
            <!-- 선택된 친구 태그형 표시 -->
            <div class="selected-friends-list" id="selectedFriendsList"></div>
        </div>
        <!-- 상태 탭 -->
        <div class="flex flex-sa" style="margin-bottom:12px; gap:8px;">
            <button class="btn status-tab" id="tabAll" onclick="changeFilter(this, 'all')" style="flex:1;">전체</button>
            <button class="btn status-tab" id="tabDepartment" onclick="changeFilter(this, 'department')" style="flex:1;">부서</button>
        </div>
        <!-- 검색 -->
        <div class="search-row">
            <input type="text" class="border-input" name="search" placeholder="이름으로 검색하세요..." id="searchInput">
            <button type="button" class="search-btn" onclick="performSearch()"><i class="bi bi-search"></i></button>
            <button type="button" class="clear-btn" onclick="clearSearch()"><i class="bi bi-x-circle"></i></button>
        </div>
        <!-- 친구 리스트 -->
        <div style="margin-bottom:8px;">
          <span id="searchBadge" style="display:none; background:var(--color-main); color:#fff; border-radius:12px; padding:2px 10px; font-size:13px;"></span>
        </div>
        <div id="resultInfo" style="margin-bottom:8px;"></div>
        <!-- 친구 리스트 카드형 -->
        <div class="friends-list" id="friendsList"></div>
        <!-- 페이징 가로 정렬 -->
        <nav aria-label="페이지 네비게이션">
            <ul class="pagination justify-content-center mb-3" id="paginationSection"></ul>
        </nav>
        <!-- 안내문구 (간결하게) -->
        <div class="text-center text-muted mb-3" style="font-size:15px;">
            <span id="selectedCount">0명</span><span id="selectedMessageSub"> 선택됨</span> · <span id="selectedMessage">친구를 선택해주세요.</span>
        </div>

    </div>
    <div class="footer">
        <!-- 초대하기 버튼 -->
        <div class="footer-btn-bar">
            <button class="footer-btn" id="inviteBtn" onclick="handleInvite()" disabled>친구를 선택해주세요</button>
        </div>
    </div>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="<c:url value='/js/urlConstants.js' />"></script>
<script src="<c:url value='/js/common-utils.js' />"></script>
<script src="<c:url value='/js/invite-friends-lite.js' />"></script>
<script src="<c:url value='/js/darkmode.js' />"></script>
<!-- 현재 사용자 정보 (숨김) -->
<div id="currentUserData" 
     data-current-user-id="${currentUser.usersId}"
     data-current-user-name="${currentUser.usersName}"
     data-current-user-profile="${currentUser.usersProfile}"
     data-current-user-company-name="${currentUser.companyName}"
     data-current-user-department-name="${currentUser.departmentName}"
     style="display: none;"></div>
</body>
</html> 