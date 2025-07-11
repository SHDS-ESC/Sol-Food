<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>관리 &gt; 결제 상세 정보</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/payment-management.css">
    <style>
        .payment-id-badge {
            background: #e3f2fd;
            color: #1976d2;
            padding: 0.375rem 0.75rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .status-badge {
            padding: 0.375rem 0.75rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            font-weight: 600;
        }

        .status-pending {
            background: #fff3cd;
            color: #856404;
        }

        .detail-item {
            margin-bottom: 1rem;
            padding: 0.75rem;
            background: #f8f9fa;
            border-radius: 0.5rem;
        }

        .detail-label {
            font-weight: 600;
            color: #495057;
            font-size: 0.875rem;
            display: block;
            margin-bottom: 0.25rem;
        }

        .detail-value {
            font-size: 1rem;
            color: #212529;
            word-break: break-all;
        }

        .amount-text {
            font-size: 1.125rem;
            font-weight: 600;
            color: #28a745;
        }

        .point-text {
            font-size: 1.125rem;
            font-weight: 600;
            color: #fd7e14;
        }

        .payment-method-badge {
            background: #d4edda;
            color: #155724;
            padding: 0.25rem 0.75rem;
            border-radius: 0.375rem;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .login-type-badge {
            background: #cce5ff;
            color: #0056b3;
            padding: 0.25rem 0.75rem;
            border-radius: 0.375rem;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .user-profile-section {
            text-align: center;
            padding: 1rem;
        }

        .profile-image {
            margin-bottom: 1rem;
        }

        .profile-img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #e9ecef;
        }

        .profile-placeholder {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, #28a745, #20c997);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            color: white;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .user-basic-info h5 {
            margin: 0.5rem 0 0.25rem 0;
            color: #212529;
        }

        .user-basic-info p {
            margin: 0;
            font-size: 0.875rem;
        }

        .receipt-section {
            padding: 1rem;
            background: #f8f9fa;
            border-radius: 0.5rem;
        }

        .receipt-link {
            margin-top: 0.5rem;
        }

        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            margin-top: 2rem;
            padding: 1rem;
        }

        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #212529;
            margin-bottom: 1.5rem;
        }

        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
            }

            .user-profile-section {
                margin-bottom: 1rem;
            }
        }
    </style>
</head>

