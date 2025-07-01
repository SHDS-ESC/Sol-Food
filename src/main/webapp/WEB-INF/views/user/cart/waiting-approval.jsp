<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>수락 대기중 - Sol Food</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- 수락 대기 페이지 CSS -->
    <link rel="stylesheet" href="<c:url value='/css/waiting-approval.css' />">
</head>
<body>
    <div class="waiting-container">
        <!-- 헤더 -->
        <div class="waiting-header">
            <i class="bi bi-arrow-left back-btn" onclick="goBack()"></i>
            <h3 class="mb-0">수락 대기중</h3>
        </div>
        
        <!-- 대기 상태 -->
        <div class="status-section">
            <i class="bi bi-hourglass-split status-icon" id="statusIcon"></i>
            <div class="status-title" id="statusTitle">친구들의 수락을 기다리고 있어요<span class="loading-dots"></span></div>
            <div class="status-desc" id="statusDesc">
                초대받은 친구들이 수락하면<br>
                함께 결제를 진행할 수 있습니다
            </div>
        </div>
        
        <!-- 진행 상황 -->
        <div class="progress-section">
            <div class="progress-header">
                <h5><i class="bi bi-people"></i> 참여 현황</h5>
                <div class="progress-count">
                    <span id="acceptedCount">0</span>/<span id="totalCount">4</span> 수락
                </div>
            </div>
            
            <div class="friends-status" id="friendsStatus">
                <!-- 선택된 친구들이 여기에 동적으로 표시됩니다 -->
            </div>
            
            <!-- 미니게임 버튼 -->
            <div class="mini-game-section">
                <button class="btn-game" onclick="goToMiniGame()">
                    <i class="bi bi-controller"></i> 친구들과 미니게임 하기
                </button>
                <small class="text-muted mt-2 d-block text-center">
                    기다리는 동안 미니게임을 즐겨보세요!
                </small>
            </div>
            
            <!-- 액션 버튼들 -->
            <div class="action-buttons">
                <button class="btn-cancel" onclick="cancelInvitation()">
                    <i class="bi bi-x-circle"></i> 초대 취소
                </button>
                <button class="btn-continue active" id="continueBtn" onclick="proceedToPayment()">
                    <i class="bi bi-credit-card"></i> 결제하기
                </button>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/js/urlConstants.js' />"></script>
    
    <!-- 안전한 데이터 전달을 위한 hidden input -->
    <input type="hidden" id="friendCountData" value="${friendCount != null ? friendCount : 0}">
    <input type="hidden" id="miniGameMessageData" value="<c:out value='${miniGameMessage}' escapeXml='true'/>">
    
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
    
    <!-- 수락 대기 페이지 JavaScript -->
    <script src="<c:url value='/js/waiting-approval.js' />"></script>
</body>
</html> 