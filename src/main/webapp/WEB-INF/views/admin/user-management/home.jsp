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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/user-management.css">
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
                    <c:forEach var="user" items="${userList.list}">
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
<script>window.APP_CTX = "${pageContext.request.contextPath}";</script>
<script src="${pageContext.request.contextPath}/js/admin/user-management.js"></script>
</body>

</html>
