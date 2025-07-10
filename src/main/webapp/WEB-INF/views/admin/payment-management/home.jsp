<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>관리 &gt; 결제</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/payment-management.css">
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
                <li class="breadcrumb-item"><a href="#">관리</a></li>
                <li class="breadcrumb-item active" aria-current="page">결제</li>
            </ol>
        </nav>

        <!-- 결제 내역 관리 -->
        <div class="store-card">
            <h4 class="section-title">👥 결제 내역 관리</h4>
            <form id="searchPaymentForm" class="search-bar">
                <div class="form-row">
                    <input type="datetime-local" name="fromDate" class="form-control" id="fromDate" />
                    <input type="datetime-local" name="toDate" class="form-control" id="toDate" />
                    <select name="paymentMethod" class="form-select">
                        <option value="">결제 수단</option>
                        <option va>카카오페이</option>
                        <option>토스페이</option>
                        <option>신용카드</option>
                    </select>
                    <select name="status" class="form-select form-select-status">
                        <option value="">결제 상태</option>
                        <option value="paid">승인</option>
                        <option value="pending">대기</option>
                        <option value="cancelled">취소</option>
                    </select>
                    <select name="tableType" class="payment-type-select form-select-sm" style="width: 100px;">
                        <option value="charge">충전</option>
                        <option value="payment">결제</option>
                    </select>
                </div>
                <div class="search-input-row">
                    <input type="text" name="query" class="form-control" placeholder="검색">
                    <button type="submit" class="btn btn-success">검색</button>
                </div>
            </form>

            <div class="page-selector">
                <select class="form-select form-select-count" style="width: 100px;">
                    <option value="10">10개씩</option>
                    <option value="20">20개씩</option>
                    <option value="50">50개씩</option>
                </select>

                <select class="payment-type-select form-select-sm" style="width: 100px;">
                    <option value="charge">충전</option>
                    <option value="payment">결제</option>
                </select>
            </div>

            <div class="table-responsive">
                <table class="table align-middle table-hover">
                    <thead>
                    <tr>
                        <th>통합 결제 아이디</th>
                        <th>사용자명</th>
                        <th>금액</th>
                        <th>사용 포인트</th>
                        <th>결제 수단</th>
                        <th>PG사</th>
                        <th>결제 생성일</th>
                        <th>영수증 URL</th>
                        <th>결제 상태</th>
                        <th>자세히 보기</th>
                    </tr>
                    </thead>
                    <tbody id="paymentListBody">
                    </tbody>
                </table>

                <!-- 페이지 네비게이션 -->
                <div id="custom-nav">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <li class="page-item previous ${paymentList.firstPage == 1 ? 'disabled' : ''}">
                                <a class="page-link">Previous</a>
                            </li>
                            <c:forEach begin="${paymentList.firstPage}" end="${paymentList.lastPage}" var="i">
                                <li class="page-item ${i == paymentList.curPage ? 'active' : ''}">
                                    <a class="page-link">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item next ${paymentList.lastPage * paymentList.limit  >= paymentList.count ? 'disabled' : ''}">
                                <a class="page-link">Next</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>

        <!-- 예약 내역 관리 -->
        <div class="store-card">
            <h4 class="section-title">📅 예약 내역 관리</h4>
            <form id="searchReservationForm" class="search-bar">
                <div class="form-row">
                    <input type="date" name="reserveDate" class="form-control"/>
                    <select name="method" class="form-select">
                        <option value="">결제 수단</option>
                        <option>카카오페이</option>
                        <option>토스페이</option>
                        <option>신용카드</option>
                    </select>
                    <select name="status" class="form-select">
                        <option value="">상태</option>
                        <option>승인</option>
                        <option>취소</option>
                    </select>
                    <div style="flex: 1;"></div> <!-- 빈 공간으로 균등분할 유지 -->
                </div>
                <div class="search-input-row">
                    <input type="text" name="query" class="form-control" placeholder="검색">
                    <button type="submit" class="btn btn-success">검색</button>
                </div>
            </form>

            <div class="page-selector">
                <select class="form-select form-select-sm" style="width: 100px;">
                    <option value="10">10개씩</option>
                    <option value="20">20개씩</option>
                    <option value="50">50개씩</option>
                </select>
            </div>

            <div class="table-responsive">
                <table class="table align-middle table-hover">
                    <thead>
                    <tr>
                        <th>사용자명</th>
                        <th>가게명</th>
                        <th>주문 번호</th>
                        <th>결제 번호</th>
                        <th>결제 타입</th>
                        <th>결제 일시</th>
                        <th>결제 금액</th>
                        <th>상태</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="r" items="${reservationList.list}">
                        <tr>
                            <td>${r.userName}</td>
                            <td>${r.shopName}</td>
                            <td>${r.orderNo}</td>
                            <td>${r.paymentNo}</td>
                            <td>${r.paymentType}</td>
                            <td>${r.paymentDate}</td>
                            <td>${r.amount}</td>
                            <td>
                                    <span class="${r.status == '승인' ? 'status-active' : 'status-inactive'}">
                                            ${r.status}
                                    </span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty reservationList.list}">
                        <tr>
                            <td colspan="8" class="text-center">검색 결과가 없습니다.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </div>
</div>

<!-- Bootstrap JS + jQuery -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>window.APP_CTX = "${pageContext.request.contextPath}";</script>
<script src="${pageContext.request.contextPath}/js/admin/payment-management.js"></script>
</body>
</html>
