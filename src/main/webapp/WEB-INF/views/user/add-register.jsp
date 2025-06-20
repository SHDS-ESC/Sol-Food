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
    <title>추가 회원 가입</title>
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
            box-shadow: 0 4px 24px rgba(0, 0, 0, 0.08);
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
            box-shadow: 0 2px 8px rgba(99, 102, 241, 0.15);
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
    <img class="profile-img" src='${userLoginSession.usersProfile }' alt='카카오 프로필 이미지'>
    <div class="nickname">${userLoginSession.usersNickname }님</div>
    <div class="welcome">추가 정보를 입력해주세요</div>
    <form action="/solfood/user/add-register" method="post">
        <input type="hidden" name="usersId" value="${userLoginSession.usersId}">
        <input type="hidden" name="companyId" value="${userLoginSession.companyId }">
        <input type="hidden" name="departmentId" value="${userLoginSession.departmentId }">
        <input type="hidden" name="usersEmail" value="${userLoginSession.usersEmail }">
        <input type="hidden" name="usersProfile" value="${userLoginSession.usersProfile }">
        <input type="hidden" name="usersNickname" value="${userLoginSession.usersNickname }">
        <input type="hidden" name="usersKakaoId" value="${userLoginSession.usersKakaoId}">
        <input type="hidden" name="accessToken" value="${userLoginSession.accessToken}">
        <input type="hidden" name="usersPoint" value="${userLoginSession.usersPoint}">
        <input type="hidden" name="usersLoginType" value="${userLoginSession.usersLoginType}">

        <div class="form-group">
            <label for="usersName">이름</label>
            <input type="text" id="usersName" name="usersName" required>
        </div>

        <div class="form-group">
            <label for="usersBirth">생년월일</label>
            <input type="date" id="usersBirth" name="usersBirth" required>
        </div>

        <div class="form-group">
            <label for="usersGender">성별</label>
            <select id="usersGender" name="usersGender" required>
                <option value="">선택하세요</option>
                <option value="남성">남성</option>
                <option value="여성">여성</option>
            </select>
        </div>

        <div class="form-group">
            <label for="usersTel">전화번호</label>
            <input type="tel" id="usersTel" name="usersTel" required>
        </div>

        <button type="submit" class="submit-btn">가입하기</button>

    </form>
</body>
</html>