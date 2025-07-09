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
                마이페이지로 돌아가기
            </button>
            <button class="history-btn" onclick="location.href='${pageContext.request.contextPath}/user/mypage/charge-history'">
                충전내역 보기
            </button>
        </div>
    </div>

    <%@ include file="/WEB-INF/views/user/include/footer.jsp" %>

</div>

<script>
    $(function () {
        // 현재 잔액
        let currentBalance = <c:choose>
                <c:when test="${not empty userLoginSession.usersPoint}">${userLoginSession.usersPoint}</c:when>
                <c:otherwise>0</c:otherwise>
            </c:choose>;

        // 빠른 금액 선택
        $('.quick-amount-btn').click(function () {
            $('.quick-amount-btn').removeClass('active');
            $(this).addClass('active');

            let amount = $(this).data('amount');
            $('#chargeAmount').val(amount);
            validateAmount();
        });

        // 금액 입력 시 유효성 검사
        $('#chargeAmount').on('input', function () {
            validateAmount();
        });

        // 금액 유효성 검사 함수
        function validateAmount() {
            let amount = parseInt($('#chargeAmount').val()) || 0;
            let errorMsg = $('.error-message');

            if (amount < 100) {
                errorMsg.text('최소 충전 금액은 100원입니다.').show();
                $('#chargeBtn').prop('disabled', true);
            } else if (amount > 1000000) {
                errorMsg.text('최대 충전 금액은 1,000,000원입니다.').show();
                $('#chargeBtn').prop('disabled', true);
            } else {
                errorMsg.hide();
                $('#chargeBtn').prop('disabled', false);
            }
        }

        // 충전하기 버튼 클릭
        $('#chargeBtn').click(function () {
            let amount = parseInt($('#chargeAmount').val()) || 0;

            if (amount < 100) {
                showPaymentErrorAlert('충전 금액 오류', '최소 충전 금액은 100원입니다.');
                return;
            }

            if (amount > 1000000) {
                showPaymentErrorAlert('충전 금액 오류', '최대 충전 금액은 1,000,000원입니다.');
                return;
            }

            // 결제 요청
            requestPayment({
                impCode: '${impCode}',
                pg: 'html5_inicis',
                pay_method: 'card',
                merchant_uid: 'charge_' + new Date().getTime(),
                name: '포인트 충전',
                amount: amount,
                buyer_email: '${userLoginSession.usersEmail}',
                buyer_name: '${userLoginSession.usersNickname}',
                buyer_tel: '${userLoginSession.usersTel}'
            }, function (rsp) {
                console.log("결제 응답:", rsp); // 디버깅 로그 추가

                let apiPath = "${pageContext.request.contextPath}/payments/charge/verifyCharge/" + rsp.imp_uid;
                let nextPath = "${pageContext.request.contextPath}/user/mypage";

                if (rsp.success) {
                    console.log("Ajax 요청 시작 - URL:", apiPath); // 디버깅 로그 추가

                    $.ajax({
                        type: "POST",
                        url: apiPath,  // 실제 충전 엔드포인트
                        contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                        data: {
                            amount: amount,
                            merchant_uid: rsp.merchant_uid
                        },
                        success: function (data) {
                            console.log("Ajax 성공:", data);

                            // 공통 결제 완료 알림 함수 사용
                            showPaymentSuccessAlert("충전이 완료되었습니다!", "마이페이지로 이동합니다.", nextPath);
                        },
                        error: function (xhr, status, error) {
                            console.log("Ajax 실패 - Status:", status, "Error:", error); // 디버깅 로그 추가
                            console.log("Response:", xhr.responseText); // 응답 내용 확인
                            showPaymentErrorAlert("충전 검증 실패", "충전 검증에 실패했습니다.");
                        }
                    });
                } else {
                    showPaymentErrorAlert("충전 실패", rsp.error_msg);
                }
            });
        });
    });
</script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
</body>
</html> 