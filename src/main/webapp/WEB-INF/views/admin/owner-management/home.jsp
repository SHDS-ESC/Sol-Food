<>
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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/owner-management.css">
</head>

<body>
<div class="d-flex">
    <!-- Sidebar -->
    <nav class="side-menu">
        <h4>🌿 관리자 메뉴</h4>
        <a href="<c:url value="/admin/home"/>" class="nav-link">홈</a>
        <a href="<c:url value="/admin/user-management"/>" class="nav-link ">사용자</a>
        <a href="<c:url value="/admin/owner-management"/>" class="nav-link active">점주</a>
        <a href="<c:url value="/admin/payment-management"/>" class="nav-link">결제</a>
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
                <input type="text" name="query" class="form-control" placeholder="지점명으로 검색">
                <button type="submit" class="btn btn-success">검색</button>
            </form>

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
                        <th>거절사유</th>
                    </tr>
                    </thead>
                    <tbody id="ownerListBody">
                    <c:forEach var="owner" items="${ownerList.list}">
                        <tr onclick="location.href='${pageContext.request.contextPath}/admin/owner-detail?ownerId=' + $(this).children('.owner-id').text()">
                            <td class="owner-id">${owner.ownerId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty owner.storeMainimage}">
                                        <img src="${owner.storeMainimage}" class="owner-avatar"
                                             alt="https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800">
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
                            <td>${owner.categoryName}</td>
                            <td>${owner.storeAvgstar != null ? String.format("%.1f", owner.storeAvgstar) : '0.0'}</td>
                            <td>${owner.ownerTel}</td>
                            <td>${owner.storeTel}</td>
                            <td>${owner.storeAddress}</td>
                            <td>${owner.storeIntro}</td>
                            <td>
                                <div class="status-container">
                        <span class="status-badge
                            ${owner.storeStatus == '승인완료' ? 'status-approved' :
                              owner.storeStatus == '승인대기' ? 'status-pending' : 'status-rejected'}">
                                ${owner.storeStatus}
                        </span>
                                </div>
                            </td>
                            <td>${owner.storeRejectReason}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <div id="custom-nav">
                    <nav aria-label="Page navigation example">
                        <ul class="pagination">
                            <li class="previous disabled">
                                <a class="page-link" tabindex="-1" aria-disabled="true">Previous</a>
                            </li>
                            <li class="page-item active "><a class="page-link">1</a></li>
                            <c:forEach begin="${ownerList.firstPage + 1}" end="${ownerList.lastPage}" var="page">
                                <li class="page-item"><a class="page-link">${page}</a></li>
                            </c:forEach>
                            <li class="next">
                                <c:choose>
                                    <c:when test="${ownerList.lastPage * ownerList.limit gt ownerList.count}">
                                        <a class="page-link disabled">Next</a>
                                    </c:when>
                                    <c:otherwise>
                                        <a class="page-link">Next</a>
                                    </c:otherwise>
                                </c:choose>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
        crossorigin="anonymous"></script>
<script>window.APP_CTX = "${pageContext.request.contextPath}";</script>
<script src="${pageContext.request.contextPath}/js/admin/owner-management.js"></script>
</body>

</html>
</>