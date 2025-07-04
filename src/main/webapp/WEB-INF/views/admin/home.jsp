<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>관리자 대시보드</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
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
            background: var(--secondary-color);
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
        }

        .chart-card, .user-card, .store-card {
            background: var(--card-bg);
            border-radius: 1.25rem;
            box-shadow: 0 8px 32px rgba(40, 167, 69, 0.08);
            padding: 2rem;
        }

        .search-bar {
            display: flex;
            gap: .5rem;
            margin-bottom: 1.5rem;
        }

        .search-bar input, .search-bar select {
            font-size: 12px;
        }

        .search-bar button {
            min-width: 100px;
        }

        .avatar {
            width: 40px;
            height: 40px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid var(--accent-color);
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .status-active {
            color: #198754;
            background: #d1fae5;
            padding: .25rem .75rem;
            border-radius: .5rem;
        }

        .status-inactive {
            color: #dc3545;
            background: #fee2e2;
            padding: .25rem .75rem;
            border-radius: .5rem;
        }

        .status-pending {
            color: #f59e0b;
            background: #fef3c7;
            padding: .25rem .75rem;
            border-radius: .5rem;
        }

        .page-selector {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: .375rem;
            padding: .5rem;
            margin-bottom: 1rem;
        }

        .pagination .page-item.disabled .page-link {
            pointer-events: none;
            opacity: .5;
        }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- 사이드 메뉴 -->
    <nav class="side-menu">
        <h4>🌿 관리자 메뉴</h4>
        <a href="<c:url value='/admin/home'/>" class="nav-link active">홈</a>
        <a href="<c:url value='/admin/user-management'/>" class="nav-link">사용자</a>
        <a href="<c:url value='/admin/owner-management'/>" class="nav-link">점주</a>
        <a href="<c:url value='/admin/payment-management'/>" class="nav-link">결제</a>
        <a href="#" class="nav-link">정책</a>
        <div class="mt-auto"><small class="text-muted">© 2025 YourCompany</small></div>
    </nav>

    <!-- 메인 콘텐츠 -->
    <div class="main flex-grow-1">
        <!-- 일간 가입자 추이 -->
        <div class="mb-5">
            <div>
                <h2 class="text-success">📈 방문자 추이</h2>
            </div>
            <div style="display: flex; justify-content: space-between;">
                <div class="btn-group filter-btns mb-3" role="group">
                    <button type="button" name="연간" class="btn btn-outline-success active">연간</button>
                    <button type="button" name="월간" class="btn btn-outline-success">월간</button>
                    <button type="button" name="일간" class="btn btn-outline-success">일간</button>
                </div>
                <div style="display:flex; flex-direction:row; align-items:center;">
                    <span class="total_people_count"></span>
                </div>
            </div>
            <div class="chart-card">
                <canvas id="signupChart" width="800" height="250"></canvas>
            </div>
        </div>
    </div>
</div>


<!-- JS 로드 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = "${pageContext.request.contextPath}";

    // 1) 가입자 차트
    let signupChart = null;
    $('.filter-btns button').click(function () {
        $('.filter-btns button').removeClass('active');
        $(this).addClass('active');
        const period = $(this).attr('name');
        $.getJSON(ctx + '/admin/daily-users', {date: period}, data => {
            const labels = data.map(d => d.date);
            const counts = data.map(d => d.daily);
            $('.total_people_count').text('누적 방문자 수 : ' + data.at(-1).cumulative + ' 명')
            const c = document.getElementById('signupChart').getContext('2d');
            if (signupChart) signupChart.destroy();
            signupChart = new Chart(c, {
                type: 'line',
                data: {labels, datasets: [{label: '방문자 수', data: counts, fill: true, tension: 0.3}]},
                options: {responsive: true, plugins: {legend: {display: false}}, scales:{y:{beginAtZero: true }}}
            });
        });
    });
    $('.filter-btns button[name="연간"]').click();
</script>
</body>
</html>
