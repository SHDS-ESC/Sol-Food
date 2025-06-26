<%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 2025-06-18
  Time: 오전 11:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>404 에러 페이지</title>
    <style>
        body {
            background: linear-gradient(135deg, #f8fafc 0%, #e0e7ff 100%);
            min-height: 100vh;
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-container {
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            padding: 48px 40px 36px 40px;
            text-align: center;
            min-width: 340px;
        }
        .login-title {
            font-size: 2rem;
            font-weight: 700;
            color: #3730a3;
            margin-bottom: 32px;
        }
        .kakao {
            display: inline-block;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(255, 205, 0, 0.15);
            transition: transform 0.15s, box-shadow 0.15s;
        }
        .kakao:hover {
            transform: translateY(-2px) scale(1.03);
            box-shadow: 0 6px 16px rgba(255, 205, 0, 0.25);
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

<div>
    <h1>404 에러 페이지</h1>
    <p>페이지를 찾을 수 없습니다.</p>
    <h5>요청 경로를 확인해주세요.</h5>
    <div>
        <a href="<%= request.getContextPath() %>/user/userControl/login">로그인화면</a>
    </div>
</div>
</body>
</html>
