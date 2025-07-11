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
 * @param {string} [options.role='leader'] - 사용자 역할 (leader 또는 participant)
 * @param {number} [options.paymentId] - Payment ID (participant 역할에서 사용)
 * @param {Function} callback - 결제 완료 후 실행될 콜백 함수
 * @param {Object} callback.response - 결제 응답 객체
 * @param {string} callback.response.imp_uid - 아임포트 결제 고유번호
 * @param {string} callback.response.merchant_uid - 가맹점 주문번호
 * @param {string} callback.response.success - 결제 성공 여부
 * @param {string} callback.response.error_msg - 결제 실패 시 에러 메시지
 */
function requestPayment(options, callback) {
    if (!window.IMP) {
        showPaymentErrorAlert("라이브러리 오류", "아임포트 라이브러리가 로드되지 않았습니다.");
        return;
    }
    var IMP = window.IMP;
    IMP.init(options.impCode);

    console.log("impCode:", options.impCode);
    console.log("Payment options:", options);

    // 결제 완료 후 처리 함수
    function handlePaymentResponse(response) {
        console.log("결제 응답:", response);
        
        if (response.success) {
            // 결제 성공 시 서버 검증
            // verifyPayment에 콜백 전달
            options.callback = callback;
            verifyPayment(response, options);
        } else {
            // 결제 실패
            showPaymentErrorAlert("결제 실패", response.error_msg || "결제 처리 중 오류가 발생했습니다.");
            
            // 원본 콜백이 있다면 실행
            if (callback) {
                callback(response);
            }
        }
    }

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
    }, handlePaymentResponse);
}

/**
 * 결제 검증 및 서버 처리
 * @param {Object} response - 아임포트 결제 응답
 * @param {Object} options - 원본 결제 옵션
 */
