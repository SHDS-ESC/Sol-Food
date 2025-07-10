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
            
            <!-- 액션 버튼들 -->
            <div class="action-buttons">
                <button class="btn-cancel" onclick="cancelInvitation()">
                    <i class="bi bi-arrow-left"></i> 뒤로가기
                </button>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="<c:url value='/js/urlConstants.js' />"></script>
    
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
         style="display: none;"></div>
    
    <!-- 선택된 친구들 정보 (서버에서 렌더링) -->
    <script type="application/json" id="selectedFriendsData">
    [
        <c:forEach var="friend" items="${selectedFriends}" varStatus="status">
        {
            "usersId": ${friend.usersId},
            "usersName": "<c:out value='${friend.usersName}' escapeXml='true'/>",
            "usersProfile": "<c:out value='${friend.usersProfile}' escapeXml='true'/>",
            "companyName": "<c:out value='${friend.companyName}' escapeXml='true'/>",
            "departmentName": "<c:out value='${friend.departmentName}' escapeXml='true'/>",
            "usersEmail": "${friend.usersId == currentUser.usersId ? 'CURRENT_USER' : friend.usersEmail}"
        }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ]
    </script>
    
    <!-- 장바구니 정보 -->
    <script type="application/json" id="cartData">
    {
        "totalAmount": ${cart.totalAmount},
        "itemCount": ${cart.items.size()}
    }
    </script>
    
    <!-- 아임포트 코드 설정 -->
    <script>
        window.impCode = '${impCode}';
        console.log('impCode 설정됨:', window.impCode);
    </script>
    
    <!-- 수락 대기 페이지 JavaScript -->
    <script src="<c:url value='/js/waiting-approval.js' />"></script>
    
    <!-- 페이지 로드 확인 -->
    <script>
        console.log('페이지 로드 완료, readyState:', document.readyState);
        console.log('jQuery 로드됨:', typeof $);
        console.log('IMP 로드됨:', typeof window.IMP);
        console.log('requestPayment 로드됨:', typeof window.requestPayment);
        console.log('SweetAlert2 로드됨:', typeof Swal);
        console.log('showPaymentSuccessAlert 로드됨:', typeof showPaymentSuccessAlert);
        console.log('showPaymentErrorAlert 로드됨:', typeof showPaymentErrorAlert);
    </script>
</body>
</html> 