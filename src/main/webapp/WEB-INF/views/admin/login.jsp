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
    <style>
        :root {
            --primary-color: #28a745;
            --secondary-color: #f0fdf4;
            --accent-color: #1e7e34;
            --card-bg: #ffffff;
            --text-color: #343a40;
        }

        * {
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--secondary-color);
            color: var(--text-color);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-card {
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 1.25rem;
            box-shadow: 0 8px 32px rgba(40, 167, 69, 0.08);
            width: 100%;
            max-width: 400px;
        }

        .login-card h2 {
            margin-bottom: 1.5rem;
            color: var(--primary-color);
            text-align: center;
            font-weight: 700;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            font-weight: 600;
            margin-bottom: .25rem;
            display: inline-block;
        }

        .form-group input {
            width: 100%;
            padding: .75rem;
            border: 1px solid #dee2e6;
            border-radius: .5rem;
            font-size: 1rem;
        }

        .btn-login {
            width: 100%;
            padding: .75rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: .5rem;
        }

        .login-footer {
            margin-top: 1rem;
            text-align: center;
            font-size: .9rem;
        }

        .login-footer a {
            color: var(--accent-color);
            text-decoration: none;
        }
    </style>
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
