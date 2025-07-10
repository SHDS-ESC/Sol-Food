<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- <link
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet"
        /> -->
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
            rel="stylesheet"
    />
    <title>solfood</title>
    <link
            rel="stylesheet"
            href="${pageContext.request.contextPath}/css/style.css"
    />
    <link
            rel="stylesheet"
            href="${pageContext.request.contextPath}/css/reset.css"
    />
    <link
            rel="stylesheet"
            href="${pageContext.request.contextPath}/css/login/register.css"
    />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<div class="wrap">
    <div class="header flex flex-sb">
        <div><strong>로고</strong></div>
        <div style="display: flex; gap: 12px; align-items: center">
            <button
                    id="darkmode-toggle"
                    style="
              background: none;
              border: none;
              cursor: pointer;
              font-size: 20px;
              color: var(--color-black);
            "
            >
                <i class="bi bi-moon"></i>
            </button>
            <i class="bi bi-list" style="font-size: 20px"></i>
        </div>
    </div>
    <div class="content register">

        <form action="<c:url value="/user/login/extra"/>" method="post"  class="register-form">

            <div class="nickname" style=" font-size: 20px;  font-weight: bold; font-size: 24px;font-weight: bold; ">${userLoginSession.usersNickname } 님,</div>
            <div class="welcome" style="font-weight: bold;  margin-top: -8px;   margin-bottom: 20px;  font-size: 18px;">추가 정보를 입력해주세요.</div>
    
            <div class="profile-section" style="display: flex;  flex-direction: column;  align-items: center;">
                <img class="profile-img" style="width: 120px;  height: 120px;   border-radius: 50%;   object-fit: cover;" src='${userLoginSession.usersProfile }' alt='프로필 이미지'>
            </div>
            
            <input type="hidden" name="usersId" value="${userLoginSession.usersId}">
            <input type="hidden" name="usersEmail" value="${userLoginSession.usersEmail }">
            <input type="hidden" name="usersProfile" value="${userLoginSession.usersProfile }">
            <input type="hidden" name="usersNickname" value="${userLoginSession.usersNickname }">
            <input type="hidden" name="usersKakaoId" value="${userLoginSession.usersKakaoId}">
            <input type="hidden" name="accessToken" value="${userLoginSession.accessToken}">
            <input type="hidden" name="usersPoint" value="${userLoginSession.usersPoint}">
            <input type="hidden" name="usersLoginType" value="${userLoginSession.usersLoginType}">
            <input type="hidden" name="usersStatus" value="active">

            <label for="companySelect">회사 *</label>
            <select class="custom-select" id="companySelect" name="companyId" required onchange="loadDepts(this.value)">
                <option value="">-- 회사 선택 --</option>
                <c:forEach var="c" items="${companyList}">
                    <option value="${c.companyId}">${c.companyName}</option>
                </c:forEach>
            </select>

            <label for="departmentId">부서 *</label>
            <select class="custom-select" name="departmentId" id="departmentId" required>
                <option value="">-- 부서 선택 --</option>
            </select>

            <label for="usersName">이름</label>
            <input class="border-input" type="text" id="usersName" name="usersName" required>

            <label for="usersBirth">생년월일</label>
            <input class="border-input" type="date" id="usersBirth" name="usersBirth" required>

            <label for="usersTel">전화번호</label>
            <input class="border-input" type="tel" id="usersTel" name="usersTel" required>

            <div>
                <label style="display: block; margin-bottom: 8px" for="usersGender"
                >성별</label
                >
                <label class="radio">
                    <input type="radio" name="usersGender" value="male" checked />
                    <span>남자</span>
                </label>
                <label class="radio">
                    <input type="radio" name="usersGender" value="female" />
                    <span>여자</span>
                </label>
            </div>

            <div class="footer flex flex-sa" style="left: 0">
                <button class="footer-btn">가입하기</button>
            </div>
<%--            <div class="form-actions">--%>
<%--                <button type="submit" class="btn btn-submit">가입하기</button>--%>
<%--                <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>--%>
<%--            </div>--%>

        </form>

    </div>


</div>

<script src="${pageContext.request.contextPath}/js/validateInput.js"></script>
<script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
<script src="${pageContext.request.contextPath}/js/popup.js"></script>
<script>
    const contextPath = '${pageContext.request.contextPath}'; // context path
    // ajax 로 회사 선택 후 부서 리스트 조회
    function loadDepts(companyId){
        const deptSelect = document.getElementById("departmentId");
        deptSelect.innerHTML = `<option value="">-- 부서 선택 --</option>`;

        if (!companyId) return;

                    fetch(contextPath + "/user/login/company/depts?companyId=" + companyId)
            .then(res => res.json())
            .then(data => {
                data.forEach(dept => {
                    const option = document.createElement("option");
                    option.value = dept.departmentId;
                    option.text = dept.departmentName;
                    deptSelect.appendChild(option);
                });
            })
            .catch(error => {
                showWarningPopup("부서 목록을 불러오지 못했습니다.");
            });
    }

    $(function(){
          applyPhoneHyphen('#usersTel');
        })

</script>
</body>
</html>