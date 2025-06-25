<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/payment-header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>충전하기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/mypage.css">
    <style>
        /* 충전 페이지 전용 스타일 */
        .charge-container {
            max-width: 500px;
            margin: 50px auto;
            padding: 30px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        
        .current-balance {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
        }
        
        .balance-label {
            font-size: 16px;
            margin-bottom: 10px;
            opacity: 0.9;
        }
        
        .balance-amount {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .balance-unit {
            font-size: 14px;
            opacity: 0.8;
        }
        
        .charge-input-section {
            margin-bottom: 30px;
        }
        
        .charge-label {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 15px;
            display: block;
        }
        
        .charge-input {
            width: 100%;
            padding: 15px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 18px;
            text-align: center;
            margin-bottom: 20px;
            transition: border-color 0.3s;
        }
        
        .charge-input:focus {
            outline: none;
            border-color: #667eea;
        }
        
        .quick-amounts {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .quick-amount-btn {
            flex: 1;
            padding: 10px;
            border: 1px solid #ddd;
            background: white;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .quick-amount-btn:hover {
            background: #f8f9fa;
            border-color: #667eea;
        }
        
        .quick-amount-btn.active {
            background: #667eea;
            color: white;
            border-color: #667eea;
        }
        
        .charge-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: transform 0.2s;
        }
        
        .charge-btn:hover {
            transform: translateY(-2px);
        }
        
        .charge-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        
        .back-btn {
            margin-top: 20px;
            padding: 10px 20px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .back-btn:hover {
            background: #5a6268;
        }
        
        .error-message {
            color: #dc3545;
            font-size: 14px;
            margin-top: 10px;
            display: none;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>
<body>
    <div class="charge-container">
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
        
        <button class="back-btn" onclick="location.href='${pageContext.request.contextPath}/user/mypage'">
            마이페이지로 돌아가기
        </button>
    </div>

    <script>
        $(function() {
            // 현재 잔액
            let currentBalance = <c:choose>
                <c:when test="${not empty userLoginSession.usersPoint}">${userLoginSession.usersPoint}</c:when>
                <c:otherwise>0</c:otherwise>
            </c:choose>;
            
            // 빠른 금액 선택
            $('.quick-amount-btn').click(function() {
                $('.quick-amount-btn').removeClass('active');
                $(this).addClass('active');
                
                let amount = $(this).data('amount');
                $('#chargeAmount').val(amount);
                validateAmount();
            });
            
            // 금액 입력 시 유효성 검사
            $('#chargeAmount').on('input', function() {
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
            $('#chargeBtn').click(function() {
                let amount = parseInt($('#chargeAmount').val()) || 0;
                
                if (amount < 100) {
                    alert('최소 충전 금액은 100원입니다.');
                    return;
                }
                
                if (amount > 1000000) {
                    alert('최대 충전 금액은 1,000,000원입니다.');
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
                }, function(rsp) {
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
                            success: function(data) {
                                console.log("Ajax 성공:", data); // 디버깅 로그 추가

                                swal({
                                    title: "충전이 완료되었습니다!",
                                    text: "마이페이지로 이동합니다.",
                                    icon: "success",
                                    button: "확인",
                                    timer: 1500
                                }).then(function() {
                                    window.location.replace(nextPath);
                                });

                                // 뒤로가기 방지, 다음 페이지로 replace 처리
                                window.location.replace(nextPath);
                            },
                            error: function(xhr, status, error) {
                                console.log("Ajax 실패 - Status:", status, "Error:", error); // 디버깅 로그 추가
                                console.log("Response:", xhr.responseText); // 응답 내용 확인
                                alert("충전 검증에 실패했습니다.");
                            }
                        });
                    } else {
                        alert("충전 실패: " + rsp.error_msg);
                    }
                });
            });
        });
    </script>
</body>
</html> 