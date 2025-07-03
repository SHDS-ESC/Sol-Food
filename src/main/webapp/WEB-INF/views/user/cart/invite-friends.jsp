<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%-- 페이지 상수 설정 --%>
<c:set var="PAGE_SIZE" value="10" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>함께 결제할 친구 초대 - Sol Food</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- 친구 초대 페이지 CSS -->
    <link rel="stylesheet" href="<c:url value='/css/invite-friends.css' />?v=3.0">
</head>
<body>
    <div class="invite-container">
        <!-- 헤더 -->
        <div class="invite-header">
            <i class="bi bi-arrow-left back-btn" onclick="goBack()"></i>
            <h3 class="mb-0">함께 결제할 친구 초대</h3>
        </div>
        
        <!-- 선택된 친구들 표시 영역 (실시간 업데이트) -->
        <div class="selected-friends-section" id="selectedFriendsSection">
            <div class="selected-friends-header">
                <h6><i class="bi bi-people-fill"></i> 선택된 친구들</h6>
                <span class="selected-count-badge" id="selectedCountBadge">0</span>
            </div>
            <div class="selected-friends-list" id="selectedFriendsList">
                <!-- 동적으로 생성됨 -->
            </div>
        </div>
        
        <!-- 상태 탭 (AJAX 방식) -->
        <div class="status-tabs d-flex">
            <button class="status-tab active" data-filter="all" onclick="changeFilter(this, 'all')">전체</button>
            <button class="status-tab" data-filter="department" onclick="changeFilter(this, 'department')">부서</button>
        </div>
        
        <!-- 검색 섹션 (AJAX 방식) -->
        <div class="search-section">
            <div class="row g-2" id="searchForm">
                <div class="col-md-8">
                    <input type="text" 
                           class="form-control search-input" 
                           name="search" 
                           placeholder="이름으로 검색하세요..."
                           id="searchInput">
                </div>
                <div class="col-md-2">
                    <button type="button" class="btn search-btn w-100" onclick="performSearch()">
                        <i class="bi bi-search"></i> 검색
                    </button>
                </div>
                <div class="col-md-2">
                    <button type="button" class="btn clear-btn w-100" onclick="clearSearch()">
                        <i class="bi bi-x-circle"></i> 초기화
                    </button>
                </div>
            </div>
        </div>
        
        <!-- 친구 목록 -->
        <div class="friends-section">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5><i class="bi bi-people"></i> 함께 결제할 친구 초대</h5>
                <span class="badge bg-primary" id="searchBadge" style="display: none;"></span>
            </div>
            
            <!-- 결과 정보 -->
            <div class="result-info" id="resultInfo">
                <!-- 동적으로 업데이트 -->
            </div>
            
            <p class="text-muted mb-4">같이 결제할 친구들을 선택해주세요</p>
            
            <div class="friends-list" id="friendsList">
                <!-- AJAX로 동적 로딩 -->
                <div class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">로딩중...</span>
                    </div>
                    <p class="mt-3 text-muted">친구 목록을 불러오는 중...</p>
                </div>
            </div>
        </div>
        
        <!-- 페이징 섹션 (AJAX 방식) -->
        <div class="pagination-section" id="paginationSection" style="display: none;">
            <!-- 동적으로 생성됨 -->
        </div>
        
        <!-- 선택 상태 및 메시지 -->
        <div class="selected-summary">
            <div class="selected-count">
                <span class="text-muted">선택된 친구: </span>
                <span class="fw-bold text-primary" id="selectedCount">0명</span>
            </div>
            <div class="selected-message text-center mt-2" id="selectedMessage">
                친구를 선택해주세요.
            </div>
        </div>
        
        <!-- 초대하기 버튼 -->
        <button class="continue-btn" 
                id="inviteBtn" 
                onclick="handleInvite()"
                disabled>
            친구를 선택해주세요
        </button>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- JavaScript 순서 중요 -->
    <script src="<c:url value='/js/urlConstants.js' />"></script>
    <script src="<c:url value='/js/common-utils.js' />"></script>
    <script src="<c:url value='/js/invite-friends-lite.js' />"></script>
    
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