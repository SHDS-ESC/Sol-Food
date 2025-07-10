ner
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8"/>
    <title>관리자 대시보드</title>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet"/>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
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

        /* 테이블 말줄임 처리 수정 */
        .table {
            table-layout: fixed; /* 테이블 레이아웃 고정 */
        }

        tbody > tr {
            font-size: 12px;
        }

        tr > td {
            height: 50px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 0;
            position: relative;
        }

        th {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            font-size: 12px;
            vertical-align: middle;
            text-align: left;
        }

        #custom-nav {
            display: flex;
            justify-content: center;
            margin-top: 1rem;
        }

        .pagination .page-item.disabled .page-link {
            pointer-events: none;
            opacity: .5;
        }

        .community-card, .review-card {
            background: var(--card-bg);
            border-radius: 1.25rem;
            box-shadow: 0 8px 32px rgba(40, 167, 69, 0.08);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .community-card h5, .review-card h5 {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 1.5rem;
        }

        .community-card table, .review-card table {
            background: #fff;
            border-radius: .75rem;
            overflow: hidden;
        }

        .community-card th, .review-card th {
            background: var(--secondary-color);
            color: var(--primary-color);
            font-weight: 500;
        }

        .community-card td, .review-card td {
            vertical-align: middle;
        }

        .community-card .table, .review-card .table {
            margin-bottom: 0;
        }

        .review-card td .btn-primary {
            font-size: 12px;
            background-color: #dc3545 !important;
            color: #fff !important;
            border: none !important;
            border-radius: 5px !important;
            font-weight: 600 !important;
            padding: 4px 10px;
        }

        .review-card td .btn-primary:hover,
        .modal-footer button.btn-primary {
            border: none;
            background-color: #c82333 !important;
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
            <div style="display: flex">
                <div class="btn-group filter-btns mb-3" role="group">
                    <button type="button" name="연간" class="btn btn-outline-success active">연간</button>
                    <button type="button" name="월간" class="btn btn-outline-success">월간</button>
                    <button type="button" name="일간" class="btn btn-outline-success">일간</button>
                </div>
                <div style="display:flex; flex-direction:row; align-items:center; margin-left:auto;">
                    <span class="total_people_count"></span>
                </div>
            </div>
            <div class="chart-card">
                <canvas id="signupChart" width="800" height="250"></canvas>
            </div>
        </div>
        <!-- 커뮤니티/리뷰 관리 테이블 -->
        <div class="row g-4">
            <div class="col-md-6">
                <div class="community-card h-100">
                    <div class="card-body">
                        <h5 class="card-title mb-3">💬 커뮤니티 관리</h5>
                        <div class="table-responsive">
                            <form id="communitySearchForm" class="search-bar">
                                <input type="text" name="query" class="form-control" placeholder="제목으로 검색">
                                <button type="submit" class="btn btn-success">검색</button>
                            </form>

                            <table class="table table-bordered table-hover align-middle mb-0">
                                <colgroup>
                                    <col style="width: 10%;">
                                    <col style="width: 10%;">
                                    <col style="width: 20%;">
                                    <col style="width: 30%;">
                                    <col style="width: 10%;">
                                    <col style="width: 20%;">
                                    <col style="width: 10%;">
                                </colgroup>
                                <thead class="table-light">
                                <tr>
                                    <th>보드ID</th>
                                    <th>유저ID</th>
                                    <th>유저 닉네임</th>
                                    <th>제목</th>
                                    <th>조회수</th>
                                    <th>날짜</th>
                                    <th>상태</th>
                                </tr>
                                </thead>
                                <tbody id="community-table">
                                <!-- JS로 동적 삽입 -->
                                </tbody>
                            </table>
                        </div>
                        <div id="custom-nav">
                            <nav aria-label="Page navigation example">
                                <div class="c-div">
                                    <ul class="pagination">
                                        <li class="previous disabled">
                                            <a class="page-link" tabindex="-1" aria-disabled="true">Previous</a>
                                        </li>
                                        <li class="page-item active "><a class="page-link">1</a></li>
                                        <li class="next">
                                            <a class="page-link">Next</a>
                                        </li>
                                    </ul>
                                </div>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="review-card h-100">
                    <div class="card-body">
                        <h5 class="card-title mb-3">⭐ 사장님 리뷰 관리</h5>
                        <div class="table-responsive">

                            <form id="reviewSearchForm" class="search-bar">
                                <input type="text" name="query" class="form-control" placeholder="제목으로 검색">
                                <button type="submit" class="btn btn-success">검색</button>
                            </form>

                            <table class="table table-bordered table-hover align-middle mb-0">
                                <colgroup>
                                    <col style="width: 10%;">
                                    <col style="width: 10%;">
                                    <col style="width: 10%;">
                                    <col style="width: 10%;">
                                    <col style="width: 30%;">
                                    <col style="width: 20%;">
                                    <col style="width: 10%;">
                                </colgroup>
                                <thead class="table-light">
                                <tr>
                                    <th>리뷰ID</th>
                                    <th>유저ID</th>
                                    <th>가게ID</th>
                                    <th>별점</th>
                                    <th>내용</th>
                                    <th>작성일</th>
                                    <th>삭제</th>
                                </tr>
                                </thead>
                                <tbody id="review-table">
                                <!-- JS로 동적 삽입 -->
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div id="custom-nav">
                        <nav aria-label="Page navigation example">
                            <div class="r-div">
                                <ul class="pagination">
                                    <li class="previous disabled">
                                        <a class="page-link" tabindex="-1" aria-disabled="true">Previous</a>
                                    </li>
                                    <li class="page-item active "><a class="page-link">1</a></li>
                                    <c:forEach begin="${list.firstPage + 1}" end="${list.lastPage}" var="page">
                                        <li class="page-item"><a class="page-link">${page}</a></li>
                                    </c:forEach>
                                    <li class="next">
                                        <c:choose>
                                            <c:when test="${list.lastPage * list.limit gt list.count}">
                                                <a class="page-link disabled">Next</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a class="page-link">Next</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </li>
                                </ul>
                            </div>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- JS 로드 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- 차트 로딩 스피너 -->
<div id="chart-loading"
     style="position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:9999;background:rgba(255,255,255,0.7);display:flex;align-items:center;justify-content:center;">
    <div class="spinner-border text-success" style="width:4rem;height:4rem;" role="status">
        <span class="visually-hidden">Loading...</span>
    </div>
</div>

<!-- 부트스트랩 삭제 확인 모달 -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">삭제</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                정말로 삭제하시겠습니까?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                <button type="button" class="btn btn-primary">삭제</button>
            </div>
        </div>
    </div>
</div>

<script>
    const ctx = "${pageContext.request.contextPath}";
    // 차트 로딩 스피너 제어
    $(document).ready(function () {
        $('#chart-loading').show();
        $('.filter-btns button[name="연간"]').click();
        searchReview('', 1, 10);
        searchCommunity('', 1, 10);
    });

    // 1) 가입자 차트
    let signupChart = null;
    $('.filter-btns button').click(function () {
        $('#chart-loading').show();
        $('.filter-btns button').removeClass('active');
        $(this).addClass('active');
        const period = $(this).attr('name');
        $.getJSON(ctx + '/admin/daily-users', {date: period}, data => {
            const labels = data.map(d => d.date);
            const counts = data.map(d => d.daily);
            $('#chart-loading').hide();
            $('.total_people_count').text('누적 방문자 수 : ' + data.at(-1).cumulative + ' 명')
            const c = document.getElementById('signupChart').getContext('2d');
            if (signupChart) signupChart.destroy();
            signupChart = new Chart(c, {
                type: 'line',
                data: {labels, datasets: [{label: '방문자 수', data: counts, fill: true, tension: 0.3}]},
                options: {responsive: true, plugins: {legend: {display: false}}, scales: {y: {beginAtZero: true}}}
            });
        });
    });

    // 사장님 리뷰 테이블 데이터 로드 함수 (fetch API)
    let currentOwnerPage = 1;
    let firstOwnerPage = 1;
    let lastOwnerPage = 10;

    function searchReview(query, page, size) {
        $.ajax({
            url: ctx + '/admin/home/reviews',
            type: 'GET',
            data: {query, currentPage: page, pageSize: size},
            success: function (response) {
                loadReviewTable(response);
                console.log(response)
                if (response.lastPage * size < response.count) {
                    $('.r-div .pagination .next').removeClass('disabled');
                } else {
                    $('.r-div .pagination .next').addClass('disabled');
                }

                if (response.firstPage === 1) {
                    $('.r-div .pagination .previous').addClass('disabled');
                } else {
                    $('.r-div .pagination .previous').removeClass('disabled');
                }
                lastOwnerPage = response.lastPage;
                firstOwnerPage = response.firstPage;
                reviewRenderPagination(firstOwnerPage, lastOwnerPage, page);
            },
            error: function () {
                alert('검색 중 오류가 발생했습니다.');
            }
        });
    }

    function loadReviewTable(data) {
        const $tbody = document.querySelector('#review-table');
        $tbody.innerHTML = '';
        if (data && data.list.length > 0) {
            data.list.forEach(r => {
                $tbody.innerHTML += `<tr>
                            <td>\${r.reviewId || '-'}</td>
                            <td>\${r.usersId || '-'}</td>
                            <td>\${r.storeId || '-'}</td>
                            <td>\${r.reviewStar || '-'}</td>
                            <td>\${r.reviewContent || '-'}</td>
                            <td>\${r.reviewDate ? r.reviewDate.substring(0,10) : '-'}</td>
                            <td><button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">🗑 삭제</button></td>
                        </tr>`;
            });

        } else {
            $tbody.innerHTML = '<tr><td colspan="6" class="text-center">데이터 없음</td></tr>';
        }
    }

    function reviewRenderPagination(firstPage, lastPage, currentPage) {
        $('.r-div .pagination .page-item').not('.previous, .next').remove();
        for (let i = firstPage; i <= lastPage; i++) {
            const $li = $('<li>').addClass('page-item');
            if (i === currentPage) {
                $li.addClass('active').attr('aria-current', 'page');
            }
            const $a = $('<a>').addClass('page-link').text(i);
            $li.append($a);
            $('.r-div .pagination .next').before($li);
        }
    }

    // 페이지네이션 클릭 이벤트

    let currentCommunityPage = 1;
    let firstCommunityPage = 1;
    let lastCommunityPage = 10;

    function searchCommunity(query, page, size) {
        $.ajax({
            url: ctx + '/admin/home/boards',
            type: 'GET',
            data: {query, currentPage: page, pageSize: size},
            success: function (response) {
                loadCommunityTable(response);
                console.log(response)
                if (response.lastPage * size < response.count) {
                    $('.c-div .c-div .pagination .next').removeClass('disabled');
                } else {
                    $('.c-div .pagination .next').addClass('disabled');
                }

                if (response.firstPage === 1) {
                    $('.c-div .pagination .previous').addClass('disabled');
                } else {
                    $('.c-div .pagination .previous').removeClass('disabled');
                }
                lastCommunityPage = response.lastPage;
                firstCommunityPage = response.firstPage;
                communityRenderPagination(firstCommunityPage, lastCommunityPage, page);
            },
            error: function () {
                alert('검색 중 오류가 발생했습니다.');
            }
        });
    }

    // 커뮤니티 테이블 데이터 로드 함수 (fetch API)
    function loadCommunityTable(data) {
        const $tbody = document.querySelector('#community-table');
        $tbody.innerHTML = '';
        if (data && data.list.length > 0) {
            data.list.forEach(b => {
                $tbody.innerHTML += `<tr>
                            <td>\${b.boardId}</td>
                            <td>\${b.usersId}</td>
                            <td>\${b.usersNickname}</td>
                            <td>\${b.boardTitle || '-'}</td>
                            <td>\${b.boardViewcount || 0}</td>
                            <td>\${b.boardDate}</td>
                            <td>\${b.boardStatus || '-'}</td>
                        </tr>`;
            });
        } else {
            $tbody.innerHTML = '<tr><td colspan="6" class="text-center">데이터 없음</td></tr>';
        }
    }

    function communityRenderPagination(firstPage, lastPage, currentPage) {
        $('.c-div .pagination .page-item').not('.previous, .next').remove();
        for (let i = firstPage; i <= lastPage; i++) {
            const $li = $('<li>').addClass('page-item');
            if (i === currentPage) {
                $li.addClass('active').attr('aria-current', 'page');
            }
            const $a = $('<a>').addClass('page-link').text(i);
            $li.append($a);
            $('.c-div .pagination .next').before($li);
        }
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
        const $pageSize = 10;
        const $cPagination = $('.c-div .pagination')
        const $rPagination = $('.r-div .pagination')
        const $primaryButton = $('.modal-footer button.btn-primary');
        // 검색 폼 제출
        $('#reviewSearchForm').on('submit', function (e) {
            e.preventDefault();
            currentOwnerPage = 1;
            const query = $(this).find('input[name="query"]').val();
            searchReview(query, currentOwnerPage, 10);
        });

        $('#communitySearchForm').on('submit', function (e) {
            e.preventDefault();
            currentCommunityPage = 1;
            const query = $(this).find('input[name="query"]').val();
            searchCommunity(query, currentCommunityPage, 10);
        });

        // 페이지 번호 클릭
        $rPagination.on('click', '.page-item:not(.previous):not(.next) .page-link', function (e) {
            e.preventDefault();
            const query = $('#reviewSearchForm').find('input[name="query"]').val();
            currentOwnerPage = parseInt($(this).text(), 10);
            updatePaginationUI($(this));
            searchReview(query, currentOwnerPage, 10);
        });

        $cPagination.on('click', '.page-item:not(.previous):not(.next) .page-link', function (e) {
            e.preventDefault();
            const query = $('#communitySearchForm').find('input[name="query"]').val();
            currentCommunityPage = parseInt($(this).text(), 10);
            updatePaginationUI($(this));
            searchCommunity(query, currentCommunityPage, 10);
        });

        // Previous 클릭
        $rPagination.on('click', '.previous .page-link', function (e) {
            e.preventDefault();
            const query = $('#reviewSearchForm').find('input[name="query"]').val();
            searchReview(query, firstOwnerPage - 10, 10);
        });

        // Previous 클릭
        $cPagination.on('click', '.previous .page-link', function (e) {
            e.preventDefault();
            const query = $('#communitySearchForm').find('input[name="query"]').val();
            searchCommunity(query, firstCommunityPage - 10, 10);
        });

        // Next 클릭
        $rPagination.on('click', '.next .page-link', function (e) {
            e.preventDefault();
            const query = $('#reviewSearchForm').find('input[name="query"]').val();
            searchReview(query, lastOwnerPage + 1, 10);
        });

        $cPagination.on('click', '.next .page-link', function (e) {
            e.preventDefault();
            const query = $('#communitySearchForm').find('input[name="query"]').val();
            searchCommunity(query, lastCommunityPage + 1, 10);
        });

        $('#review-table').on('click', '.btn-primary', function () {
            const reviewId = $(this).closest('tr').find('td:first').text();
            console.log('클릭된 리뷰 ID:', reviewId);
            $('#exampleModal').modal('show');
            $('.modal-footer button.btn-primary').data('reviewId', reviewId);
        });

        $primaryButton.on('click', function () {
            const reviewId = $(this).data('reviewId');
            if (reviewId) {
                $.ajax({
                    url: ctx + '/admin/home/reviews/delete?reviewId=' + reviewId,
                    type: 'GET',
                    success: function () {
                        $('#exampleModal').modal('hide');
                        searchReview('', currentOwnerPage, 10); // 삭제 후 현재 페이지로 다시 검색
                    },
                    error: function () {
                        alert('삭제 중 오류가 발생했습니다.');
                    }
                });
            } else {
                alert('리뷰 ID가 없습니다.');
            }
        });

        $('#community-table').on('click', 'tr', function () {
            const boardId = $(this).find('td').eq(0).text().trim(); // boardId는 첫 번째 열
            if (boardId) {
                window.location.href = ctx + '/user/board/detail?boardId=' + boardId;
            }
        });


    });

</script>
</body>
</html>
