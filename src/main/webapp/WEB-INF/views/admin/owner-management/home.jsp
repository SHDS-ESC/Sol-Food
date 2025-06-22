<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>관리 &gt; 점주</title>
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

        .search-bar input {
            flex: 1;
        }

        .search-bar button {
            min-width: 100px;
        }

        .table {
            text-align: center;
        }

        .table thead th {
            background: #e6f4ea;
            color: #198754;
            font-weight: 700;
            border-bottom: 2px solid #b7e4c7;
        }

        .table-hover tbody tr:hover {
            background: #f0fdf4;
        }

        .status-active {
            color: #198754;
            font-weight: 600;
            background: #d1fae5;
            padding: 0.25rem 0.75rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
        }

        .status-inactive {
            color: #dc3545;
            font-weight: 600;
            background: #fee2e2;
            padding: 0.25rem 0.75rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
        }

        .status-pending {
            color: #f59e0b;
            font-weight: 600;
            background: #fef3c7;
            padding: 0.25rem 0.75rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
        }

        .page-selector {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 0.375rem;
            padding: 0.5rem;
            margin-bottom: 1rem;
        }

        .btn-detail {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 0.25rem 0.75rem;
            border-radius: 0.375rem;
            font-size: 0.875rem;
            transition: background 0.2s;
        }

        .btn-detail:hover {
            background: var(--accent-color);
            color: white;
        }

        .amount-text {
            font-weight: 600;
            color: var(--accent-color);
        }
    </style>
</head>

<body>
<div class="d-flex">
    <!-- Sidebar -->
    <nav class="side-menu">
        <h4>🌿 관리자 메뉴</h4>
        <a href= "${pageContext.request.contextPath}/admin/home"  class="nav-link">홈</a>
        <a href= "${pageContext.request.contextPath}/admin/home/user-management" class="nav-link">사용자</a>
        <a href= "${pageContext.request.contextPath}/admin/home/owner-management" class="nav-link active">점주</a>
        <a href="#" class="nav-link">결제</a>
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
                <li class="breadcrumb-item active" aria-current="page">점주</li>
            </ol>
        </nav>

        <!-- 점주 관리 -->
        <h2 class="mb-3 text-success">🏪 점주 관리</h2>
        <div class="store-card">
            <form id="searchForm" class="search-bar">
                <input type="text" name="query" class="form-control" placeholder="검색어">
                <button type="submit" class="btn btn-success">검색</button>
            </form>

            <div class="page-selector">
                <select class="form-select" style="width: 120px; display: inline-block;">
                    <option value="10">10개씩 보기</option>
                    <option value="20">20개씩 보기</option>
                    <option value="50">50개씩 보기</option>
                </select>
            </div>

            <div class="table-responsive">
                <table class="table align-middle table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>점주 번호</th>
                        <th>상호명</th>
                        <th>계약일</th>
                        <th>주소</th>
                        <th>별점</th>
                        <th>소개</th>
                        <th>카테고리</th>
                        <th>상태</th>
                        <th>승인 여부</th>
                    </tr>
                    </thead>
                    <tbody id="storeListBody">
                    <!-- 샘플 데이터 -->
                    <tr>
                        <td>1</td>
                        <td>아담우동집</td>
                        <td>2024-05-16</td>
                        <td>서울 마포구 와우산로 94</td>
                        <td>승인 대기중</td>
                        <td class="amount-text">50,000,000 원</td>
                        <td>554</td>
                        <td>아직</td>
                        <td>
                            <button class="btn-detail">자세히 ▼</button>
                        </td>
                    </tr>
                    <tr>
                        <td>2</td>
                        <td>맛있는 피자집</td>
                        <td>2024-03-10 14:30:00</td>
                        <td>2025-03-10 14:30:00</td>
                        <td>2024-03-11 09:15:00</td>
                        <td class="amount-text">75,500,000 원</td>
                        <td>823</td>
                        <td>5%</td>
                        <td>
                            <span class="status-active">승인</span>
                        </td>
                    </tr>
                    <tr>
                        <td>3</td>
                        <td>행복한 치킨</td>
                        <td>2024-01-20 16:00:00</td>
                        <td>2025-01-20 16:00:00</td>
                        <td>2024-01-21 10:30:00</td>
                        <td class="amount-text">92,300,000 원</td>
                        <td>1,247</td>
                        <td>4.5%</td>
                        <td>
                            <span class="status-active">승인</span>
                        </td>
                    </tr>
                    <tr>
                        <td>4</td>
                        <td>신선한 초밥집</td>
                        <td>2024-06-01 11:00:00</td>
                        <td>-</td>
                        <td>-</td>
                        <td class="amount-text">0 원</td>
                        <td>0</td>
                        <td>미정</td>
                        <td>
                            <span class="status-pending">승인 대기중</span>
                        </td>
                    </tr>
                    <tr>
                        <td>5</td>
                        <td>감성 카페</td>
                        <td>2023-11-15 13:45:00</td>
                        <td>2024-11-15 13:45:00</td>
                        <td>2023-11-16 08:20:00</td>
                        <td class="amount-text">45,800,000 원</td>
                        <td>672</td>
                        <td>6%</td>
                        <td>
                            <span class="status-inactive">만료</span>
                        </td>
                    </tr>
                    <!-- JSTL 루프 (실제 데이터용) -->
                    <c:forEach var="store" items="${storeList}">
                        <tr>
                            <td>${store.storeId}</td>
                            <td>${store.storeName}</td>
                            <td>${store.contractStartDate}</td>
                            <td>${store.contractEndDate}</td>
                            <td>${store.approvalDate}</td>
                            <td class="amount-text">${store.totalSales} 원</td>
                            <td>${store.visitCount}</td>
                            <td>${store.commissionRate}%</td>
                            <td>
                                <c:choose>
                                    <c:when test="${store.approvalStatus eq '승인'}">
                                        <span class="status-active">승인</span>
                                    </c:when>
                                    <c:when test="${store.approvalStatus eq '승인 대기중'}">
                                        <span class="status-pending">승인 대기중</span>
                                    </c:when>
                                    <c:when test="${store.approvalStatus eq '만료'}">
                                        <span class="status-inactive">만료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn-detail">자세히 ▼</button>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>

