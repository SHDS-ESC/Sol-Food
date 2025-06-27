<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
        crossorigin="anonymous"></script>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
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
        .profile-container {
            background: #fff;
            border-radius: 24px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.08);
            padding: 48px 40px;
            text-align: center;
            min-width: 340px;
        }
        .profile-img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #6366f1;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(99,102,241,0.15);
        }
        .nickname {
            font-size: 2rem;
            font-weight: 700;
            color: #3730a3;
            margin-bottom: 12px;
        }
        .welcome {
            font-size: 1.2rem;
            color: #4b5563;
        }
        .logout-btn {
            margin-top: 24px;
        }
        .logout-btn button {
            background-color: #ef4444;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 1rem;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .logout-btn button:hover {
            background-color: #dc2626;
        }
    </style>
</head>
<body>
<div class="profile-container">
    <img class="profile-img" src='${not empty userLoginSession.usersProfile ? userLoginSession.usersProfile : "https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800"}' alt='프로필 이미지'>
    <div class="nickname">
        <c:choose>
            <c:when test="${not empty userLoginSession.usersNickname}">
                ${userLoginSession.usersNickname}님
            </c:when>
            <c:otherwise>
                사용자님
            </c:otherwise>
        </c:choose>
    </div>
    <div class="welcome">환영합니다 🎉</div>
    <div class="logout-btn">
        <button onclick="location.href='/solfood/user/login/logout'">로그아웃</button>
    </div>
</div>
</body>
</html>