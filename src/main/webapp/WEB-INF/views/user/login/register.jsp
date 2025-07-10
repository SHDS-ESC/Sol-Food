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
      <%--헤더--%>
      <jsp:include page="../include/header.jsp"></jsp:include>
      <div class="content register">
        <form
          class="register-form"
          action="${pageContext.request.contextPath}/user/login/register"
          method="post"
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
                  src="https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800"
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
          <!-- <div class="form-group">
            <label for="company">회사</label>
            <select class="custom-select" onchange="loadDepts(this.value)">
              <option>선택하세요</option>
              <c:forEach var="c" items="${companyList}">
                <option value="${c.companyId}">${c.companyName}</option>
              </c:forEach>
            </select>
          </div>
          <div class="form-group">
            <label for="departmentId">부서</label>
            <select class="custom-select" id="departmentId">
              <option>선택하세요</option>
            </select>
          </div> -->

          <label for="companySelect">회사 *</label>
          <select
            id="companySelect"
            name="companyId"
            required
            onchange="loadDepts(this.value)"
            class="custom-select"
          >
            <option value="">-- 회사 선택 --</option>
            <c:forEach var="c" items="${companyList}">
              <option value="${c.companyId}">${c.companyName}</option>
            </c:forEach>
          </select>

          <label for="departmentId">부서 *</label>
          <select
            class="custom-select"
            name="departmentId"
            id="departmentId"
            required
          >
            <option value="">-- 부서 선택 --</option>
          </select>
          <div class="form-group error">
            <label for="email">이메일</label>
            <input
              id="email"
              type="email"
              class="border-input"
              placeholder="example@example.com"
              name="usersEmail"
            />
            <div class="border-error">올바른 이메일 주소를 입력해 주세요</div>
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
            <input
              id="password2"
              type="password"
              class="border-input"
              placeholder="비밀번호를 한번 더 입력해주세요"
            />
            <!-- <div class="border-error">비밀번호가 동일하지 않습니다</div> -->
          </div>
          <div class="form-group">
            <label for="nickname">닉네임</label>
            <input
              id="nickname"
              type="text"
              class="border-input"
              placeholder="2~16자 이내로 입력해주세요"
              name="usersNickname"
            />
            <!-- <div class="border-error">
            한글/영문/숫자 혼합 2~16자만 사용 가능합니다
          </div> -->
          </div>
          <div class="form-group">
            <label for="name">이름</label>
            <input
              id="name"
              type="text"
              class="border-input"
              placeholder="이름을 입력해주세요"
              name="usersName"
            />
            <!-- <div class="border-error">
            한글/영문/숫자 혼합 2~16자만 사용 가능합니다
          </div> -->
          </div>
          <div class="form-group">
            <label for="phone">휴대폰 번호</label>
            <input
              id="phone"
              type="tel"
              class="border-input"
              placeholder="'-'를 제외한 숫자만 입력해주세요"
              name="usersTel"
            />
            <!-- <div class="border-error">올바른 휴대폰 번호를 입력해 주세요</div> -->
          </div>
          <div class="form-group">
            <label for="birth">생년월일</label>
            <input
              id="birth"
              type="date"
              class="border-input"
              name="usersBirth"
            />
            <!-- <div class="border-error">
            한글/영문/숫자 혼합 2~16자만 사용 가능합니다
          </div> -->
          </div>
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

          <!-- Hidden Fields -->
          <input
            type="hidden"
            id="usersProfile"
            name="usersProfile"
            value="https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800"
          />
          <input type="hidden" name="usersPoint" value="0" />
          <input type="hidden" name="usersLoginType" value="native" />
          <input type="hidden" name="usersStatus" value="active" />
        </form>
      </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/validateInput.js"></script>
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
    <script src="${pageContext.request.contextPath}/js/validateInput.js"></script>

    <script>
      // Context Path를 JavaScript에서 사용할 수 있도록 설정
      var contextPath = "${pageContext.request.contextPath}"; // context path
    </script>
    <script src="${pageContext.request.contextPath}/js/urlConstants.js"></script>
    <script src="${pageContext.request.contextPath}/js/popup.js"></script>
    <script src="${pageContext.request.contextPath}/js/s3Upload.js"></script>
    <script>
      /**
       * 프로필 이미지 업로드 처리 (s3Upload.js와 호환)
       */
      async function handleProfileImageUpload(input) {
        if (!input.files || !input.files[0]) return;

        const file = input.files[0];

        try {
          // 로딩 UI 표시
          showUploadProgress(true);

          // S3 업로드 실행 (s3Upload.js의 s3Uploader 사용)
          const s3Url = await s3Uploader.uploadProfileImage(
            file,
            function (progress) {
              updateUploadProgress(progress);
            }
          );

          // 업로드 성공 후 미리보기 업데이트
          const reader = new FileReader();
          reader.onload = function (e) {
            updateProfilePreview(e.target.result);
          };
          reader.readAsDataURL(file);

          // 업로드 성공 - hidden input에 S3 URL 저장
          document.getElementById("usersProfile").value = s3Url;
        } catch (error) {
          console.error("프로필 이미지 업로드 실패:", error);
          showWarningPopup("프로필 이미지 업로드에 실패했습니다: " + error.message);

          // 원래 이미지로 복원
          updateProfilePreview(
            "https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800"
          );
        } finally {
          // 2초 후 진행률 숨김
          setTimeout(() => {
            showUploadProgress(false);
          }, 2000);
        }
      }

      // ajax 로 회사 선택 후 부서 리스트 조회
      function loadDepts(companyId) {
        const deptSelect = document.getElementById("departmentId");
        deptSelect.innerHTML = `<option value="">-- 부서 선택 --</option>`;

        if (!companyId) return;

        fetch(contextPath + "/user/login/company/depts?companyId=" + companyId)
          .then((res) => res.json())
          .then((data) => {
            data.forEach((dept) => {
              const option = document.createElement("option");
              option.value = dept.departmentId;
              option.text = dept.departmentName;
              deptSelect.appendChild(option);
            });
          })
          .catch((error) => {
            showWarningPopup("부서 목록을 불러오지 못했습니다.");
          });
      }

      $(function () {
        applyPhoneHyphen("#phone");
      });
    </script>
  </body>
</html>
