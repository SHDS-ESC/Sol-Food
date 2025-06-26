<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/common/payment-header.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>충전 내역</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 30px;
        }
        
        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            border-bottom: 2px solid #007bff;
            padding-bottom: 10px;
        }
        
        .history-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .history-table th,
        .history-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .history-table th {
            background-color: #007bff;
            color: white;
            font-weight: bold;
        }
        
        .history-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .amount {
            font-weight: bold;
            color: #28a745;
        }
        
        .status {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .status.success {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status.pending {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status.failed {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        .status.cancelled {
            background-color: #e2e3e5;
            color: #383d41;
        }
        
        .no-data {
            text-align: center;
            padding: 40px;
            color: #666;
            font-style: italic;
        }
        
        .back-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #6c757d;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        
        .back-btn:hover {
            background-color: #5a6268;
        }
        
        .pagination {
            text-align: center;
            margin-top: 20px;
        }
        
        .pagination a {
            display: inline-block;
            padding: 8px 12px;
            margin: 0 4px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        
        .pagination a:hover {
            background-color: #0056b3;
        }
        
        .pagination .current {
            background-color: #6c757d;
        }
        
        .loading {
            text-align: center;
            padding: 40px;
            color: #666;
        }
        
        .cancel-btn {
            padding: 4px 8px;
            background-color: #dc3545;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .cancel-btn:hover {
            background-color: #c82333;
        }
        
        .cancel-btn:disabled {
            background-color: #6c757d;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>충전 내역</h1>
        
        <div id="loading" class="loading">
            <p>충전 내역을 불러오는 중...</p>
        </div>
        
        <div id="history-content" style="display: none;">
            <table class="history-table">
                <thead>
                    <tr>
                        <th>충전일시</th>
                        <th>충전금액</th>
                        <th>결제수단</th>
                        <th>상태</th>
                        <th>주문번호</th>
                        <th>관리</th>
                    </tr>
                </thead>
                <tbody id="history-tbody">
                </tbody>
            </table>
            
            <div id="pagination" class="pagination">
            </div>
        </div>
        
        <div id="no-data" class="no-data" style="display: none;">
            <p>충전 내역이 없습니다.</p>
        </div>
        
        <a href="${pageContext.request.contextPath}/user/mypage" class="back-btn">마이페이지로 돌아가기</a>
    </div>

    <script>
        $(document).ready(function() {
            let currentPage = 1;
            const pageSize = 10;
            loadChargeHistory(currentPage);

            function loadChargeHistory(page) {
                $('#loading').show();
                $('#history-content').hide();
                $('#no-data').hide();
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/payments/charge/history',
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
                            alert('충전 내역 조회 실패: ' + response.message);
                            $('#no-data').show();
                        }
                    },
                    error: function(xhr, status, error) {
                        $('#loading').hide();
                        alert('충전 내역 조회 중 오류가 발생했습니다: ' + error);
                        $('#no-data').show();
                    }
                });
            }
            
            function displayHistory(history) {
                const tbody = $('#history-tbody');
                tbody.empty();
                
                history.forEach(function(charge) {
                    const row = $('<tr>');
                    
                    // 충전일시
                    const createdAt = new Date(charge.createdAt).toLocaleString('ko-KR');
                    row.append($('<td>').text(createdAt));
                    
                    // 충전금액
                    const amount = charge.amount.toLocaleString() + '원';
                    row.append($('<td class="amount">').text(amount));
                    
                    // 결제수단
                    row.append($('<td>').text(charge.payMethod || '-'));
                    
                    // 상태
                    const statusText = getStatusText(charge.status);
                    const statusClass = getStatusClass(charge.status);
                    row.append($('<td>').html('<span class="status ' + statusClass + '">' + statusText + '</span>'));
                    
                    // 주문번호
                    row.append($('<td>').text(charge.merchantUid));
                    
                    // 관리 (취소 버튼)
                    const cancelBtn = $('<button class="cancel-btn">').text('취소');
                    
                    // cancelledAt이 1970-01-01인 경우 null로 처리
                    const isCancelled = charge.cancelledAt && new Date(charge.cancelledAt).getTime() > 0;
                    
                    if (charge.status === 'paid' && !isCancelled) {
                        cancelBtn.click(function() {
                            // payment.js의 함수 사용
                            if (typeof checkCancelable === 'function') {
                                checkCancelable(charge.impUid, function(chargeInfo, cancelableAmount) {
                                    if (confirm('이 충전을 취소하시겠습니까?')) {
                                        fullRefund(charge.impUid);
                                    }
                                });
                            } else {
                                alert('결제 취소 기능을 사용할 수 없습니다.');
                            }
                        });
                    } else {
                        cancelBtn.prop('disabled', true).text('취소불가');
                    }
                    row.append($('<td>').append(cancelBtn));
                    
                    tbody.append(row);
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
                    url: '${pageContext.request.contextPath}/payments/charge/cancel',
                    type: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify(requestData),
                    success: function(response) {
                        if (response.success) {
                            alert('결제가 성공적으로 취소되었습니다.');
                            loadChargeHistory(currentPage); // 페이지 새로고침 대신 내역 다시 로드
                        } else {
                            alert('결제 취소 실패: ' + response.message);
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('결제 취소 처리 중 오류가 발생했습니다: ' + error);
                    }
                });
            };
        });
    </script>
</body>
</html> 