<body>
<div class="d-flex">
    <!-- Sidebar -->
    <nav class="side-menu">
        <h4>🌿 관리자 메뉴</h4>
        <a href="<c:url value="/admin/home"/>" class="nav-link">홈</a>
        <a href="<c:url value="/admin/user-management"/>" class="nav-link">사용자</a>
        <a href="<c:url value="/admin/owner-management"/>" class="nav-link">점주</a>
        <a href="<c:url value="/admin/payment-management"/>" class="nav-link active">결제</a>
        <a href="#" class="nav-link">정책</a>
        <div class="mt-auto">
            <small class="text-muted">© 2025 YourCompany</small>
        </div>
    </nav>

    <!-- Main content -->
    <div class="main flex-grow-1">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-3">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="<c:url value="/admin/payment-management"/>">결제 관리</a></li>
                <li class="breadcrumb-item active" aria-current="page">결제 상세 정보</li>
            </ol>
        </nav>

        <!-- 아코디언으로 결제 정보 반복 -->
        <div class="accordion" id="paymentAccordion">
            <c:forEach var="detail" items="${paymentDetail.list}" varStatus="status">
                <div class="accordion-item">
                    <h2 class="accordion-header" id="heading${status.index}">
                        <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${status.index}" aria-expanded="false" aria-controls="collapse${status.index}">
                            <span class="me-2">💳</span> <b>${detail.usersName}</b> <span class="text-muted">/ 결제ID: ${detail.paymentId}</span>
                        </button>
                    </h2>
                    <div id="collapse${status.index}" class="accordion-collapse collapse" aria-labelledby="heading${status.index}" data-bs-parent="#paymentAccordion">
                        <div class="accordion-body">
                            <div class="row g-4">
                                <!-- 결제 정보 -->
                                <div class="col-md-6">
                                    <div class="card h-100 shadow-sm">
                                        <div class="card-header bg-success text-white"><b>결제 정보</b></div>
                                        <div class="card-body">
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item"><b>결제ID:</b> ${detail.paymentId}</li>
                                                <li class="list-group-item"><b>통합 결제 ID:</b> ${detail.integratedpaymentId}</li>
                                                <li class="list-group-item"><b>결제 금액:</b> <span class="text-success fw-bold">${detail.paymentAmount}원</span></li>
                                                <li class="list-group-item"><b>실제 결제 금액:</b> <span class="text-success fw-bold">${detail.paymentPaidAmount}원</span></li>
                                                <li class="list-group-item"><b>사용 포인트:</b> <span class="text-warning fw-bold">${detail.paymentUsedPoint}P</span></li>
                                                <li class="list-group-item"><b>결제 수단:</b> <span class="badge bg-info text-dark">${detail.paymentMethod}</span></li>
                                                <li class="list-group-item"><b>결제 상태:</b> <span class="badge bg-${detail.paymentStatus eq 'paid' ? 'success' : (detail.paymentStatus eq 'cancelled' ? 'danger' : 'secondary')}">${detail.paymentStatus}</span></li>
                                                <li class="list-group-item"><b>결제 생성일:</b> ${detail.paymentCreatedAt}</li>
                                                <li class="list-group-item"><b>결제 승인일:</b> ${detail.paymentPaidAt}</li>
                                                <li class="list-group-item"><b>결제 취소일:</b> ${detail.paymentCancelledAt}</li>
                                                <li class="list-group-item"><b>최종 수정일:</b> ${detail.paymentUpdatedAt}</li>
                                                <li class="list-group-item"><b>영수증:</b> <c:if test="${not empty detail.paymentReceiptUrl}"><a href="${detail.paymentReceiptUrl}" target="_blank" class="btn btn-outline-primary btn-sm">영수증 보기</a></c:if></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                                <!-- 결제자 정보 -->
                                <div class="col-md-6">
                                    <div class="card h-100 shadow-sm">
                                        <div class="card-header bg-primary text-white"><b>결제자 정보</b></div>
                                        <div class="card-body">
                                            <ul class="list-group list-group-flush">
                                                <li class="list-group-item"><b>이름:</b> ${detail.paymentBuyerName}</li>
                                                <li class="list-group-item"><b>이메일:</b> ${detail.paymentBuyerEmail}</li>
                                                <li class="list-group-item"><b>전화번호:</b> ${detail.paymentBuyerTel}</li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <hr class="my-4"/>
                            <!-- 사용자 정보 -->
                            <div class="row g-4">
                                <div class="col-md-12">
                                    <div class="card shadow-sm">
                                        <div class="card-header bg-secondary text-white"><b>사용자 정보</b></div>
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-md-2 text-center">
                                                    <c:choose>
                                                        <c:when test="${not empty detail.usersProfile}">
                                                            <img src="${detail.usersProfile}" alt="프로필 이미지" class="rounded-circle border" style="width:80px;height:80px;object-fit:cover;">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="rounded-circle bg-success text-white d-flex align-items-center justify-content-center" style="width:80px;height:80px;font-size:2rem;">${detail.usersName.substring(0, 1)}</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="col-md-10">
                                                    <ul class="list-group list-group-flush">
                                                        <li class="list-group-item"><b>이름:</b> ${detail.usersName}</li>
                                                        <li class="list-group-item"><b>이메일:</b> ${detail.usersEmail}</li>
                                                        <li class="list-group-item"><b>전화번호:</b> ${detail.usersTel}</li>
                                                        <li class="list-group-item"><b>성별:</b> ${detail.usersGender}</li>
                                                        <li class="list-group-item"><b>보유 포인트:</b> <span class="text-warning fw-bold">${detail.usersPoint}</span></li>
                                                        <li class="list-group-item"><b>로그인 타입:</b> <span class="badge bg-info text-dark">${detail.usersLoginType}</span></li>
                                                        <li class="list-group-item"><b>계정 상태:</b> <span class="badge bg-${detail.usersStatus eq 'active' ? 'success' : 'danger'}">${detail.usersStatus}</span></li>
                                                        <c:if test="${not empty detail.usersRejectedReason}">
                                                            <li class="list-group-item"><b>거부 사유:</b> <span class="text-danger">${detail.usersRejectedReason}</span></li>
                                                        </c:if>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
<!-- Bootstrap JS (body 맨 아래에 추가) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
    window.APP_CTX = "${pageContext.request.contextPath}";

    function cancelPayment(paymentId) {
        if (confirm('정말로 이 결제를 취소하시겠습니까?')) {
            // 결제 취소 로직 구현
            $.ajax({
                url: window.APP_CTX + '/admin/payment/cancel',
                method: 'POST',
                data: { paymentId: paymentId },
                success: function(response) {
                    alert('결제가 취소되었습니다.');
                    location.reload();
                },
                error: function() {
                    alert('결제 취소에 실패했습니다.');
                }
            });
        }
    }
</script>
</body>
</html>