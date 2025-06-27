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

    /* 프로필 이미지 업로드 스타일 */
    .profile-upload-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 12px;
      margin-top: 8px;
    }
    
    .profile-preview-container {
      position: relative;
      width: 120px;
      height: 120px;
      cursor: pointer;
      border-radius: 50%;
      overflow: hidden;
      border: 3px solid #e5e7eb;
      transition: border-color 0.2s ease;
    }
    
    .profile-preview-container:hover {
      border-color: #6366f1;
    }
    
    .profile-preview {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
    
    .profile-upload-overlay {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: rgba(0, 0, 0, 0.6);
      color: white;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      opacity: 0;
      transition: opacity 0.2s ease;
      font-size: 12px;
    }
    
    .profile-preview-container:hover .profile-upload-overlay {
      opacity: 1;
    }
    
    .camera-icon {
      font-size: 24px;
      margin-bottom: 4px;
    }
    
    .btn-upload {
      background-color: #f3f4f6;
      color: #374151;
      border: 1px solid #d1d5db;
      padding: 8px 16px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 14px;
      transition: all 0.2s ease;
    }
    
    .btn-upload:hover {
      background-color: #e5e7eb;
      border-color: #9ca3af;
    }
    
    /* 업로드 진행률 스타일 */
    .upload-progress {
      margin-top: 12px;
      text-align: center;
    }
    
    .progress-bar-container {
      width: 100%;
      height: 8px;
      background-color: #e5e7eb;
      border-radius: 4px;
      overflow: hidden;
      margin-bottom: 8px;
    }
    
    .progress-bar {
      height: 100%;
      background: linear-gradient(90deg, #6366f1, #8b5cf6);
      width: 0%;
      transition: width 0.3s ease;
    }
    
    .progress-text {
      font-size: 12px;
      color: #6b7280;
    }
  </style>
</head>
<body>
  <div class="form-container">
    <div class="form-title">회원가입</div>
    <form action="/solfood/user/login/register" method="post">
      <!-- 프로필 이미지 업로드 -->
      <label>프로필 이미지</label>
      <div class="profile-upload-container">
        <div class="profile-preview-container" onclick="document.getElementById('profileImageInput').click()">
          <img id="profilePreview" class="profile-preview"
               src="https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800"
               alt="프로필 미리보기">
          <div class="profile-upload-overlay">
            <i class="camera-icon">📷</i>
            <span>사진 변경</span>
          </div>
        </div>
        <input type="file" id="profileImageInput" accept="image/*" onchange="handleProfileImageUpload(this)" style="display: none;">
        <button type="button" class="btn-upload" onclick="document.getElementById('profileImageInput').click()">
          사진 선택
        </button>
      </div>

      <!-- 업로드 진행률 -->
      <div id="uploadProgress" class="upload-progress" style="display: none;">
        <div class="progress-bar-container">
          <div id="uploadProgressBar" class="progress-bar"></div>
        </div>
        <span id="uploadProgressText" class="progress-text">0%</span>
      </div>

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
      <input type="hidden" id="usersProfile" name="usersProfile" value="https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800">
      <input type="hidden" name="usersPoint" value="0">
      <input type="hidden" name="usersLoginType" value="native">

      <div class="form-actions">
        <button type="submit" class="btn btn-submit">가입하기</button>
        <button type="button" class="btn btn-cancel" onclick="history.back()">취소</button>
      </div>
    </form>
  </div>

<script src="${pageContext.request.contextPath}/js/s3Upload.js"></script>
<script>
  const contextPath = '${pageContext.request.contextPath}'; // 예: /solfood
  
  /**
   * 프로필 이미지 업로드 처리 (s3Upload.js와 호환)
   */
  async function handleProfileImageUpload(input) {
    if (!input.files || !input.files[0]) return;
    
    const file = input.files[0];
    
    try {
      // 로딩 UI 표시
      showUploadProgress(true);
      
      // 파일 미리보기
      const reader = new FileReader();
      reader.onload = function(e) {
        updateProfilePreview(e.target.result);
      };
      reader.readAsDataURL(file);
      
      // S3 업로드 실행 (s3Upload.js의 s3Uploader 사용)
      const s3Url = await s3Uploader.uploadProfileImage(file, function(progress) {
        updateUploadProgress(progress);
      });
      
      // 업로드 성공 - hidden input에 S3 URL 저장
      document.getElementById('usersProfile').value = s3Url;
      
      console.log('프로필 이미지 업로드 완료:', s3Url);
      
    } catch (error) {
      console.error('프로필 이미지 업로드 실패:', error);
      alert('프로필 이미지 업로드에 실패했습니다: ' + error.message);
      
      // 원래 이미지로 복원
      updateProfilePreview('https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800');
    } finally {
      // 2초 후 진행률 숨김
      setTimeout(() => {
        showUploadProgress(false);
      }, 2000);
    }
  }
  
  // ajax 로 회사 선택 후 부서 리스트 조회
  function loadDepts(companyId){
    console.log(contextPath)
    console.log(companyId);
    const deptSelect = document.getElementById("departmentId");
    deptSelect.innerHTML = `<option value="">-- 부서 선택 --</option>`;

    if (!companyId) return;

            fetch("/solfood/user/login/company/depts?companyId=" + companyId)
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
              console.log(contextPath + "/user/login/company/depts?companyId=" + companyId)
            });
  }

</script>
</body>
</html>
