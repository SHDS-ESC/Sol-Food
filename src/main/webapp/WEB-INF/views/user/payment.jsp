<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/payment.js"></script>
    <!-- <script src="<c:url value='/resources/js/payment.js'/>" type="text/javascript"></script> -->
    <script>
        $(function() {
            $('#pay-btn').click(function() {
                requestPayment({
                    impKey: "${impKey}", // Controller에서 내려준 값
                    pg: 'html5_inicis',
                    pay_method: 'card',
                    merchant_uid: 'merchant_' + new Date().getTime(),
                    name: '상품명',
                    amount: 51,
                    buyer_email: 'test@naver.com',
                    buyer_name: '테스터',
                    buyer_tel: '010-1234-5678'
                }, function(rsp) {
                    if (rsp.success) {
                        $.ajax({
                            type: "POST",
                            url: "/payment/verifyIamport/" + rsp.imp_uid,
                            success: function(data) {
                                alert("결제 완료!");
                            },
                            error: function() {
                                alert("서버 검증 실패");
                            }
                        });
                    } else {
                        alert("결제 실패: " + rsp.error_msg + " / ${impKey}");
                    }
                });
            });
        });
    </script>
</head>
<body>
    <button id="pay-btn">결제하기</button>
</body>
</html>
