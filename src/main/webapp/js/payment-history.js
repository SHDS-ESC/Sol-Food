/**
 * 결제 내역 JavaScript
 * common-utils.js 활용
 */

let currentPage = 1;
const pageSize = 10;

document.addEventListener('DOMContentLoaded', function() {
    loadPaymentHistory(currentPage);
    
    // URL 파라미터에서 리뷰 작성 완료 플래그 확인
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.get('reviewCompleted') === 'true') {
        // 리뷰 작성 완료 후 돌아온 경우, 즉시 내역 새로고침
        loadPaymentHistory(currentPage);
        
        // 성공 메시지 표시
        SolFoodUtils.showToast('리뷰가 성공적으로 작성되었습니다!', 'success');
        
        // URL에서 파라미터 제거 (브라우저 히스토리 정리)
        const newUrl = window.location.pathname;
        window.history.replaceState({}, document.title, newUrl);
    }
});

function loadPaymentHistory(page) {
    $('#loading').show();
    $('#history-content').hide();
    $('#no-data').hide();
    
    $.ajax({
        url: UrlConstants.Builder.fullUrl('/payments/payment/history'),
        type: 'GET',
        data: {
            page: page,
            size: pageSize
        },
        success: function(response) {
            $('#loading').hide();
            
            if (response.success) {
                const history = response.data;
                
                if (history && history.length > 0) {
                    displayHistory(history);
                    $('#history-content').show();
                } else {
                    $('#no-data').show();
                }
            } else {
                SolFoodUtils.showToast('결제 내역 조회 실패: ' + response.message, 'error');
                $('#no-data').show();
            }
        },
        error: function(xhr, status, error) {
            $('#loading').hide();
            SolFoodUtils.showToast('결제 내역 조회 중 오류가 발생했습니다: ' + error, 'error');
            $('#no-data').show();
        }
    });
}

function displayHistory(history) {
    const list = $('#history-list');
    list.empty();
    history.forEach(function(charge) {
        const card = $('<div class="history-card"></div>');
        // 결제일시
        card.append('<div class="history-row"><span class="history-label">결제일시</span><span class="history-value">' + new Date(charge.createdAt).toLocaleString('ko-KR') + '</span></div>');
        // 금액
        card.append('<div class="history-row"><span class="history-label">금액</span><span class="history-value amount">' + charge.amount.toLocaleString() + '원</span></div>');
        // 결제수단
        card.append('<div class="history-row"><span class="history-label">수단</span><span class="history-value">' + (charge.payMethod || '-') + '</span></div>');
        // 상태
        const statusText = getStatusText(charge.status);
        const statusClass = getStatusClass(charge.status);
        card.append('<div class="history-row"><span class="history-label">상태</span><span class="history-value status ' + statusClass + '">' + statusText + '</span></div>');
        // 주문번호
        card.append('<div class="history-row"><span class="history-label">주문번호</span><span class="history-value">' + charge.merchantUid + '</span></div>');
        // 관리(취소, 리뷰 버튼)
        const actions = $('<div class="history-actions"></div>');
        const cancelBtn = $('<button class="cancel-btn">').text('취소');
        const isCancelled = charge.cancelledAt && new Date(charge.cancelledAt).getTime() > 0;
        if (charge.status === 'paid' && !isCancelled) {
            cancelBtn.click(function() {
                if (typeof checkCancelable === 'function') {
                    checkCancelable(charge.impUid, function(chargeInfo, cancelableAmount) {
                        if (confirm('이 결제를 취소하시겠습니까?')) {
                            fullRefund(charge.impUid);
                        }
                    });
                } else {
                    SolFoodUtils.showToast('결제 취소 기능을 사용할 수 없습니다.', 'error');
                }
            });
        } else {
            cancelBtn.prop('disabled', true).text('취소불가');
        }
        actions.append(cancelBtn);
        // 리뷰 작성 버튼
        const reviewBtn = $('<button class="review-btn">').text('리뷰작성');
        
        // 결제 완료 상태이고 리뷰를 작성하지 않은 경우에만 리뷰 작성 가능
        if (charge.status === 'paid' && !charge.hasReview) {
            reviewBtn.click(function() {
                // 통합결제ID로 가게ID 조회 후 리뷰 작성 페이지로 이동
                if (charge.integratedpaymentId) {
                    getStoreIdAndRedirect(charge.integratedpaymentId, charge.paymentId);
                } else {
                    SolFoodUtils.showToast('결제 정보에 가게 정보가 없습니다.', 'error');
                }
            });
        } else if (charge.hasReview) {
            // 이미 리뷰를 작성한 경우
            reviewBtn.text('리뷰 완료').prop('disabled', true).addClass('review-completed');
        } else if (charge.status !== 'paid') {
            // 결제가 완료되지 않은 경우
            reviewBtn.text('결제 완료 후 가능').prop('disabled', true).addClass('review-disabled');
        }
        
        actions.append(reviewBtn);
        
        // 가게 상세 페이지 버튼 (결제 완료된 경우에만)
        if (charge.status === 'paid' && charge.integratedpaymentId) {
            const storeBtn = $('<button class="store-btn">').text('가게 보기');
            storeBtn.click(function() {
                // 통합결제ID로 가게ID 조회 후 가게 상세 페이지로 이동
                getStoreIdAndGoToStore(charge.integratedpaymentId);
            });
            actions.append(storeBtn);
        }
        card.append(actions);
        list.append(card);
    });
}

