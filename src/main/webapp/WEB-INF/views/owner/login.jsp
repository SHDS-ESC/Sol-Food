<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sol Food - 오너 로그인</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
        }

        .login-container {
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 420px;
            position: relative;
        }

        .brand-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .brand-logo {
            font-size: 3rem;
            margin-bottom: 10px;
        }

        .brand-title {
            font-size: 2rem;
            font-weight: 700;
            color: #22c55e;
            margin-bottom: 5px;
        }

        .brand-subtitle {
            color: #666;
            font-size: 1rem;
            margin-bottom: 10px;
        }

        .login-type {
            background: linear-gradient(135deg, #4ade80, #22c55e);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            display: inline-block;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-group input {
            width: 100%;
            padding: 15px;
            border: 2px solid #e5e7eb;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #f9fafb;
        }

        .form-group input:focus {
            outline: none;
            border-color: #22c55e;
            background: white;
            box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.1);
        }

        .login-btn {
            width: 100%;
            background: linear-gradient(135deg, #4ade80, #22c55e);
            color: white;
            border: none;
            padding: 15px;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 20px;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(34, 197, 94, 0.2);
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 20px 0;
            color: #666;
        }

        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e5e7eb;
        }

        .divider span {
            padding: 0 15px;
            font-size: 0.9rem;
        }

        .kakao-login {
            width: 100%;
            background: #FEE500;
            color: #000;
            border: none;
            padding: 15px;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
        }

        .kakao-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(254, 229, 0, 0.3);
        }

        .form-links {
            text-align: center;
            margin-top: 20px;
        }

        .form-links a {
            color: #22c55e;
            text-decoration: none;
            font-weight: 600;
            margin: 0 10px;
            transition: color 0.3s ease;
        }

        .form-links a:hover {
            color: #16a34a;
        }

        .checkbox-group {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }

        .checkbox-group input[type="checkbox"] {
            margin-right: 8px;
            transform: scale(1.2);
        }

        .checkbox-group label {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 0;
        }

        .error-message {
            background: #fef2f2;
            color: #dc2626;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.9rem;
            border-left: 4px solid #dc2626;
        }

        @media (max-width: 480px) {
            .login-container {
                margin: 20px;
                padding: 30px 25px;
            }

            .brand-title {
                font-size: 1.8rem;
            }
        }
    </style>
    <script>
        let msg = '${msg}';
        if (msg) {
            alert(msg);
        }
    </script>
</head>
<body>
    <div class="login-container">
        <div class="brand-header">
            <div class="brand-logo">🍽️</div>
            <h1 class="brand-title">Sol Food</h1>
            <p class="brand-subtitle">레스토랑 관리 시스템</p>
            <span class="login-type">오너 로그인</span>
        </div>

        <c:if test="${not empty msg}">
            <div class="error-message">
                ${msg}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/owner/login" method="post">
            <div class="form-group">
                <label for="ownerId">아이디</label>
                <input type="text" id="ownerId" name="ownerId" placeholder="아이디를 입력하세요" required>
            </div>

            <div class="form-group">
                <label for="ownerPassword">비밀번호</label>
                <input type="password" id="ownerPassword" name="ownerPassword" placeholder="비밀번호를 입력하세요" required>
            </div>

            <div class="checkbox-group">
                <input type="checkbox" id="rememberMe" name="rememberMe">
                <label for="rememberMe">로그인 상태 유지</label>
            </div>

            <button type="submit" class="login-btn">로그인</button>
        </form>

        <div class="divider">
            <span>또는</span>
        </div>

        <a href="https://kauth.kakao.com/oauth/authorize?client_id=${apiKey}&redirect_uri=http://${serverMap.ip}:${serverMap.port}${pageContext.request.contextPath}/owner/kakaoLogin&response_type=code" 
           class="kakao-login">
            <span>💬</span>
            카카오로 간편 로그인
        </a>

        <div class="form-links">
            <a href="${pageContext.request.contextPath}/owner/register">회원가입</a>
            <span>|</span>
            <a href="${pageContext.request.contextPath}/owner/find-password">비밀번호 찾기</a>
        </div>
    </div>
</body>
</html>