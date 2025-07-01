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
        
        <!-- 선택된 친구들 표시 영역 -->
        <div class="selected-friends-section" id="selectedFriendsSection">
            <div class="selected-friends-header">
                <h6><i class="bi bi-people-fill"></i> 선택된 친구들</h6>
                <span class="selected-count-badge" id="selectedCountBadge">0</span>
            </div>
            <div class="selected-friends-list" id="selectedFriendsList">
                <!-- 선택된 친구들이 여기에 동적으로 표시됩니다 -->
            </div>
        </div>
        
        <!-- 상태 탭 -->
        <div class="status-tabs d-flex">
            <button class="status-tab ${param.filter == null || param.filter == 'all' ? 'active' : ''}" data-filter="all">전체</button>
            <button class="status-tab ${param.filter == 'department' ? 'active' : ''}" data-filter="department">부서</button>
        </div>
        
        <!-- 검색 섹션 -->
        <div class="search-section">
            <form method="GET" action="${pageContext.request.contextPath}/user/cart/invite-friends" class="row g-2" id="searchForm">
                <div class="col-md-8">
                    <input type="text" 
                           class="form-control search-input" 
                           name="search" 
                           value="${search}" 
                           placeholder="이름으로 검색하세요..."
                           id="searchInput">
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn search-btn w-100">
                        <i class="bi bi-search"></i> 검색
                    </button>
                </div>
                <div class="col-md-2">
                    <button type="button" class="btn clear-btn w-100" onclick="clearSearch()">
                        <i class="bi bi-x-circle"></i> 초기화
                    </button>
                </div>
                <input type="hidden" name="page" value="1">
                <input type="hidden" name="size" value="${PAGE_SIZE}">
                <input type="hidden" name="filter" value="${param.filter != null ? param.filter : 'all'}" id="filterInput">
                <!-- 선택된 친구들을 hidden input으로 포함 -->
                <input type="hidden" name="selected" value="${param.selected}" id="selectedInput">
            </form>
        </div>
        
        <!-- 친구 목록 -->
        <div class="friends-section">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5><i class="bi bi-people"></i> 함께 결제할 친구 초대</h5>
                <c:if test="${not empty search}">
                    <span class="badge bg-primary">"${search}" 검색 결과</span>
                </c:if>
            </div>
            
            <!-- 결과 정보 -->
            <div class="result-info">
                <i class="bi bi-info-circle"></i>
                <c:choose>
                    <c:when test="${param.filter == 'department'}">
                        부서 내 ${totalCount}명 중 ${pageMaker.list.size()}명 표시 
                    </c:when>
                    <c:otherwise>
                        전체 ${totalCount}명 중 ${pageMaker.list.size()}명 표시 
                    </c:otherwise>
                </c:choose>
                (${currentPage}/${pageMaker.pageCount} 페이지)
            </div>
            
            <p class="text-muted mb-4">같이 결제할 친구들을 선택해주세요</p>
            
            <div class="friends-list" id="friendsList">
                <c:choose>
                    <c:when test="${not empty pageMaker.list}">
                        <c:forEach var="user" items="${pageMaker.list}">
                            <div class="friend-item" 
                                 data-friend-id="${user.usersId}" 
                                 data-company-id="${user.companyId}"
                                 data-department-id="${user.departmentId}" 
                                 data-user-name="${user.usersName}"
                                 data-user-profile="${user.usersProfile}"
                                 data-company-info="${user.companyName} - ${user.departmentName}"
                                 onclick="toggleFriend(this)">
                                <div class="friend-avatar" 
                                     <c:if test="${not empty user.usersProfile}">
                                         style="background-image: url('${user.usersProfile}');"
                                     </c:if>>
                                    <c:if test="${empty user.usersProfile}">
                                        ${user.usersName.substring(0, 1)}
                                    </c:if>
                                </div>
                                <div class="friend-info">
                                    <div class="friend-name">${user.usersName}</div>
                                    <div class="friend-company">${user.companyName} - ${user.departmentName}</div>
                                </div>
                                <i class="bi bi-check-circle-fill check-icon"></i>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center text-muted py-5">
                            <i class="bi bi-search" style="font-size: 48px; margin-bottom: 16px; opacity: 0.3;"></i>
                            <p>
                                <c:choose>
                                    <c:when test="${not empty search}">
                                        "${search}" 검색 결과가 없습니다.
                                    </c:when>
                                    <c:otherwise>
                                        같은 회사에 초대할 수 있는 사용자가 없습니다.
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        
        <!-- 페이징 섹션 -->
        <c:if test="${pageMaker.pageCount > 1}">
            <div class="pagination-section">
                <nav aria-label="페이지 네비게이션">
                    <ul class="pagination justify-content-center mb-0">
                        <!-- 첫 페이지 -->
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=1&size=${PAGE_SIZE}&filter=${param.filter != null ? param.filter : 'all'}<c:if test='${not empty search}'>&search=${search}</c:if><c:if test='${not empty param.selected}'>&selected=${param.selected}</c:if>">
                                    <i class="bi bi-chevron-double-left"></i>
                                </a>
                            </li>
                        </c:if>
                        
                        <!-- 이전 페이지 -->
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}&size=${PAGE_SIZE}&filter=${param.filter != null ? param.filter : 'all'}<c:if test='${not empty search}'>&search=${search}</c:if><c:if test='${not empty param.selected}'>&selected=${param.selected}</c:if>">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>
                        
                        <!-- 페이지 번호들 -->
                        <c:forEach var="pageNum" begin="${pageMaker.firstPage}" end="${pageMaker.lastPage}">
                            <li class="page-item ${currentPage == pageNum ? 'active' : ''}">
                                <a class="page-link" href="?page=${pageNum}&size=${PAGE_SIZE}&filter=${param.filter != null ? param.filter : 'all'}<c:if test='${not empty search}'>&search=${search}</c:if><c:if test='${not empty param.selected}'>&selected=${param.selected}</c:if>">
                                    ${pageNum}
                                </a>
                            </li>
                        </c:forEach>
                        
                        <!-- 다음 페이지 -->
                        <c:if test="${currentPage < pageMaker.pageCount}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}&size=${PAGE_SIZE}&filter=${param.filter != null ? param.filter : 'all'}<c:if test='${not empty search}'>&search=${search}</c:if><c:if test='${not empty param.selected}'>&selected=${param.selected}</c:if>">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                        
                        <!-- 마지막 페이지 -->
                        <c:if test="${currentPage < pageMaker.pageCount}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${pageMaker.pageCount}&size=${PAGE_SIZE}&filter=${param.filter != null ? param.filter : 'all'}<c:if test='${not empty search}'>&search=${search}</c:if><c:if test='${not empty param.selected}'>&selected=${param.selected}</c:if>">
                                    <i class="bi bi-chevron-double-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
                
                <!-- 페이지 정보 -->
                <div class="mt-3 text-muted">
                    <small>
                        <i class="bi bi-info-circle"></i>
                        ${currentPage} / ${pageMaker.pageCount} 페이지 (총 ${totalCount}명)
                    </small>
                </div>
            </div>
        </c:if>
        
        <!-- 선택된 친구 수 -->
        <div class="selected-count">
            <span class="text-muted">선택된 친구: </span>
            <span class="fw-bold text-primary" id="selectedCount">0명</span>
        </div>
        
        <!-- 초대하기 버튼 -->
        <button class="continue-btn active" id="inviteBtn" onclick="inviteFriends()">
            선택한 친구들에게 초대 보내기
        </button>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/js/urlConstants.js' />"></script>
    
    <!-- 메타 데이터 -->
    <meta name="contextPath" content="${pageContext.request.contextPath}">
    
    <!-- 현재 사용자 정보 -->
    <div id="currentUserData" 
         data-current-user-id="${currentUser.usersId}"
         data-current-user-name="${currentUser.usersName}"
         data-current-user-profile="${currentUser.usersProfile}"
         data-current-user-department="${currentUser.departmentId}" 
         data-current-user-company="${currentUser.companyId}"
         data-current-user-company-name="${currentUser.companyName}"
         data-current-user-department-name="${currentUser.departmentName}"
         style="display: none;"></div>
    
    <!-- 친구 초대 페이지 JavaScript -->
    <script src="<c:url value='/js/invite-friends.js' />?v=3.0"></script>
</body>
</html> 