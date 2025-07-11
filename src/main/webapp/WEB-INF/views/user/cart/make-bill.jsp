<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>금액 조정 - Sol Food</title>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- Common CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/make-bill.css?v=${pageContext.session.creationTime}" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/waiting-approval.css' />">
    <script src="${pageContext.request.contextPath}/js/urlConstants.js"></script>
</head>
<body>
    <div class="wrap">
        <jsp:include page="../include/backbtn-header.jsp" />

        <!-- 컨텐츠 -->
        <div class="content make-bill">
            <div class="status-section">
                <i class="bi bi-pencil-square status-icon"></i>
                <div class="status-title">참여자별 결제 금액 조정</div>
                <div class="status-desc">각자 결제할 금액을 입력하거나 수정할 수 있습니다.</div>
            </div>

            <div class="progress-section">
                <div class="progress-header">
                    <h5><i class="bi bi-people"></i> 결제 인원</h5>
                </div>
                <form id="billForm">
                    <table class="table table-bordered text-center align-middle">
                        <thead class="table-light">
                        <tr>
                            <th>이름</th>
                            <th>금액(원)</th>
                        </tr>
                        </thead>
                        <tbody id="billTableBody">
                        <!-- JS로 참여자별 row 생성 -->
                        </tbody>
                    </table>
                    <div class="amount-summary">
                        <div>합계: <span id="sumAmount">0</span>원 / <span id="totalAmount">0</span>원</div>
                        <span id="amountCheckMsg" class="error-message"></span>
                    </div>
                    <button type="submit" id="submitBtn" class="submit-btn" disabled>확정</button>
                </form>
            </div>
        </div>
    </div>

<!-- JavaScript -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="<c:url value='/js/urlConstants.js' />"></script>
<script src="<c:url value='/js/common-utils.js' />"></script>
<script src="<c:url value='/js/popup.js' />"></script>
<script src="<c:url value='/js/make-bill.js' />"></script>
<script src="<c:url value='/js/darkmode.js' />"></script>
</body>
</html>
