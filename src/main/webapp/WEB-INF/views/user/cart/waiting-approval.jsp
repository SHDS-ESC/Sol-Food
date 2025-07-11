<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/payment-header.jsp" %>
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
            <i class="bi bi-credit-card status-icon" id="statusIcon"></i>
            <div class="status-title" id="statusTitle">함께 결제하기</div>
            <div class="status-desc" id="statusDesc">
                총 주문 금액을 인원수로 나누어<br>
                각자 결제를 진행해주세요
            </div>
        </div>

        <!-- 진행 상황 -->
        <div class="progress-section">
            <div class="progress-header">
                <h5><i class="bi bi-people"></i> 결제 현황</h5>
                <div class="progress-count">
                    <span id="acceptedCount">0</span>/<span id="totalCount">4</span> 결제 완료
                </div>
            </div>

            <!-- 총 주문 금액 표시 -->
            <div class="total-amount-section" style="background: #f8f9fa; border-radius: 8px; padding: 16px; margin-bottom: 20px; text-align: center;">
                <div style="font-size: 14px; color: #6c757d; margin-bottom: 8px;">총 주문 금액</div>
                <div style="font-size: 24px; font-weight: bold; color: #ff6b35;" id="totalAmountDisplay">₩0</div>
                <div style="font-size: 12px; color: #6c757d; margin-top: 4px;">
                    <span id="totalPeopleDisplay">0</span>명이 나누어 결제
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
                    결제 대기 중 미니게임을 즐겨보세요!
                </small>
            </div>

            <!-- 결제 상태 새로고침 버튼 -->
            <div class="refresh-section" style="text-align: center; margin: 20px 0;">
                <button class="btn-refresh" id="refreshPaymentStatus" onclick="refreshPaymentStatus()">
                    <i class="bi bi-arrow-clockwise"></i> 결제 상태 새로고침
                </button>
                <small class="text-muted mt-2 d-block">
                    다른 참여자들의 결제 상태를 확인합니다
                </small>
            </div>

            <!-- 액션 버튼들 -->
            <div class="action-buttons">
                <button class="btn-cancel" onclick="cancelInvitation()">
                    <i class="bi bi-arrow-left"></i> 뒤로가기
                </button>
                <button class="btn-danger" onclick="cancelGroupPayment()" style="background: #dc3545; color: white; border: none; padding: 10px 20px; border-radius: 6px; margin-left: 10px;">
                    <i class="bi bi-x-circle"></i> 그룹 결제 취소
                </button>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/js/urlConstants.js' />"></script>
    
    <!-- 현재 사용자 정보 (JS 로드 전에 할당) -->
    <script>
        window.currentUserId = "${currentUser.usersId}";
        window.currentUserCompanyName = "${currentUser.companyName}";
        window.currentUserDepartmentName = "${currentUser.departmentName}";
        window.currentUserEmail = "${currentUser.usersEmail}";
        window.currentUserNickname = "${currentUser.usersNickname}";
        window.currentUserTel = "${currentUser.usersTel}";
        
        // URL 파라미터에서 역할과 paymentId 가져오기
        const urlParams = new URLSearchParams(window.location.search);
        window.userRole = urlParams.get('role') || 'leader'; // 기본값은 leader
        window.paymentId = urlParams.get('paymentId');
        
        console.log('User Role:', window.userRole);
        console.log('Payment ID:', window.paymentId);
    </script>
    
    <!-- 안전한 데이터 전달을 위한 hidden input -->
    <input type="hidden" id="miniGameMessageData" value="<c:out value='${miniGameMessage}' escapeXml='true'/>">
    
    <!-- 현재 사용자 정보 -->
    <div id="currentUserData" 
         data-current-user-id="${currentUser.usersId}"
         data-current-user-name="${currentUser.usersName}"
         data-current-user-email="${currentUser.usersEmail}"
         data-current-user-tel="${currentUser.usersTel}"
         data-current-user-profile="${currentUser.usersProfile}"
         data-current-user-department="${currentUser.departmentId}" 
         data-current-user-company="${currentUser.companyId}"
         data-current-user-company-name="${currentUser.companyName}"
         data-current-user-department-name="${currentUser.departmentName}"
         style="display: none;">
    </div>
    
    <!-- 아임포트 코드 설정 -->
    <script>
        window.impCode = '${impCode}';
    </script>
    
    <!-- 수락 대기 페이지 JavaScript -->
    <script src="<c:url value='/js/waiting-approval.js' />"></script>
</body>
</html> 