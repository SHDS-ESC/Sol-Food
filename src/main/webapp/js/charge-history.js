/**
 * 충전 내역 JavaScript
 * common-utils.js 활용
 */

let currentPage = 1;
const pageSize = 10;

document.addEventListener('DOMContentLoaded', function() {
    loadChargeHistory(currentPage);
});

function loadChargeHistory(page) {
    $('#loading').show();
    $('#history-content').hide();
    $('#no-data').hide();
    
    $.ajax({
        url: UrlConstants.Builder.fullUrl('/payments/charge/history'),
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
                SolFoodUtils.showToast('충전 내역 조회 실패: ' + response.message, 'error');
                $('#no-data').show();
            }
        },
        error: function(xhr, status, error) {
            $('#loading').hide();
            SolFoodUtils.showToast('충전 내역 조회 중 오류가 발생했습니다: ' + error, 'error');
            $('#no-data').show();
        }
    });
}

function displayHistory(history) {
    const list = $('#history-list');
    list.empty();
    history.forEach(function(charge) {
        const card = $('<div class="history-card"></div>');
        // 일시
        card.append('<div class="history-row"><span class="history-label">충전일시</span><span class="history-value">' + new Date(charge.createdAt).toLocaleString('ko-KR') + '</span></div>');
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
        // 관리(취소 버튼)
        const actions = $('<div class="history-actions"></div>');
        const cancelBtn = $('<button class="cancel-btn">').text('취소');
        const isCancelled = charge.cancelledAt && new Date(charge.cancelledAt).getTime() > 0;
        if (charge.status === 'paid' && !isCancelled) {
            cancelBtn.click(function() {
                if (typeof checkCancelable === 'function') {
                    checkCancelable(charge.impUid, function(chargeInfo, cancelableAmount) {
                        if (confirm('이 충전을 취소하시겠습니까?')) {
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
        url: UrlConstants.Builder.fullUrl('/payments/charge/cancel'),
        type: 'POST',
        contentType: 'application/json',
        data: JSON.stringify(requestData),
        success: function(response) {
            if (response.success) {
                SolFoodUtils.showToast('결제가 성공적으로 취소되었습니다.', 'success');
                loadChargeHistory(currentPage); // 페이지 새로고침 대신 내역 다시 로드
            } else {
                SolFoodUtils.showToast('결제 취소 실패: ' + response.message, 'error');
            }
        },
        error: function(xhr, status, error) {
            SolFoodUtils.showToast('결제 취소 처리 중 오류가 발생했습니다: ' + error, 'error');
        }
    });
}; 