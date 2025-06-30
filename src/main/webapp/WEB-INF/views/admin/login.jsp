<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
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
<div class="login-container">
    <div class="login-title">로그인</div>
    <a id="login-kakao-btn"
       class="kakao"
       href="https://kauth.kakao.com/oauth/authorize?client_id=${apiKey}&redirect_uri=http://${serverMap.ip}:${serverMap.port}${pageContext.request.contextPath}/user/kakaoLogin&response_type=code">
        <img src="https://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg"
             alt="카카오 로그인 버튼"
             width="222"/>
    </a>
</div>
</body>
</html>