<script>
    const ctx = "${pageContext.request.contextPath}";

    $(document).ready(function () {
        // AJAX 검색 기능
        $('#searchForm').on('submit', function(e) {
            e.preventDefault();
            const query = $(this).find('input[name="query"]').val();

            $.ajax({
                url: ctx + '/admin/home/store-management/search',
                type: 'GET',
                data: { query: query },
                success: function(storeList) {
                    console.log('storeList:', storeList);
                    const storeListBody = $('#storeListBody');
                    storeListBody.empty();

                    if (!storeList || storeList.length === 0) {
                        storeListBody.append('<tr><td colspan="9" class="text-center">검색 결과가 없습니다.</td></tr>');
                        return;
                    }

                    storeList.forEach(function(store) {
                        let statusHtml = '';
                        if (store.approvalStatus === '승인') {
                            statusHtml = '<span class="status-active">승인</span>';
                        } else if (store.approvalStatus === '승인 대기중') {
                            statusHtml = '<span class="status-pending">승인 대기중</span>';
                        } else if (store.approvalStatus === '만료') {
                            statusHtml = '<span class="status-inactive">만료</span>';
                        } else {
                            statusHtml = '<button class="btn-detail">자세히 ▼</button>';
                        }

                        const $row = $('<tr>');
                        $row.append($('<td>').text(store.storeId || ''));
                        $row.append($('<td>').text(store.storeName || ''));
                        $row.append($('<td>').text(store.contractStartDate || ''));
                        $row.append($('<td>').text(store.contractEndDate || '-'));
                        $row.append($('<td>').text(store.approvalDate || ''));
                        $row.append($('<td>').addClass('amount-text').text((store.totalSales || '0') + ' 원'));
                        $row.append($('<td>').text(store.visitCount || '0'));
                        $row.append($('<td>').text((store.commissionRate || '미정') + (store.commissionRate ? '%' : '')));
                        $row.append($('<td>').html(statusHtml));

                        storeListBody.append($row);
                    });
                },
                error: function() {
                    alert('검색 중 오류가 발생했습니다.');
                }
            });
        });

        // 자세히 버튼 클릭 이벤트
        $(document).on('click', '.btn-detail', function() {
            const $row = $(this).closest('tr');
            const storeId = $row.find('td:first').text();
            // 상세 정보 모달이나 페이지로 이동하는 로직 추가
            console.log('점주 상세 정보:', storeId);
        });

        // 페이지 선택 변경 이벤트
        $('.page-selector select').on('change', function() {
            const pageSize = $(this).val();
            // 페이지 크기 변경 로직 추가
            console.log('페이지 크기 변경:', pageSize);
        });
    });
</script>
</body>

</html>