function getStatusText(status) {
    switch(status) {
        case 'paid': return '성공';
        case 'pending': return '진행중';
        case 'failed': return '실패';
        case 'cancelled': return '취소됨';
        default: return status;
    }
}

function getStatusClass(status) {
    switch(status) {
        case 'paid': return 'success';
        case 'pending': return 'pending';
        case 'failed': return 'failed';
        case 'cancelled': return 'cancelled';
        default: return 'pending';
    }
}



// 통합결제ID로 가게ID 조회 후 리뷰 작성 페이지로 이동
function getStoreIdAndRedirect(integratedPaymentId, paymentId) {
    $.ajax({
        url: UrlConstants.Builder.fullUrl('/payments/payment/storeId'),
        type: 'GET',
        data: {
            integratedPaymentId: integratedPaymentId
        },
        success: function(response) {
            if (response.success && response.data) {
                // 가게ID와 paymentId로 리뷰 작성 페이지로 이동
                window.location.href = UrlConstants.Builder.fullUrl('/user/review/write?storeId=' + response.data + '&paymentId=' + paymentId);
            } else {
                SolFoodUtils.showToast('가게 정보를 찾을 수 없습니다.', 'error');
            }
        },
        error: function(xhr, status, error) {
            SolFoodUtils.showToast('가게 정보 조회 중 오류가 발생했습니다: ' + error, 'error');
        }
    });
}

// 통합결제ID로 가게ID 조회 후 가게 상세 페이지로 이동
function getStoreIdAndGoToStore(integratedPaymentId) {
    $.ajax({
        url: UrlConstants.Builder.fullUrl('/payments/payment/storeId'),
        type: 'GET',
        data: {
            integratedPaymentId: integratedPaymentId
        },
        success: function(response) {
            if (response.success && response.data) {
                // 가게ID로 가게 상세 페이지로 이동
                window.location.href = UrlConstants.Builder.fullUrl('/user/store/detail?storeId=' + response.data);
            } else {
                SolFoodUtils.showToast('가게 정보를 찾을 수 없습니다.', 'error');
            }
        },
        error: function(xhr, status, error) {
            SolFoodUtils.showToast('가게 정보 조회 중 오류가 발생했습니다: ' + error, 'error');
        }
    });
}

// payment.js의 cancelPayment 함수를 오버라이드하여 페이지 새로고침 대신 내역 다시 로드
const originalCancelPayment = window.cancelPayment;
window.cancelPayment = function(impUid, cancelAmount, cancelReason) {
    if (!confirm('정말로 결제를 취소하시겠습니까?')) {
        return;
    }

    const requestData = {
        imp_uid: impUid,
        cancel_amount: cancelAmount,
        cancel_reason: cancelReason || '고객 요청'
    };

    $.ajax({
        url: UrlConstants.Builder.fullUrl('/payments/payment/cancel'),
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(requestData),
        success: function(response) {
            if (response.success) {
                SolFoodUtils.showToast('결제가 성공적으로 취소되었습니다.', 'success');
                loadPaymentHistory(currentPage); // 페이지 새로고침 대신 내역 다시 로드
            } else {
                SolFoodUtils.showToast('결제 취소 실패: ' + response.message, 'error');
            }
        },
        error: function(xhr, status, error) {
            SolFoodUtils.showToast('결제 취소 처리 중 오류가 발생했습니다: ' + error, 'error');
        }
    });
}; 