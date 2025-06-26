/**
 * 아임포트 결제 요청 함수
 * @param {Object} options - 결제 옵션 객체
 * @param {string} options.impCode - 아임포트 가맹점 식별코드
 * @param {string} [options.pg='html5_inicis'] - PG사 코드 (기본값: html5_inicis)
 * @param {string} [options.pay_method='card'] - 결제수단 (기본값: card)
 * @param {string} [options.merchant_uid] - 가맹점 주문번호 (미입력시 자동생성)
 * @param {string} [options.name='상품명'] - 주문명 (기본값: 상품명)
 * @param {number} [options.amount=0] - 결제금액 (기본값: 0)
 * @param {string} [options.buyer_email=''] - 구매자 이메일 (기본값: 빈 문자열)
 * @param {string} [options.buyer_name=''] - 구매자 이름 (기본값: 빈 문자열)
 * @param {string} [options.buyer_tel=''] - 구매자 전화번호 (기본값: 빈 문자열)
 * @param {Function} callback - 결제 완료 후 실행될 콜백 함수
 * @param {Object} callback.response - 결제 응답 객체
 * @param {string} callback.response.imp_uid - 아임포트 결제 고유번호
 * @param {string} callback.response.merchant_uid - 가맹점 주문번호
 * @param {string} callback.response.success - 결제 성공 여부
 * @param {string} callback.response.error_msg - 결제 실패 시 에러 메시지
 */
function requestPayment(options, callback) {
    if (!window.IMP) {
        alert("아임포트 라이브러리가 로드되지 않았습니다.");
        return;
    }
    var IMP = window.IMP;
    IMP.init(options.impCode);

    console.log("impCode:", options.impCode);

    IMP.request_pay({
        pg: options.pg || 'html5_inicis',
        pay_method: options.pay_method || 'card',
        merchant_uid: options.merchant_uid || ('merchant_' + new Date().getTime()),
        name: options.name || '상품명',
        amount: options.amount || 0,
        buyer_email: options.buyer_email || '',
        buyer_name: options.buyer_name || '',
        buyer_tel: options.buyer_tel || '',
        // 필요시 추가 옵션
    }, callback);
}

/**
 * contextPath를 가져오는 함수
 */
function getContextPath() {
    // 현재 페이지의 contextPath를 가져옴
    return window.location.pathname.substring(0, window.location.pathname.indexOf("/", 1)) || "";
}

/**
 * 결제 취소/환불 처리
 * @param {string} impUid - 아임포트 결제 고유번호
 * @param {number} cancelAmount - 취소 금액 (null이면 전액 취소)
 * @param {string} cancelReason - 취소 사유
 */
function cancelPayment(impUid, cancelAmount, cancelReason) {
    if (!confirm('정말로 결제를 취소하시겠습니까?')) {
        return;
    }

    const requestData = {
        imp_uid: impUid,
        cancel_amount: cancelAmount,
        cancel_reason: cancelReason || '고객 요청'
    };

    $.ajax({
        url: getContextPath() + '/payments/charge/cancel',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(requestData),
        success: function(response) {
            if (response.success) {
                alert('결제가 성공적으로 취소되었습니다.');
                // 페이지 새로고침 또는 내역 업데이트
                location.reload();
            } else {
                alert('결제 취소 실패: ' + response.message);
            }
        },
        error: function(xhr, status, error) {
            alert('결제 취소 처리 중 오류가 발생했습니다: ' + error);
        }
    });
}

/**
 * 결제 취소 가능 여부 확인
 * @param {string} impUid - 아임포트 결제 고유번호
 * @param {function} callback - 확인 후 실행할 콜백 함수
 */
function checkCancelable(impUid, callback) {
    $.ajax({
        url: getContextPath() + '/payments/charge/cancel/check/' + impUid,
        type: 'GET',
        success: function(response) {
            if (response.success) {
                if (response.can_cancel) {
                    if (callback) {
                        callback(response.charge_info, response.cancelable_amount);
                    }
                } else {
                    alert('이미 취소되었거나 취소할 수 없는 결제입니다.');
                }
            } else {
                alert('취소 가능 여부 확인 실패: ' + response.message);
            }
        },
        error: function(xhr, status, error) {
            alert('취소 가능 여부 확인 중 오류가 발생했습니다: ' + error);
        }
    });
}

/**
 * 부분 환불 처리
 * @param {string} impUid - 아임포트 결제 고유번호
 * @param {number} maxAmount - 최대 환불 가능 금액
 */
function partialRefund(impUid, maxAmount) {
    const refundAmount = prompt('환불할 금액을 입력하세요 (최대: ' + maxAmount + '원)');
    
    if (refundAmount === null) {
        return; // 취소
    }
    
    const amount = parseInt(refundAmount);
    if (isNaN(amount) || amount <= 0) {
        alert('올바른 금액을 입력해주세요.');
        return;
    }
    
    if (amount > maxAmount) {
        alert('환불 가능 금액을 초과했습니다.');
        return;
    }
    
    const reason = prompt('환불 사유를 입력하세요');
    if (reason === null) {
        return; // 취소
    }
    
    cancelPayment(impUid, amount, reason);
}

/**
 * 전액 취소 처리
 * @param {string} impUid - 아임포트 결제 고유번호
 */
function fullRefund(impUid) {
    const reason = prompt('취소 사유를 입력하세요');
    if (reason === null) {
        return; // 취소
    }
    
    cancelPayment(impUid, null, reason); // null은 전액 취소를 의미
} 