<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-login.css">
</head>
<body>
<div class="login-card">
    <h2>관리자 로그인</h2>
    <form action="${pageContext.request.contextPath}/admin/login" method="post">
        <div class="form-group">
            <input type="password"
                   id="password"
                   name="password"
                   placeholder="비밀번호 입력"
                   required>
        </div>

        <button type="submit" class="btn btn-success btn-login">로그인</button>
    </form>
    <div class="login-footer">
        <a href="${pageContext.request.contextPath}/forgot-password">비밀번호를 잊으셨나요?</a>
    </div>
</div>
</body>
</html>
