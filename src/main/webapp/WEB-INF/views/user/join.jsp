<%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 2025-06-18
  Time: 오전 11:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원가입</title>
  <!-- HEAD 안에 추가할 CSS (Tailwind 같은 스타일 반영) -->
  <style>
    body {
      background: linear-gradient(135deg, #eef2ff, #c7d2fe);
      font-family: 'Segoe UI', sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      margin: 0;
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

  <div class="form-container">
    <div class="form-title">회원가입</div>
    <form action="/solfood/user/join" method="post">
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

      <label>이메일 *</label>
      <input type="email" name="usersEmail" required placeholder="example@domain.com">

      <label>비밀번호 *</label>
      <input type="password" name="usersPwd" required minlength="6" placeholder="6자 이상 입력">

      <label>닉네임 *</label>
      <input type="text" name="usersNickname" required>

      <label>이름 *</label>
      <input type="text" name="usersName" required>

      <label>생년월일 *</label>
      <input type="date" name="usersBirth" required>

      <label>성별 *</label>
      <select name="usersGender" required>
        <option value="">선택하세요</option>
        <option value="남성">남성</option>
        <option value="여성">여성</option>
      </select>

      <label>전화번호 *</label>
      <input type="tel" name="usersTel" placeholder="010-0000-0000" required>

      <!-- Hidden Fields -->
      <input type="hidden" name="usersProfile" value="null">
      <input type="hidden" name="usersPoint" value="0">
      <input type="hidden" name="usersLoginType" value="native">

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
</head>
</html>
