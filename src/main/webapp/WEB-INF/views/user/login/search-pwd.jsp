<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호찾기</title>
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
        .form-container {
            background: #fff;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 480px;
        }
        .form-title {
            font-size: 28px;
            font-weight: bold;
            color: #4338ca;
            margin-bottom: 24px;
            text-align: center;
        }
        label {
            display: block;
            margin-top: 16px;
            font-weight: 600;
            margin-bottom: 4px;
            color: #374151;
            text-align: left;
        }
        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            font-size: 14px;
            box-sizing: border-box;
        }
        input:focus, select:focus {
            border-color: #6366f1;
            outline: none;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }
        .form-actions {
            margin-top: 32px;
            display: flex;
            justify-content: space-between;
            gap: 10px;
        }
        .btn {
            flex: 1;
            padding: 12px;
            border-radius: 8px;
            border: none;
            font-weight: bold;
            cursor: pointer;
            transition: 0.2s ease;
            width: 222px;
        }
        .btn-submit {
            background-color: #6366f1;
            color: white;
        }
        .btn-submit:hover {
            background-color: #4f46e5;
        }
        .btn-cancel {
            background-color: #e5e7eb;
            color: #374151;
        }
        .btn-cancel:hover {
            background-color: #d1d5db;
        }
        a{margin-right: 10px}
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
    <div class="login-title">비밀번호 찾기</div>
            <form action="${pageContext.request.contextPath}/user/login/search-pwd" method="post">

        <label>이메일 *</label>
        <input type="email" name="usersEmail" required placeholder="example@domain.com">

        <label>이름 *</label>
        <input type="text" name="usersName" required> <br> <br>

        <button type="submit" class="btn btn-submit">비밀번호 찾기</button> <br> <br>
    </form>
    <a href="<c:url value='/user/login/register'/>">회원가입</a>
    <a href="<c:url value='/user/login'/>">로그인</a>
</div>
</body>
</html>