<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
      <jsp:include page="../include/backbtn-header.jsp"></jsp:include>

      <div class="content register">
        <form
          class="register-form"
          action="${pageContext.request.contextPath}/user/mypage/info"
          method="post"
          enctype="multipart/form-data"
        >
          <div>
            <div class="profile-upload-container">
              <div
                class="profile-preview-container"
                onclick="document.getElementById('profileImageInput').click()"
              >
                <img
                  id="profilePreview"
                  class="profile-preview"
                  src='${user.usersProfile}'
                  alt="프로필 미리보기"
                />
                <div class="profile-upload-overlay">
                  <i class="camera-icon">📷</i>
                  <span>사진 변경</span>
                </div>
              </div>
              <input
                type="file"
                id="profileImageInput"
                accept="image/*"
                onchange="handleProfileImageUpload(this)"
                style="display: none"
              />
              <button
                type="button"
                class="btn-upload"
                onclick="document.getElementById('profileImageInput').click()"
              >
                사진 선택
              </button>
            </div>
            <!-- 업로드 진행률 -->
            <div
              id="uploadProgress"
              class="upload-progress"
              style="display: none"
            >
              <div class="progress-bar-container">
                <div id="uploadProgressBar" class="progress-bar"></div>
              </div>
              <span id="uploadProgressText" class="progress-text">0%</span>
            </div>
          </div>
          
          <div class="form-group">
            <label for="companySelect">회사 *</label>
            <select class="custom-select" id="companySelect" name="companyId" required onchange="loadDepts(this.value)">
                <option value="">-- 회사 선택 --</option>
                <c:forEach var="c" items="${companyList}">
                    <option value="${c.companyId}"  <c:if test="${c.companyId == user.companyId}">selected</c:if>>${c.companyName}</option>
                </c:forEach>
            </select>
          </div>

          
          
          <div class="form-group">
            <label for="departmentId">부서 *</label>
            <select class="custom-select" name="departmentId" id="departmentId" required>
                <option value="">-- 부서 선택 --</option>
            </select>
          </div>
        
        
        
          <div class="form-group">
            <label for="email">이메일</label>
            <input
              id="email"
              type="email"
              class="border-input"
              name="usersEmail"
              value="${user.usersEmail}"
              required
            />
            <div class="border-error" style="display:none;">올바른 이메일 주소를 입력해 주세요</div>
          </div>
          <div class="form-group">
            <label for="password">비밀번호</label>
            <input
              id="password"
              type="password"
              class="border-input"
              placeholder="6자 이상"
              name="usersPwd" 
            />
            <!-- <div class="border-error">
            비밀번호는 6자 이상입니다
          </div> -->
          </div>
          <div class="form-group">
            <label for="nickname">닉네임</label>
            <input
              id="nickname"
              type="text"
              class="border-input"
              name="usersNickname"
              value="${user.usersNickname}"
              required
            />
            <div class="border-error" style="display:none;">한글 2~16자만 사용 가능합니다</div>
          </div>
          <div class="form-group">
            <label for="name">이름</label>
            <input
              id="name"
              type="text"
              class="border-input"
              name="usersName"
              value="${user.usersName}"
              required
            />
            <div class="border-error" style="display:none;">이름을 입력해 주세요</div>
          </div>
          <div class="form-group">
            <label for="phone">휴대폰 번호</label>
            <input
              id="phone"
              type="tel"
              class="border-input"
              name="usersTel"
              value="${user.usersTel}"
              required
            />
            <div class="border-error" style="display:none;">올바른 휴대폰 번호를 입력해 주세요</div>
          </div>
          <div class="form-group">
            <label for="birth">생년월일</label>
            <input
              id="birth"
              type="date"
              class="border-input"
              name="usersBirth"
              value="${user.usersBirth}"
              required
            />
            <div class="border-error" style="display:none;">생년월일을 입력해 주세요</div>
          </div>
          <div>
        <label style="display: block; margin-bottom: 8px" for="usersGender">성별</label>
        
        <label class="radio">
            <input type="radio" name="usersGender" value="male" 
                <c:if test="${user.usersGender == 'male' || empty user.usersGender}">checked</c:if> />
            <span>남자</span>
        </label>
        
        <label class="radio">
            <input type="radio" name="usersGender" value="female" 
                <c:if test="${user.usersGender == 'female'}">checked</c:if> />
            <span>여자</span>
        </label>
        </div>
          <div class="footer flex flex-sa" style="left: 0">
            <button class="footer-btn" type="submit">수정하기</button>
          </div>

          <!-- Hidden Fields -->
          <input type="hidden" id="usersProfile" name="usersProfile" value="${user.usersProfile}">
          <input type="hidden" name="usersPoint" value="${user.usersPoint}">
          <input type="hidden" name="usersLoginType" value="${user.usersLoginType}">
          <input type="hidden" name="usersStatus" value="${user.usersStatus}">
        </form>
      </div>
    </div>
    <script>
        // Context Path를 JavaScript에서 사용할 수 있도록 설정
        var contextPath = '${pageContext.request.contextPath}';
        
        // 프로필 이미지 미리보기 함수 (상단에 선언)
        async function previewProfileImage(event){
            let files = event.target.files;
            if (!files || !files[0]) return;
            
            const file = files[0];
            
            try {
                // S3 업로드 실행 (s3Upload.js의 s3Uploader 사용)
                const s3Url = await s3Uploader.uploadProfileImage(file);
    
                // 업로드 성공 후 미리보기 업데이트
                let reader = new FileReader();
                reader.onload = function (e){
                    let img = document.getElementById("profilePreview");
                    img.setAttribute('src',e.target.result );
                }
                reader.readAsDataURL(files[0]);
    
                // 업로드 성공 - hidden input에 S3 URL 저장
                document.getElementById('usersProfile').value = s3Url;
            } catch (error) {
                showWarningPopup('이미지 업로드에 실패했습니다. 다시 시도해주세요.');
            }
        }
    </script>
    <script src="${pageContext.request.contextPath}/js/validateInput.js"></script>
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
    <script src="${pageContext.request.contextPath}/js/urlConstants.js"></script>
    <script src="${pageContext.request.contextPath}/js/popup.js"></script>
    <script src="${pageContext.request.contextPath}/js/s3Upload.js"></script>
    <script>
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

                    fetch(contextPath + "/user/login/company/depts?companyId=" + companyId)
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
                alert("부서 목록을 불러오지 못했습니다.");
            });
    }
    
        // 페이지 로드 시 회사/부서 기본값 유지
        window.onload = function () {
            const selectedCompanyId = "${user.companyId}";
            if (selectedCompanyId) {
                loadDepts(selectedCompanyId);
            }
        };
    
    
    
    
    
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

        $(function(){
          applyPhoneHyphen('#phone');
        })
    
    
    </script>
  </body>
</html>
