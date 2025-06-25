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
    <style>
        :root {
            --primary-color: #28a745;
            --secondary-color: #f0fdf4;
            --accent-color: #1e7e34;
            --sidebar-bg: #ffffff;
            --card-bg: #ffffff;
            --text-color: #343a40;
        }

        * {
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--secondary-color);
            color: var(--text-color);
        }

        .side-menu {
            width: 240px;
            height: 100vh;
            background: var(--sidebar-bg);
            border-right: 1px solid #dee2e6;
            position: fixed;
            top: 0;
            left: 0;
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
        }

        .side-menu h4 {
            color: var(--primary-color);
            margin-bottom: 2rem;
            font-weight: 700;
        }

        .side-menu .nav-link {
            font-weight: 500;
            color: var(--text-color);
            margin-bottom: 1rem;
            border-radius: .375rem;
            padding: .5rem 1rem;
            transition: background .2s, color .2s;
        }

        .side-menu .nav-link.active,
        .side-menu .nav-link:hover {
            background: var(--primary-color);
            color: #fff;
        }

        .main {
            margin-left: 260px;
            padding: 2rem;
            min-height: 100vh;
        }

        .store-card {
            background: var(--card-bg);
            border-radius: 1.25rem;
            box-shadow: 0 8px 32px rgba(40, 167, 69, 0.08);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .search-bar {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }

        .search-bar input,
        .search-bar select {
            font-size: 12px;
        }

        .search-bar button {
            min-width: 100px;
        }

        .page-selector {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: .375rem;
            padding: .5rem;
            margin-bottom: 1rem;
        }

        .table thead th {
            background: #e6f4ea;
            color: #198754;
            font-weight: 700;
            border-bottom: 2px solid #b7e4c7;
            font-size: 12px;
            text-align: center;
        }

        .table tbody tr {
            font-size: 12px;
        }

        .table-hover tbody tr:hover {
            background: #f0fdf4;
        }

        .status-active {
            color: #198754;
            font-weight: 600;
            background: #d1fae5;
            padding: .25rem .75rem;
            border-radius: .5rem;
            font-size: .875rem;
        }

        .status-inactive {
            color: #dc3545;
            font-weight: 600;
            background: #fee2e2;
            padding: .25rem .75rem;
            border-radius: .5rem;
            font-size: .875rem;
        }

        #custom-nav {
            display: flex;
            justify-content: center;
            margin-top: 1rem;
        }
    </style>
</head>

<body>
<div class="d-flex">
    <!-- Sidebar -->
    <nav class="side-menu">
        <h4>🌿 관리자 메뉴</h4>
      <a href="<c:url value="/admin/home"/>" class="nav-link">홈</a>
      <a href="<c:url value="/admin/home/user-management"/>" class="nav-link">사용자</a>
      <a href="<c:url value="/admin/home/owner-management"/>" class="nav-link">점주</a>
      <a href="<c:url value="/admin/home/payment-management"/>" class="nav-link active">결제</a>
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
                <input type="date" name="paymentDate" class="form-control"/>
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
                <button type="submit" class="btn btn-success">검색</button>
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
                        <th>승인 번호</th>
                        <th>결제 번호</th>
                        <th>결제 타입</th>
                        <th>결제 일시</th>
                        <th>결제 금액</th>
                        <th>상태</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="p" items="${paymentList.itemList}">
                        <tr>
                            <td>${p.userName}</td>
                            <td>${p.shopName}</td>
                            <td>${p.orderNo}</td>
                            <td>${p.approveNo}</td>
                            <td>${p.paymentNo}</td>
                            <td>${p.paymentType}</td>
                            <td>${p.paymentDate}</td>
                            <td>${p.amount}</td>
                            <td>
                                    <span class="${p.status == '승인' ? 'status-active' : 'status-inactive'}">
                                            ${p.status}
                                    </span>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty paymentList.itemList}">
                        <tr>
                            <td colspan="9" class="text-center">검색 결과가 없습니다.</td>
                        </tr>
                    </c:if>
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
                                <li class="page-item ${i == paymentList.currentPage ? 'active' : ''}">
                                    <a class="page-link">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item next ${paymentList.lastPage * paymentList.pageSize >= paymentList.totalCount ? 'disabled' : ''}">
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
                <button type="submit" class="btn btn-success">검색</button>
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
                    <c:forEach var="r" items="${reservationList.itemList}">
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
                    <c:if test="${empty reservationList.itemList}">
                        <tr>
                            <td colspan="8" class="text-center">검색 결과가 없습니다.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>

                <!-- 페이지 네비게이션 -->
                <div id="custom-nav">
                    <nav aria-label="Page navigation">
                        <ul class="pagination">
                            <li class="page-item previous ${reservationList.firstPage == 1 ? 'disabled' : ''}">
                                <a class="page-link">Previous</a>
                            </li>
                            <c:forEach begin="${reservationList.firstPage}" end="${reservationList.lastPage}" var="i">
                                <li class="page-item ${i == reservationList.currentPage ? 'active' : ''}">
                                    <a class="page-link">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item next ${reservationList.lastPage * reservationList.pageSize >= reservationList.totalCount ? 'disabled' : ''}">
                                <a class="page-link">Next</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>

    </div>
</div>

<!-- Bootstrap JS + jQuery -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- (필요하다면 AJAX 스크립트도 owner-management 페이지와 유사하게 추가) -->
</body>
</html>
