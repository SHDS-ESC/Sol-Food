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

                .chart-card,
                .user-card {
                    background: var(--card-bg);
                    border-radius: .75rem;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                }

                .chart-card {
                    padding: 2rem;
                    margin-bottom: 2rem;
                }

                .user-card {
                    padding: 1.5rem;
                }

                .filter-btns .btn {
                    border-radius: .5rem;
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
                    width: 32px;
                    height: 32px;
                    object-fit: cover;
                    border-radius: 50%;
                    border: 2px solid var(--accent-color);
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
            </style>
        </head>

        <body>
            <div class="d-flex">
                <!-- Sidebar -->
                <nav class="side-menu">
                    <h4>🌿 관리자 메뉴</h4>
                    <a href="#" class="nav-link">홈</a>
                    <a href="#" class="nav-link active">사용자</a>
                    <a href="#" class="nav-link">점주</a>
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
                            <li class="breadcrumb-item active" aria-current="page">사용자</li>
                        </ol>
                    </nav>

                    <!-- 가입자 추이 -->
                    <div class="d-flex align-items-center mb-3">
                        <h2 class="me-auto text-success">📈 가입자 추이</h2>
                        <div class="btn-group filter-btns" role="group">
                            <button type="button" class="btn btn-outline-success active">연간</button>
                            <button type="button" class="btn btn-outline-success">월간</button>
                            <button type="button" class="btn btn-outline-success">일간</button>
                        </div>
                    </div>
                    <div class="chart-card">
                        <p class="text-muted fst-italic mb-3">최근 6개월간 가입자 수 변화</p>
                        <img src="https://via.placeholder.com/800x250?text=가입자+그래프" class="w-100 rounded"
                            alt="가입자 수 차트">
                    </div>

                    <!-- 사용자 리스트 -->
                    <h2 class="mb-3 text-success">🎭 사용자 관리</h2>
                    <div class="user-card">
                        <div class="row mb-3">
                            <form action="<c:url value="/admin/search" />" method="get">
                            <div class="col-md-4">
                                <input type="text" name="query" class="form-control" placeholder="검색">
                            </div>
                            <div class="col-md-4">
                                <button type="submit">로그인</button> <br> <br>
                            </div>
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
                                <tbody>
                                    <c:forEach var="user" items="${userList}">
                                        <tr>
                                            <td>${user.usersId}</td>
                                            <td>${user.usersProfile}</td>
                                            <td>${user.usersName}</td>
                                            <td>${user.usersNickname}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${empty user.usersLoginType}">WEB</c:when>
                                                    <c:otherwise>${user.usersLoginType}</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${user.usersEmail}</td>
                                            <td>${user.company_name}</td>
                                            <td>${user.usersBirth}</td>
                                            <td>${user.usersGender}</td>
                                            <td>${user.usersStatus}</td>
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
        </body>

        </html>