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
    <title>마이페이지 회원정보</title>
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
        .profile-img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #6366f1;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(99,102,241,0.15);
        }
    </style>
</head>

<div class="form-container">
    <div class="form-title">마이페이지 회원정보</div>
    <form action="/solfood/user/mypage/info" method="post" enctype="multipart/form-data">


        <div style="text-align: center; cursor: pointer">
            <img id="profilePreview" class="profile-img" src='${user.usersProfile}' alt='프로필 이미지'>
        </div>

        <%--프로필 이미지 업로드--%>
        <input type="file" id="profileImageInput" accept="image/*" onchange="previewProfileImage(event)">


        <label for="companySelect">회사 *</label>
        <select id="companySelect" name="companyId" required onchange="loadDepts(this.value)">
            <option value="">-- 회사 선택 --</option>
            <c:forEach var="c" items="${companyList}">
                <option value="${c.companyId}"  <c:if test="${c.companyId == user.companyId}">selected</c:if>>${c.companyName}</option>
            </c:forEach>
        </select>

        <label for="departmentId">부서 *</label>
        <select name="departmentId" id="departmentId" required>
            <option value="">-- 부서 선택 --</option>
        </select>

        <label>이메일 *</label>
        <input value="${user.usersEmail}" type="email" name="usersEmail" required placeholder="example@domain.com">

<%--        <label>비밀번호 *</label>--%>
<%--        <input type="password" name="usersPwd" required minlength="6" placeholder="6자 이상 입력">--%>

        <label>닉네임 *</label>
        <input value="${user.usersNickname}" type="text" name="usersNickname" required>

        <label>이름 *</label>
        <input value="${user.usersName}" type="text" name="usersName" required>

        <label>생년월일 *</label>
        <input type="date" name="usersBirth" value="${user.usersBirth}" required>

        <label>성별 *</label>
        <select name="usersGender" required>
            <option value="">선택하세요</option>
            <option value="남성" ${user.usersGender == '남성' ? 'selected' : ''}>남성</option>
            <option value="여성" ${user.usersGender == '여성' ? 'selected' : ''}>여성</option>
        </select>

        <label>전화번호 *</label>
        <input value="${user.usersTel}" type="tel" name="usersTel" placeholder="010-0000-0000" required>

        <!-- Hidden Fields -->
        <input type="hidden" id="usersProfile" name="usersProfile">
        <input type="hidden" name="usersPoint" value=${user.usersPoint}>
        <input type="hidden" name="usersLoginType" value=${user.usersLoginType}>
        <input type="hidden" name="usersPwd" value="${user.usersPwd}">
        <input type="hidden" name="usersStatus" value="${user.usersStatus}">

        <div class="form-actions">
            <button type="submit"  class="btn btn-submit">수정하기</button>
        </div>
    </form>
    <form id="withdrawForm" action="/solfood/user/mypage/withdraw" method="post" style="display: inline;">
        <button type="submit" class="btn btn-cancel">탈퇴하기</button>
    </form>
</div>
<script src="${pageContext.request.contextPath}/js/s3Upload.js"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}'; // 예: /solfood
    // jsp 에서 서버로부터 받은 사용자 프로필 값
    const currentProfileUrl = "${user.usersProfile}";
    const defaultProfileUrl = "https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800";



    // ajax 로 회사 선택 후 부서 리스트 조회
    function loadDepts(companyId) {
        const deptSelect = document.getElementById("departmentId");
        deptSelect.innerHTML = `<option value="">-- 부서 선택 --</option>`;

        if (!companyId) return;

        /* 현재 사용자 부서 id */
        const selectedDeptId = "${user.departmentId}";

        fetch("/solfood/user/login/company/depts?companyId=" + companyId)
            .then(res => res.json())
            .then(data => {
                data.forEach(dept => {
                    const option = document.createElement("option");
                    option.value = dept.departmentId;
                    option.text = dept.departmentName;
                    if(dept.departmentId == selectedDeptId ){
                        option.selected = true; // ✅ 현재 유저의 부서와 일치할 경우 선택
                    }
                    deptSelect.appendChild(option); // ✅ 중요!
                });
            })
            .catch(error => {
                console.error("부서 불러오기 실패", error);
                console.log(contextPath + "/user/login/company/depts?companyId=" + companyId)
            });
    }

    // 페이지 로드 시 회사/부서 기본값 유지
    window.onload = function () {
        const selectedCompanyId = "${user.companyId}";
        if (selectedCompanyId) {
            loadDepts(selectedCompanyId);
        }
    };



    // 프로필 이미지 미리보기
    async function previewProfileImage(event){
        let files = event.target.files;
        let reader = new FileReader();
        reader.onload = function (e){
            let img = document.getElementById("profilePreview");
            img.setAttribute('src',e.target.result );
        }

        const file = files[0]; // ✅ 이 줄이 꼭 필요합니다!

        reader.readAsDataURL(files[0]);


        // S3 업로드 실행 (s3Upload.js의 s3Uploader 사용)
        const s3Url = await s3Uploader.uploadProfileImage(file, function(progress) {
            updateUploadProgress(progress);
        });

        // 업로드 성공 - hidden input에 S3 URL 저장
        document.getElementById('usersProfile').value = s3Url;

        console.log('프로필 이미지 업로드 완료:', s3Url);


    }

    // 페이지 로딩 시 hidden input에 값 세팅
    window.addEventListener("DOMContentLoaded",()=>{
        const hiddenInput = document.getElementById("usersProfile");

        // 기본 프로필 이미지인 경우 -> defaultProfileUrl 저장
        if (!currentProfileUrl || currentProfileUrl === defaultProfileUrl) {
            hiddenInput.value = defaultProfileUrl;
        } else {
            hiddenInput.value = currentProfileUrl;
        }
    })


</script>

</head>
</html>
