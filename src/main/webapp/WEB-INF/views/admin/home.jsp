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
        * { font-family: 'Inter', sans-serif; }
        body { background: var(--secondary-color); color: var(--text-color); }
        .side-menu {
            width: 240px; height: 100vh; background: var(--sidebar-bg);
            border-right: 1px solid #dee2e6; position: fixed; top: 0; left: 0;
            padding: 1.5rem; display: flex; flex-direction: column;
        }
        .side-menu h4 { color: var(--primary-color); margin-bottom: 2rem; font-weight: 700; }
        .side-menu .nav-link {
            font-weight: 500; color: var(--text-color); margin-bottom: 1rem;
            border-radius: .375rem; padding: .5rem 1rem;
            transition: background .2s, color .2s;
        }
        .side-menu .nav-link.active,
        .side-menu .nav-link:hover {
            background: var(--primary-color); color: #fff;
        }
        .main { margin-left: 260px; padding: 2rem; }
        .chart-card, .user-card, .store-card { background: var(--card-bg); border-radius: 1.25rem; box-shadow: 0 8px 32px rgba(40,167,69,0.08); padding: 2rem; }
        .search-bar { display: flex; gap: .5rem; margin-bottom: 1.5rem; }
        .search-bar input, .search-bar select { font-size: 12px; }
        .search-bar button { min-width: 100px; }
        .avatar {
            width: 40px; height: 40px; object-fit: cover; border-radius: 50%;
            border: 2px solid var(--accent-color); background: #e9ecef;
            display: flex; align-items:center; justify-content:center;
        }
        .status-active { color:#198754; background:#d1fae5; padding:.25rem .75rem; border-radius:.5rem; }
        .status-inactive { color:#dc3545; background:#fee2e2; padding:.25rem .75rem; border-radius:.5rem; }
        .status-pending { color:#f59e0b; background:#fef3c7; padding:.25rem .75rem; border-radius:.5rem; }
        .page-selector { background:#f8f9fa; border:1px solid #dee2e6; border-radius:.375rem; padding:.5rem; margin-bottom:1rem; }
        .pagination .page-item.disabled .page-link { pointer-events: none; opacity: .5; }
    </style>
</head>
<body>
<div class="d-flex">
    <!-- 사이드 메뉴 -->
    <nav class="side-menu">
        <h4>🌿 관리자 메뉴</h4>
        <a href="<c:url value='/admin/home'/>" class="nav-link active">홈</a>
        <a href="<c:url value='/admin/home/user-management'/>" class="nav-link">사용자</a>
        <a href="<c:url value='/admin/home/owner-management'/>" class="nav-link">점주</a>
        <a href="<c:url value='/admin/home/payment-management'/>" class="nav-link">결제</a>
        <a href="#" class="nav-link">정책</a>
        <div class="mt-auto"><small class="text-muted">© 2025 YourCompany</small></div>
    </nav>

    <!-- 메인 콘텐츠 -->
    <div class="main flex-grow-1">
        <!-- 1. 가입자 추이 -->
        <div class="mb-5">
            <h2 class="text-success">📈 가입자 추이</h2>
            <div class="btn-group filter-btns mb-3" role="group">
                <button type="button" name="연간" class="btn btn-outline-success active">연간</button>
                <button type="button" name="월간" class="btn btn-outline-success">월간</button>
                <button type="button" name="일간" class="btn btn-outline-success">일간</button>
            </div>
            <div class="chart-card">
                <canvas id="signupChart" width="800" height="250"></canvas>
            </div>
        </div>

        <!-- 2. 사용자 관리 -->
        <div class="mb-5">
            <h2 class="text-success">🎭 사용자 관리</h2>
            <div class="user-card">
                <form id="searchUserForm" class="search-bar">
                    <input type="text" name="query" class="form-control" placeholder="검색"/>
                    <button type="submit" class="btn btn-success">검색</button>
                </form>
                <div class="page-selector">
                    <select id="userPageSize" class="form-select form-select-sm" style="width:100px;">
                        <option value="10">10개씩</option>
                        <option value="20">20개씩</option>
                        <option value="50">50개씩</option>
                    </select>
                </div>
                <div class="table-responsive">
                    <table class="table align-middle table-hover">
                        <thead class="table-light">
                        <tr>
                            <th>id</th><th>프로필</th><th>이름</th><th>닉네임</th><th>로그인 타입</th>
                            <th>이메일</th><th>부서</th><th>생년월일</th><th>성별</th><th>상태</th>
                        </tr>
                        </thead>
                        <tbody id="userListBody"></tbody>
                    </table>
                </div>
                <nav>
                    <ul id="userPagination" class="pagination">
                        <li class="page-item previous disabled"><a class="page-link">Prev</a></li>
                        <!-- JS가 삽입 -->
                        <li class="page-item next disabled"><a class="page-link">Next</a></li>
                    </ul>
                </nav>
            </div>
        </div>

        <!-- 3. 점주 관리 -->
        <div class="mb-5">
            <h2 class="text-success">🏪 점주 관리</h2>
            <div class="store-card">
                <form id="searchOwnerForm" class="search-bar">
                    <input type="text" name="query" class="form-control" placeholder="지점명으로 검색"/>
                    <button type="submit" class="btn btn-success">검색</button>
                </form>
                <div class="page-selector">
                    <select id="ownerPageSize" class="form-select form-select-sm" style="width:100px;">
                        <option value="10">10개씩</option>
                        <option value="20">20개씩</option>
                        <option value="50">50개씩</option>
                    </select>
                </div>
                <div class="table-responsive">
                    <table class="table align-middle table-hover">
                        <thead class="table-light">
                        <tr>
                            <th>번호</th><th>프로필</th><th>상호명</th><th>이메일</th><th>카테고리</th>
                            <th>별점</th><th>전화(점주)</th><th>전화(지점)</th><th>주소</th><th>소개</th><th>상태</th>
                        </tr>
                        </thead>
                        <tbody id="ownerListBody"></tbody>
                    </table>
                </div>
                <nav>
                    <ul id="ownerPagination" class="pagination">
                        <li class="page-item previous disabled"><a class="page-link">Prev</a></li>
                        <!-- JS가 삽입 -->
                        <li class="page-item next disabled"><a class="page-link">Next</a></li>
                    </ul>
                </nav>
            </div>
        </div>

        <!-- 4. 결제 내역 관리 -->
        <div class="mb-5">
            <h2 class="text-success">💳 결제 내역 관리</h2>
            <div class="store-card">
                <form id="searchPaymentForm" class="search-bar">
                    <input type="date" name="paymentDate" class="form-control"/>
                    <select name="method" class="form-select">
                        <option value="">수단</option><option>카카오페이</option><option>토스페이</option><option>신용카드</option>
                    </select>
                    <select name="status" class="form-select">
                        <option value="">상태</option><option>승인</option><option>취소</option>
                    </select>
                    <button type="submit" class="btn btn-success">검색</button>
                </form>
                <div class="page-selector">
                    <select id="paymentPageSize" class="form-select form-select-sm" style="width:100px;">
                        <option value="10">10개씩</option><option value="20">20개씩</option><option value="50">50개씩</option>
                    </select>
                </div>
                <div class="table-responsive">
                    <table class="table align-middle table-hover">
                        <thead class="table-light">
                        <tr>
                            <th>사용자명</th><th>가게명</th><th>주문번호</th><th>승인번호</th><th>결제번호</th>
                            <th>타입</th><th>일시</th><th>금액</th><th>상태</th>
                        </tr>
                        </thead>
                        <tbody id="paymentListBody"></tbody>
                    </table>
                </div>
                <nav>
                    <ul id="paymentPagination" class="pagination">
                        <li class="page-item previous disabled"><a class="page-link">Prev</a></li>
                        <!-- JS가 삽입 -->
                        <li class="page-item next disabled"><a class="page-link">Next</a></li>
                    </ul>
                </nav>
            </div>
        </div>

        <!-- 5. 예약 내역 관리 -->
        <div class="mb-5">
            <h2 class="text-success">📅 예약 내역 관리</h2>
            <div class="store-card">
                <form id="searchReservationForm" class="search-bar">
                    <input type="date" name="reserveDate" class="form-control"/>
                    <select name="method" class="form-select">
                        <option value="">수단</option><option>카카오페이</option><option>토스페이</option><option>신용카드</option>
                    </select>
                    <select name="status" class="form-select">
                        <option value="">상태</option><option>승인</option><option>취소</option>
                    </select>
                    <button type="submit" class="btn btn-success">검색</button>
                </form>
                <div class="page-selector">
                    <select id="reservationPageSize" class="form-select form-select-sm" style="width:100px;">
                        <option value="10">10개씩</option><option value="20">20개씩</option><option value="50">50개씩</option>
                    </select>
                </div>
                <div class="table-responsive">
                    <table class="table align-middle table-hover">
                        <thead class="table-light">
                        <tr>
                            <th>사용자명</th><th>가게명</th><th>주문번호</th><th>결제번호</th><th>타입</th><th>일시</th><th>금액</th><th>상태</th>
                        </tr>
                        </thead>
                        <tbody id="reservationListBody"></tbody>
                    </table>
                </div>
                <nav>
                    <ul id="reservationPagination" class="pagination">
                        <li class="page-item previous disabled"><a class="page-link">Prev</a></li>
                        <!-- JS가 삽입 -->
                        <li class="page-item next disabled"><a class="page-link">Next</a></li>
                    </ul>
                </nav>
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
    $('.filter-btns button').click(function() {
        $('.filter-btns button').removeClass('active');
        $(this).addClass('active');
        const period = $(this).attr('name');
        $.getJSON(ctx + '/admin/home/user-management/chart', { date: period }, data => {
            const labels = data.map(d => d.createdAt);
            const counts = data.map(d => d.userCount);
            const c = document.getElementById('signupChart').getContext('2d');
            if (signupChart) signupChart.destroy();
            signupChart = new Chart(c, {
                type: 'line',
                data: { labels, datasets: [{ label:'가입자 수', data:counts, fill:true, tension:0.3 }] },
                options:{ responsive:true, plugins:{legend:{display:false}} }
            });
        });
    });
    $('.filter-btns button[name="연간"]').click();

    // 페이징 공통 유틸
    function buildPagination($ul, currentPage, firstPage, lastPage, onPageClick) {
        $ul.find('li.page-item').not('.previous, .next').remove();
        for (let i = firstPage; i <= lastPage; i++) {
            const $li = $('<li>').addClass('page-item').toggleClass('active', i === currentPage);
            $('<a>').addClass('page-link').text(i).appendTo($li);
            $li.insertBefore($ul.find('.next'));
        }
        $ul.find('.previous').toggleClass('disabled', firstPage === 1);
        $ul.find('.next').toggleClass('disabled', false);
        // 클릭 핸들러
        $ul.find('li.page-item').not('.previous,.next').off('click').on('click', function() {
            const page = +$(this).text();
            onPageClick(page);
        });
        // Prev/Next
        $ul.find('.previous').off('click').on('click', () => {
            if (firstPage > 1) onPageClick(firstPage - 1);
        });
        $ul.find('.next').off('click').on('click', () => {
            onPageClick(lastPage + 1);
        });
    }

    // 2) 사용자 관리
    let uPage=1, uFirst=1, uLast=1;
    function searchUsers(page) {
        uPage = page || 1;
        $.getJSON(ctx + '/admin/home/owner-management/search', {
            query: $('#searchUserForm input[name="query"]').val(),
            currentPage: uPage,
            pageSize: $('#userPageSize').val()
        }, resp => {
            // 렌더
            const $b = $('#userListBody').empty();
            if (!resp.itemList.length) {
                return $b.append('<tr><td colspan="10" class="text-center">검색 결과가 없습니다.</td></tr>');
            }
            resp.itemList.forEach(u => {
                const pic = u.usersProfile
                    ? `<img src="${u.usersProfile}" class="avatar"/>`
                    : `<div class="avatar"><svg width="24" height="24" fill="#adb5bd"><circle cx="12" cy="8" r="4"/><path d="M12 14c-4.418 0-8 1.79-8 4v2h16v-2c0-2.21-3.582-4-8-4z"/></svg></div>`;
                let badge = `<span class="badge bg-secondary">${u.usersLoginType}</span>`;
                if (u.usersLoginType==='kakao') badge='<span class="badge bg-warning text-dark">카카오</span>';
                if (u.usersLoginType==='native') badge='<span class="badge bg-info text-white">네이티브</span>';
                $b.append(`<tr>
          <td>${u.usersId}</td><td>${pic}</td><td>${u.usersName}</td><td>${u.usersNickname}</td><td>${badge}</td>
          <td>${u.usersEmail}</td><td>${u.departmentName}</td><td>${u.usersBirth}</td><td>${u.usersGender}</td><td>${u.usersStatus}</td>
        </tr>`);
            });
            uFirst = resp.firstPage; uLast = resp.lastPage;
            buildPagination($('#userPagination'), uPage, uFirst, uLast, searchUsers);
        });
    }
    $('#searchUserForm').submit(e=>{e.preventDefault(); searchUsers(1);});
    $('#userPageSize').change(()=>searchUsers(1));
    searchUsers(1);

    // 3) 점주 관리
    let oPage=1, oFirst=1, oLast=1;
    function searchOwners(page) {
        oPage = page||1;
        $.getJSON(ctx + '/admin/home/owner-management/search', {
            query: $('#searchOwnerForm input[name="query"]').val(),
            currentPage: oPage,
            pageSize: $('#ownerPageSize').val()
        }, resp => {
            const $b = $('#ownerListBody').empty();
            if (!resp.itemList.length) {
                return $b.append('<tr><td colspan="11" class="text-center">검색 결과가 없습니다.</td></tr>');
            }
            resp.itemList.forEach(o => {
                const pic = o.storeMainImage
                    ? `<img src="${o.storeMainImage}" class="avatar"/>`
                    : `<div class="avatar"><svg width="24" height="24" fill="#adb5bd"><circle cx="12" cy="8" r="4"/><path d="M12 14c-4.418 0-8 1.79-8 4v2h16v-2c0-2.21-3.582-4-8-4z"/></svg></div>`;
                const cls = o.ownerStatus==='활성'?'status-active':o.ownerStatus==='비활성'?'status-inactive':'status-pending';
                $b.append(`<tr>
          <td>${o.ownerId}</td><td>${pic}</td><td>${o.storeName}</td><td>${o.ownerEmail}</td><td>${o.storeCategory}</td>
          <td>${o.storeAvgStar}</td><td>${o.ownerTel}</td><td>${o.storeTel}</td><td>${o.storeAddress}</td><td>${o.storeIntro}</td>
          <td><span class="${cls}">${o.ownerStatus}</span></td>
        </tr>`);
            });
            oFirst = resp.firstPage; oLast = resp.lastPage;
            buildPagination($('#ownerPagination'), oPage, oFirst, oLast, searchOwners);
        });
    }
    $('#searchOwnerForm').submit(e=>{e.preventDefault(); searchOwners(1);});
    $('#ownerPageSize').change(()=>searchOwners(1));
    searchOwners(1);

    // 4) 결제 관리
    let pPage=1, pFirst=1, pLast=1;
    function searchPayments(page) {
        pPage = page||1;
        $.getJSON(ctx + '/admin/home/payment-management/search', {
            paymentDate: $('#searchPaymentForm input[name="paymentDate"]').val(),
            method: $('#searchPaymentForm select[name="method"]').val(),
            status: $('#searchPaymentForm select[name="status"]').val(),
            currentPage: pPage,
            pageSize: $('#paymentPageSize').val()
        }, resp => {
            const $b = $('#paymentListBody').empty();
            if (!resp.itemList.length) {
                return $b.append('<tr><td colspan="9" class="text-center">검색 결과가 없습니다.</td></tr>');
            }
            resp.itemList.forEach(p => {
                const cls = p.status==='승인'?'status-active':'status-inactive';
                $b.append(`<tr>
          <td>${p.userName}</td><td>${p.shopName}</td><td>${p.orderNo}</td><td>${p.approveNo}</td><td>${p.paymentNo}</td>
          <td>${p.paymentType}</td><td>${p.paymentDate}</td><td>${p.amount}</td><td><span class="${cls}">${p.status}</span></td>
        </tr>`);
            });
            pFirst = resp.firstPage; pLast = resp.lastPage;
            buildPagination($('#paymentPagination'), pPage, pFirst, pLast, searchPayments);
        });
    }
    $('#searchPaymentForm').submit(e=>{e.preventDefault(); searchPayments(1);});
    $('#paymentPageSize').change(()=>searchPayments(1));
    searchPayments(1);

    // 5) 예약 관리
    let rPage=1, rFirst=1, rLast=1;
    function searchReservations(page) {
        rPage = page||1;
        $.getJSON(ctx + '/admin/home/payment-management/searchReservation', {
            reserveDate: $('#searchReservationForm input[name="reserveDate"]').val(),
            method: $('#searchReservationForm select[name="method"]').val(),
            status: $('#searchReservationForm select[name="status"]').val(),
            currentPage: rPage,
            pageSize: $('#reservationPageSize').val()
        }, resp => {
            const $b = $('#reservationListBody').empty();
            if (!resp.itemList.length) {
                return $b.append('<tr><td colspan="8" class="text-center">검색 결과가 없습니다.</td></tr>');
            }
            resp.itemList.forEach(r => {
                const cls = r.status==='승인'?'status-active':'status-inactive';
                $b.append(`<tr>
          <td>${r.userName}</td><td>${r.shopName}</td><td>${r.orderNo}</td><td>${r.paymentNo}</td>
          <td>${r.paymentType}</td><td>${r.paymentDate}</td><td>${r.amount}</td><td><span class="${cls}">${r.status}</span></td>
        </tr>`);
            });
            rFirst = resp.firstPage; rLast = resp.lastPage;
            buildPagination($('#reservationPagination'), rPage, rFirst, rLast, searchReservations);
        });
    }
    $('#searchReservationForm').submit(e=>{e.preventDefault(); searchReservations(1);});
    $('#reservationPageSize').change(()=>searchReservations(1));
    searchReservations(1);
</script>
</body>
</html>
