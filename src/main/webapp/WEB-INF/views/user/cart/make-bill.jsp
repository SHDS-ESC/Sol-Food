<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>금액 조정 - Sol Food</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="<c:url value='/css/waiting-approval.css' />">
</head>
<body>
    <div class="waiting-container">
        <div class="waiting-header">
            <i class="bi bi-arrow-left back-btn" onclick="goBack()"></i>
            <h3 class="mb-0">금액 조정</h3>
        </div>
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
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>합계: <span id="sumAmount">0</span>원 / <span id="totalAmount">0</span>원</div>
                    <span id="amountCheckMsg" class="text-danger"></span>
                </div>
                <button type="submit" id="submitBtn" class="btn btn-primary w-100" disabled>확정</button>
            </form>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/popup.js"></script>
    <script src="${pageContext.request.contextPath}/js/make-bill.js"></script>
</body>
</html>
