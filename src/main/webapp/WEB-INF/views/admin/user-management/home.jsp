<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <title>관리 &gt; 사용자</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #28a745;
            /* Bootstrap Success 녹색 계열 */
            --secondary-color: #f0fdf4;
            /* 아주 연한 녹색 배경 */
            --accent-color: #1e7e34;
            /* 진한 녹색 포인트 */
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

        .chart-card,
        .user-card {
            background: var(--card-bg);
            border-radius: 1.25rem;
            box-shadow: 0 8px 32px rgba(40, 167, 69, 0.08);
        }

        .chart-card {
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .user-card {
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .filter-btns .btn {
            border-radius: .5rem;
            font-weight: 600;
        }

        .status-active {
            color: #198754;
            font-weight: 600;
        }

        .status-inactive {
            color: #dc3545;
            font-weight: 600;
        }

        .user-avatar {
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

        .login-label {
            display: inline-block;
            padding: 0.25em 0.9em;
            border-radius: 1em;
            font-size: 0.95em;
            font-weight: 600;
            letter-spacing: 0.02em;
        }

        .login-label-kakao {
            background: #fee500;
            color: #3c1e1e;
            border: 1px solid #e5c200;
        }

        .login-label-native {
            background: #e3f0ff;
            color: #1976d2;
            border: 1px solid #90caf9;
        }

        .login-label-web {
            background: #dee2e6;
            color: #495057;
            border: 1px solid #adb5bd;
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

        .badge-kakao {
            background: #fee500;
            color: #3c1e1e;
            font-weight: 600;
        }

        .badge-app {
            background: var(--primary-color);
            color: #fff;
            font-weight: 600;
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

        .table-responsive, .page-selector {
            font-size: 12px;
            margin-bottom: 1rem;
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
        <a href="<c:url value="/admin/home/user-management"/>" class="nav-link active">사용자</a>
        <a href="<c:url value="/admin/home/owner-management"/>" class="nav-link">점주</a>
        <a href="<c:url value="/admin/home/payment-management"/>" class="nav-link">결제</a>
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
                <li class="breadcrumb-item active" aria-current="page">사용자</li>
            </ol>
        </nav>

        <!-- 가입자 추이 -->
        <div class="d-flex align-items-center mb-3">
            <h2 class="me-auto text-success">📈 가입자 추이</h2>
            <div class="btn-group filter-btns" role="group">
                <button type="button" name="연간" class="btn btn-outline-success active">연간</button>
                <button type="button" name="월간" class="btn btn-outline-success">월간</button>
                <button type="button" name="일간" class="btn btn-outline-success">일간</button>
            </div>
        </div>
        <div class="chart-card">
            <p class="text-muted fst-italic mb-3">연간 가입자 수 변화</p>
            <!-- 기존 <img> 대신 -->
            <canvas id="signupChart" width="800" height="250"></canvas>
        </div>

        <!-- 사용자 리스트 -->
        <!-- 사용자 리스트 -->
        <h2 class="mb-3 text-success">🎭 사용자 관리</h2>
        <div class="user-card">
            <form id="searchForm" class="search-bar">
                <input type="text" name="query" class="form-control" placeholder="검색">
                <button type="submit" class="btn btn-success">검색</button>
            </form>

            <!-- 여기에 페이지 사이즈 선택 추가 -->
            <div class="page-selector">
                <select class="form-select" style="width: 120px; display: inline-block; font-size: 12px;">
                    <option value="10">10개씩 보기</option>
                    <option value="20">20개씩 보기</option>
                    <option value="50">50개씩 보기</option>
                </select>
            </div>

            <div class="table-responsive">
                <table class="table align-middle table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>id</th>
                        <th>프로필</th>
                        <th>이름</th>
                        <th>닉네임</th>
                        <th>로그인 타입</th>
                        <th>이메일</th>
                        <th>부서</th>
                        <th>나이</th>
                        <th>성별</th>
                        <th>상태</th>
                    </tr>
                    </thead>
                    <tbody id="userListBody">
                    <c:forEach var="user" items="${userList.itemList}">
                        <tr>
                            <td>${user.usersId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty user.usersProfile}">
                                        <img src="${user.usersProfile}" class="user-avatar"
                                             alt="https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="user-avatar"
                                             style="background:#e9ecef;display:flex;align-items:center;justify-content:center;">
                                            <svg width="24" height="24" fill="#adb5bd" viewBox="0 0 24 24">
                                                <circle cx="12" cy="8" r="4"/>
                                                <path d="M12 14c-4.418 0-8 1.79-8 4v2h16v-2c0-2.21-3.582-4-8-4z"/>
                                            </svg>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${user.usersName}</td>
                            <td>${user.usersNickname}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${empty user.usersLoginType}">
                                        <span class="login-label login-label-web">X</span>
                                    </c:when>
                                    <c:when test="${user.usersLoginType eq 'kakao'}">
                                        <span class="login-label login-label-kakao">카카오</span>
                                    </c:when>
                                    <c:when test="${user.usersLoginType eq 'native'}">
                                        <span class="login-label login-label-native">네이티브</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="login-label login-label-web">${user.usersLoginType}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${user.usersEmail}</td>
                            <td>${user.departmentName}</td>
                            <td>${user.usersBirth}</td>
                            <td>${user.usersGender}</td>
                            <td>
                                <div class="page-selector">
                                    <select class="status_selector" style="width: 100px;">
                                        <option value="${user.usersStatus}">활성</option>
                                        <option value="비활성">비활성</option>
                                        <option value="정지">정지</option>
                                    </select>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- 페이지 네비게이션 -->
            <div id="custom-nav">
                <nav aria-label="Page navigation example">
                    <ul class="pagination">
                        <li class="previous disabled">
                            <a class="page-link" tabindex="-1" aria-disabled="true">Previous</a>
                        </li>
                        <li class="page-item active "><a class="page-link">1</a></li>
                        <c:forEach begin="${userList.firstPage + 1}" end="${userList.lastPage}" var="page">
                            <li class="page-item"><a class="page-link">${page}</a></li>
                        </c:forEach>
                        <li class="next">
                            <a class="page-link">Next</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script
        src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
        crossorigin="anonymous"></script>
<!-- 3. JSP에서 서버 데이터 받아와서 차트 그리기 -->
<script>
    const ctx = "${pageContext.request.contextPath}";
    let currentPage = 1;
    let firstPage = 1;
    let lastPage = 10;
    let signupChart = null;  // 전역 변수로 선언

    function renderUserRows(userList) {
        const userListBody = $('#userListBody');
        userListBody.empty();

        if (!userList || userList.length === 0) {
            userListBody.append('<tr><td colspan="10" class="text-center">검색 결과가 없습니다.</td></tr>');
            return;
        }

        userList.forEach(user => {
            const profileHtml = user.usersProfile
                ? '<img src="' + user.usersProfile +'" class="user-avatar" alt="프로필">'
                : `<div class="user-avatar" style="background:#e9ecef;display:flex;align-items:center;justify-content:center;">
                       <svg width="24" height="24" fill="#adb5bd" viewBox="0 0 24 24">
                           <circle cx="12" cy="8" r="4"/>
                           <path d="M12 14c-4.418 0-8 1.79-8 4v2h16v-2c0-2.21-3.582-4-8-4z"/>
                       </svg>
                   </div>`;
            let loginTypeHtml = '';
            if (!user.usersLoginType) {
                loginTypeHtml = '<span class="login-label login-label-web">X</span>';
            } else if (user.usersLoginType === 'kakao') {
                loginTypeHtml = '<span class="login-label login-label-kakao">카카오</span>';
            } else if (user.usersLoginType === 'native') {
                loginTypeHtml = '<span class="login-label login-label-native">네이티브</span>';
            } else {
                loginTypeHtml = `<span class.login-label login-label-web">${user.usersLoginType}</span>`;
            }

            const $row = $('<tr>');
            $row.append($('<td>').text(user.usersId || ''));
            $row.append($('<td>').html(profileHtml));
            $row.append($('<td>').text(user.usersName || ''));
            $row.append($('<td>').text(user.usersNickname || ''));
            $row.append($('<td>').html(loginTypeHtml));
            $row.append($('<td>').text(user.usersEmail || ''));
            $row.append($('<td>').text(user.departmentName || ''));
            $row.append($('<td>').text(user.usersBirth || ''));
            $row.append($('<td>').text(user.usersGender || ''));
            $row.append($('<td>').text(user.usersStatus || ''));
            userListBody.append($row);
        });
    }

    function renderPagination(firstPage, lastPage, currentPage) {
        $('.pagination .page-item').not('.previous, .next').remove();
        for (let i = firstPage; i <= lastPage; i++) {
            const $li = $('<li>').addClass('page-item');
            if (i === currentPage) {
                $li.addClass('active').attr('aria-current', 'page');
            }
            const $a = $('<a>').addClass('page-link').text(i);
            $li.append($a);
            $('.pagination .next').before($li);
        }
    }

    function searchUsers(query, page, size) {
        $.ajax({
            url: ctx + '/admin/home/user-management/search',
            type: 'GET',
            data: {query, currentPage: page, pageSize: size},
            success: function (response) {
                renderUserRows(response.itemList);
                if (response.lastPage * size < response.totalCount) {
                    $('.pagination .next').removeClass('disabled');
                } else {
                    $('.pagination .next').addClass('disabled');
                }

                if (response.firstPage === 1) {
                    $('.pagination .previous').addClass('disabled');
                } else {
                    $('.pagination .previous').removeClass('disabled');
                }
                lastPage = response.lastPage;
                firstPage = response.firstPage;
                renderPagination(firstPage, lastPage, page);
            },
            error: function () {
                alert('검색 중 오류가 발생했습니다.');
            }
        });
    }

    // 3) 페이지네이션 UI 업데이트
    function updatePaginationUI($clicked) {
        $clicked.parent()
            .siblings()
            .removeClass('active')
            .removeAttr('aria-current')
            .end()
            .addClass('active')
            .attr('aria-current', 'page');
    }

    $(document).ready(function () {
        $('.filter-btns button').on('click', function () {
            // 모든 버튼에서 active 클래스 제거
            $('.filter-btns button').removeClass('active');
            // 클릭된 버튼에 active 클래스 추가
            $(this).addClass('active');
            const date = $(this).attr('name');

            $.ajax({
                url: ctx + '/admin/home/user-management/chart',
                type: 'GET',
                data: {date: date},
                success: function (response) {
                    const dateList = response.map(item => item.createdAt);
                    const countList = response.map(item => item.userCount);
                    const canvas = document.getElementById('signupChart');
                    const chartCtx = canvas.getContext('2d');
                    const label = $('.btn.btn-outline-success.active').attr('name') + ' 가입자 수 변화';
                    $('.text-muted').text(label + ' 가입자 수 변화');

                    if (signupChart !== null) {
                        signupChart.destroy();
                    }

                    const chartData = {
                        labels: dateList,
                        datasets: [{
                            label: '가입자 수',
                            data: countList,
                            fill: true,
                            borderWidth: 2,
                            tension: 0.3,
                            borderColor: 'rgba(40, 167, 69, 0.8)',
                            backgroundColor: 'rgba(40, 167, 69, 0.2)'
                        }]
                    };

                    signupChart = new Chart(chartCtx, {
                        type: 'line',
                        data: chartData,
                        options: {
                            responsive: true,
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    ticks: {
                                        stepSize: Math.ceil(Math.max(...countList) / 5)
                                    }
                                }
                            },
                            plugins: {
                                legend: {
                                    display: false
                                },
                                tooltip: {
                                    padding: 10,
                                    displayColors: false,
                                    callbacks: {
                                        title: () => '',
                                        label: function (context) {
                                            return context.raw + '명';
                                        }
                                    }
                                }
                            }
                        }
                    });
                }
            });
        });

        $('.filter-btns button[name="연간"]').click();

        const $pageSize = $('.form-select');
        const $pagination = $('.pagination');

        // 검색 폼 제출
        $('#searchForm').on('submit', function (e) {
            e.preventDefault();
            currentPage = 1;
            const query = $(this).find('input[name="query"]').val();
            searchUsers(query, currentPage, $pageSize.val());
        });

        // 페이지 번호 클릭
        $pagination.on('click', '.page-item:not(.previous):not(.next) .page-link', function (e) {
            e.preventDefault();
            const query = $('#searchForm').find('input[name="query"]').val();
            currentPage = parseInt($(this).text(), 10);
            updatePaginationUI($(this));
            searchUsers(query, currentPage, $pageSize.val());
        });

        // Previous 클릭
        $pagination.on('click', '.previous .page-link', function (e) {
            e.preventDefault();
            const query = $('#searchForm').find('input[name="query"]').val();
            searchUsers(query, firstPage - $pageSize.val(), $pageSize.val());
        });

        // Next 클릭
        $pagination.on('click', '.next .page-link', function (e) {
            e.preventDefault();
            const query = $('#searchForm').find('input[name="query"]').val();
            searchUsers(query, lastPage + 1, $pageSize.val());
        });

        // 페이지 크기 변경
        $pageSize.on('change', function () {
            currentPage = 1;
            $('#searchForm').submit();
        });

    });

</script>
</body>

</html>
