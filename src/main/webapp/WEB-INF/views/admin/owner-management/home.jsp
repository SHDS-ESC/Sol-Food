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
            font-size: 12px;
        }

        .table tbody tr {
            font-size: 12px;
        }

        .table-hover tbody tr:hover {
            background: #f0fdf4;
        }

        .owner-avatar {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid var(--accent-color);
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: #adb5bd;
            box-shadow: 0 2px 8px rgba(40, 167, 69, 0.10);
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
                        <th>프로필</th>
                        <th>상호명</th>
                        <th>이메일</th>
                        <th>카테고리</th>
                        <th>별점</th>
                        <th>점주 전화번호</th>
                        <th>지점 전화번호</th>
                        <th>주소</th>
                        <th>지점 소개</th>
                        <th>상태</th>
                    </tr>
                    </thead>
                    <tbody id="ownerListBody">
                    <c:forEach var="owner" items="${ownerList}">
                        <tr>
                            <td>${owner.ownerId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty owner.storeMainImage}">
                                        <img src="${owner.storeMainImage}" class="owner-avatar" alt="https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="owner-avatar"
                                             style="background:#e9ecef;display:flex;align-items:center;justify-content:center;">
                                            <svg width="24" height="24" fill="#adb5bd" viewBox="0 0 24 24">
                                                <circle cx="12" cy="8" r="4"/>
                                                <path d="M12 14c-4.418 0-8 1.79-8 4v2h16v-2c0-2.21-3.582-4-8-4z"/>
                                            </svg>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${owner.storeName}</td>
                            <td>${owner.ownerEmail}</td>
                            <td>${owner.storeCategory}</td>
                            <td>${owner.storeAvgStar}</td>
                            <td>${owner.ownerTel}</td>
                            <td>${owner.storeTel}</td>
                            <td>${owner.storeAddress}</td>
                            <td>${owner.storeIntro}</td>
                            <td>${owner.ownerStatus}</td>
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
                url: ctx + '/admin/home/owner-management/search',
                type: 'GET',
                data: { query: query },
                success: function(ownerList) {
                    const ownerListBody = $('#ownerListBody');
                    ownerListBody.empty();
                    if (!ownerList || ownerList.length === 0) {
                        ownerListBody.append('<tr><td colspan="10" class="text-center">검색 결과가 없습니다.</td></tr>');
                        return;
                    }
                    ownerList.forEach(function(owner) {
                        const profileHtml = owner.storeMainImage
                            ? `<img src="${owner.storeMainImage}" class="user-avatar" alt="프로필">`
                            : `<div class="user-avatar" style="background:#e9ecef;display:flex;align-items:center;justify-content:center;">
                                   <svg width="24" height="24" fill="#adb5bd" viewBox="0 0 24 24">
                                       <circle cx="12" cy="8" r="4"/>
                                       <path d="M12 14c-4.418 0-8 1.79-8 4v2h16v-2c0-2.21-3.582-4-8-4z"/>
                                   </svg>
                               </div>`;

                        const $row = $('<tr>');
                        $row.append($('<td>').text(owner.ownerId || ''));
                        $row.append($('<td>').html(profileHtml));
                        $row.append($('<td>').text(owner.storeName || ''));
                        $row.append($('<td>').text(owner.ownerEmail || ''));
                        $row.append($('<td>').text(owner.storeCategory || ''));
                        $row.append($('<td>').text(owner.storeAvgStar || ''));
                        $row.append($('<td>').text(owner.ownerTel || ''));
                        $row.append($('<td>').text(owner.storeTel || ''));
                        $row.append($('<td>').text(owner.storeAddress || ''));
                        $row.append($('<td>').text(owner.storeIntro || ''));
                        $row.append($('<td>').text(owner.ownerStatus || ''));


                        ownerListBody.append($row);
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