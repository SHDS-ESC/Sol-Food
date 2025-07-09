/**
 * 충전 페이지 JavaScript
 * payment.js의 함수들을 활용하여 충전 전용 UI 로직만 처리
 */

$(function () {
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

        // payment.js의 requestPayment 함수 사용
        requestPayment({
            impCode: window.impCode,
            pg: 'html5_inicis',
            pay_method: 'card',
            merchant_uid: 'charge_' + new Date().getTime(),
            name: '포인트 충전',
            amount: amount,
            buyer_email: window.userEmail,
            buyer_name: window.userName,
            buyer_tel: window.userTel
        }, function (rsp) {
            console.log("결제 응답:", rsp);

            let apiPath = UrlConstants.Builder.fullUrl('/payments/charge/verifyCharge/' + rsp.imp_uid);
            let nextPath = UrlConstants.Builder.fullUrl('/user/mypage');

            if (rsp.success) {
                console.log("Ajax 요청 시작 - URL:", apiPath);

                $.ajax({
                    type: "POST",
                    url: apiPath,
                    contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                    data: {
                        amount: amount,
                        merchant_uid: rsp.merchant_uid
                    },
                    success: function (data) {
                        console.log("Ajax 성공:", data);
                        showPaymentSuccessAlert("충전이 완료되었습니다!", "마이페이지로 이동합니다.", nextPath);
                    },
                    error: function (xhr, status, error) {
                        console.log("Ajax 실패 - Status:", status, "Error:", error);
                        console.log("Response:", xhr.responseText);
                        showPaymentErrorAlert("충전 검증 실패", "충전 검증에 실패했습니다.");
                    }
                });
            } else {
                showPaymentErrorAlert("충전 실패", rsp.error_msg);
            }
        });
    });
}); 