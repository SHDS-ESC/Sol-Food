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
    </style>
</head>
<body>
<div class="profile-container">
    <img class="profile-img" src='${userLoginSession.usersProfile }' alt='카카오 프로필 이미지'>
    <div class="nickname">${userLoginSession.usersNickname }님</div>
    <div class="welcome">추가 정보를 입력해주세요</div>
    <form action="<c:url value="/user/add-register"/>" method="post">
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

        <label for="companySelect">회사 *</label>
        <select id="companySelect" name="companyId" required onchange="loadDepts(this.value)">
            <option value="">-- 회사 선택 --</option>
            <c:forEach var="c" items="${companyList}">
                <option value="${c.companyId}">${c.companyName}</option>
            </c:forEach>
        </select>

        <label for="departmentId">부서 *</label>
        <select name="departmentId" id="departmentId" required>
            <option value="">-- 부서 선택 --</option>
        </select>

        <label for="usersName">이름</label>
        <input type="text" id="usersName" name="usersName" required>

        <label for="usersBirth">생년월일</label>
        <input type="date" id="usersBirth" name="usersBirth" required>

        <label for="usersGender">성별</label>
        <select id="usersGender" name="usersGender" required>
            <option value="">선택하세요</option>
            <option value="남성">남성</option>
            <option value="여성">여성</option>
        </select>

        <label for="usersTel">전화번호</label>
        <input type="tel" id="usersTel" name="usersTel" required>

        <div class="form-actions">
            <button type="submit" class="btn btn-submit">가입하기</button>
            <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
        </div>

    </form>
</div>
<script>
    const contextPath = '${pageContext.request.contextPath}'; // 예: /solfood
    // ajax 로 회사 선택 후 부서 리스트 조회
    function loadDepts(companyId){
        console.log(contextPath)
        console.log(companyId);
        const deptSelect = document.getElementById("departmentId");
        deptSelect.innerHTML = `<option value="">-- 부서 선택 --</option>`;

        if (!companyId) return;

        fetch("/solfood/user/company/depts?companyId=" + companyId)
            .then(res => res.json())
            .then(data => {
                data.forEach(dept => {
                    const option = document.createElement("option");
                    option.value = dept.departmentId;
                    option.text = dept.departmentName;
                    deptSelect.appendChild(option); // ✅ 중요!
                });
            })
            .catch(error => {
                console.error("부서 불러오기 실패", error);
                console.log(contextPath + "/user/company/depts?companyId=" + companyId)
            });
    }

</script>
</body>
</html>