function verifyPayment(response, options) {
    const verifyData = {
        imp_uid: response.imp_uid,
        amount: response.paid_amount,
        merchant_uid: response.merchant_uid
    };
    
    // 역할에 따라 다른 API 호출
    let apiUrl;
    if (options.role === 'participant' && options.paymentId) {
        // 참여자: Payment ID로 검증
        apiUrl = getContextPath() + `/payments/payment/verify/${options.paymentId}`;
    } else {
        // 발의자: 사용자 세션으로 검증
        apiUrl = getContextPath() + '/payments/payment/leader-payment/verify';
    }
    
    console.log("결제 검증 API 호출:", apiUrl);
    
    $.ajax({
        url: apiUrl,
        type: 'POST',
        data: verifyData,
        success: function(verifyResponse) {
            console.log("결제 검증 응답:", verifyResponse);
            
            // 서버 응답이 성공인 경우
            if (verifyResponse && (verifyResponse.success || verifyResponse.result === 'success')) {
                console.log("✅ 결제 검증 성공");
                
                // 원본 콜백이 있다면 성공 응답 전달
                if (options.callback) {
                    options.callback({
                        success: true,
                        imp_uid: response.imp_uid,
                        merchant_uid: response.merchant_uid,
                        paid_amount: response.paid_amount,
                        verifyResponse: verifyResponse
                    });
                }
            } else {
                console.log("❌ 결제 검증 실패");
                showPaymentErrorAlert("결제 검증 실패", verifyResponse.message || verifyResponse.error_msg || "결제 검증 중 오류가 발생했습니다.");
                
                // 원본 콜백이 있다면 실패 응답 전달
                if (options.callback) {
                    options.callback({
                        success: false,
                        error_msg: verifyResponse.message || verifyResponse.error_msg || "결제 검증 실패"
                    });
                }
            }
        },
        error: function(xhr, status, error) {
            console.error("결제 검증 오류:", error);
            console.error("응답 텍스트:", xhr.responseText);
            
            showPaymentErrorAlert("결제 검증 실패", "서버와의 통신 중 오류가 발생했습니다.");
            
            // 원본 콜백이 있다면 실패 응답 전달
            if (options.callback) {
                options.callback({
                    success: false,
                    error_msg: "서버와의 통신 중 오류가 발생했습니다."
                });
            }
        }
    });
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
 * @param {string} paymentType - 결제 타입 ("charge" 또는 "payment")
 */
function cancelPayment(impUid, cancelAmount, cancelReason, paymentType) {
    if (!confirm('정말로 결제를 취소하시겠습니까?')) {
        return;
    }

    const requestData = {
        imp_uid: impUid,
        cancel_amount: cancelAmount,
        cancel_reason: cancelReason || '고객 요청',
        payment_type: paymentType // "charge" 또는 "payment"
    };

    $.ajax({
        url: getContextPath() + '/payments/common/cancel',
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(requestData),
        success: function(response) {
            if (response.success) {
                showPaymentSuccessAlert('취소 완료', '결제가 성공적으로 취소되었습니다.');
                // 페이지 새로고침 또는 내역 업데이트
                location.reload();
            } else {
                showPaymentErrorAlert('취소 실패', '결제 취소 실패: ' + response.message);
            }
        },
        error: function(xhr, status, error) {
            showPaymentErrorAlert('오류', '결제 취소 처리 중 오류가 발생했습니다: ' + error);
        }
    });
}

/**
 * 결제 취소 가능 여부 확인
 * @param {string} impUid - 아임포트 결제 고유번호
 * @param {function} callback - 확인 후 실행할 콜백 함수
 * @param {string} paymentType - 결제 타입 ("charge" 또는 "payment")
 */
function checkCancelable(impUid, callback, paymentType) {
    const url = getContextPath() + '/payments/common/cancel/check/' + impUid;
    const params = paymentType ? { payment_type: paymentType } : {};
    
    $.ajax({
        url: url,
        type: 'GET',
        data: params,
        success: function(response) {
            if (response.success) {
                if (response.can_cancel) {
                    if (callback) {
                        callback(response.payment_info, response.cancelable_amount);
                    }
                } else {
                    showPaymentErrorAlert('취소 불가', '이미 취소되었거나 취소할 수 없는 결제입니다.');
                }
            } else {
                showPaymentErrorAlert('확인 실패', '취소 가능 여부 확인 실패: ' + response.message);
            }
        },
        error: function(xhr, status, error) {
            showPaymentErrorAlert('오류', '취소 가능 여부 확인 중 오류가 발생했습니다: ' + error);
        }
    });
}

/**
 * 부분 환불 처리
 * @param {string} impUid - 아임포트 결제 고유번호
 * @param {number} maxAmount - 최대 환불 가능 금액
 * @param {string} paymentType - 결제 타입 ("charge" 또는 "payment")
 */
function partialRefund(impUid, maxAmount, paymentType) {
    const refundAmount = prompt('환불할 금액을 입력하세요 (최대: ' + maxAmount + '원)');
    
    if (refundAmount === null) {
        return; // 취소
    }
    
    const amount = parseInt(refundAmount);
    if (isNaN(amount) || amount <= 0) {
        if (typeof showWarningPopup === 'function') {
            showWarningPopup('올바른 금액을 입력해주세요.');
        } else {
            alert('올바른 금액을 입력해주세요.');
        }
        return;
    }
    
    if (amount > maxAmount) {
        if (typeof showWarningPopup === 'function') {
            showWarningPopup('환불 가능 금액을 초과했습니다.');
        } else {
            alert('환불 가능 금액을 초과했습니다.');
        }
        return;
    }
    
    const reason = prompt('환불 사유를 입력하세요');
    if (reason === null) {
        return; // 취소
    }
    
    cancelPayment(impUid, amount, reason, paymentType);
}

/**
 * 전액 취소 처리
 * @param {string} impUid - 아임포트 결제 고유번호
 * @param {string} paymentType - 결제 타입 ("charge" 또는 "payment")
 */
function fullRefund(impUid, paymentType) {
    const reason = prompt('취소 사유를 입력하세요');
    if (reason === null) {
        return; // 취소
    }
    
    cancelPayment(impUid, null, reason, paymentType); // null은 전액 취소를 의미
}

/**
 * SweetAlert2를 사용한 결제 완료 알림
 * @param {string} title - 알림 제목
 * @param {string} text - 알림 내용
 * @param {string} nextPath - 이동할 경로 (null이면 이동하지 않음)
 * @returns {Promise} 알림이 닫힐 때 resolve되는 Promise
 */
function showPaymentSuccessAlert(title, text, nextPath) {
    if (typeof Swal !== 'undefined') {
        return Swal.fire({
            title: title || "결제가 완료되었습니다!",
            text: text || "결제 완료 페이지로 이동합니다.",
            icon: "success",
            confirmButtonText: "확인"
            // timer 제거 - 자동 페이지 이동 방지
        }).then(function() {
            if (nextPath) {
                window.location.replace(nextPath);
            }
        });
    } else if (typeof showSuccessPopup === 'function') {
        showSuccessPopup(title || "결제가 완료되었습니다!");
        if (nextPath) {
            window.location.replace(nextPath);
        }
        // Promise를 반환하도록 수정
        return Promise.resolve();
    } else {
        // fallback: 기본 alert 사용
        alert(title || "결제가 완료되었습니다!");
        if (nextPath) {
            window.location.replace(nextPath);
        }
        return Promise.resolve();
    }
}

/**
 * SweetAlert2를 사용한 결제 실패 알림
 * @param {string} title - 알림 제목
 * @param {string} text - 알림 내용
 */
function showPaymentErrorAlert(title, text) {
    if (typeof Swal !== 'undefined') {
        Swal.fire({
            title: title || "결제 실패",
            text: text || "결제 처리 중 오류가 발생했습니다.",
            icon: "error",
            confirmButtonText: "확인"
        });
    } else if (typeof showErrorPopup === 'function') {
        showErrorPopup(title || "결제 실패: " + (text || "결제 처리 중 오류가 발생했습니다."));
    } else {
        // fallback: 기본 alert 사용
        alert((title || "결제 실패") + ": " + (text || "결제 처리 중 오류가 발생했습니다."));
    }
} 