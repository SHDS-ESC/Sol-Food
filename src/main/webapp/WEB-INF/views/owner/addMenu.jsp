<%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 25. 6. 19.
  Time: 오후 4:29
  To change this template use File | Settings | File Templates.
--%><%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 25. 6. 19.
  Time: 오전 9:19
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sol Food - 레스토랑 관리</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <!-- 카카오맵 API -->
  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=8f9034d6cf1da650e02b54751e02fcb3&libraries=services"></script>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background: #f8f9fa;
      color: #333;
    }

    .dashboard {
      display: flex;
      height: 100vh;
    }

    /* 사이드바 */
    .sidebar {
      width: 250px;
      background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
      color: white;
      position: fixed;
      height: 100vh;
      overflow-y: auto;
      z-index: 1000;
    }

    .sidebar-header {
      padding: 20px;
      text-align: center;
      border-bottom: 1px solid rgba(255,255,255,0.1);
    }

    .sidebar-header h2 {
      font-size: 1.5rem;
      font-weight: 700;
      margin-bottom: 5px;
    }

    .sidebar-header p {
      font-size: 0.9rem;
      opacity: 0.8;
    }

    .sidebar-menu {
      list-style: none;
      padding: 20px 0;
    }

    .sidebar-menu li {
      margin: 5px 0;
    }

    .sidebar-menu a {
      display: flex;
      align-items: center;
      padding: 15px 20px;
      color: white;
      text-decoration: none;
      transition: all 0.3s ease;
      border-left: 3px solid transparent;
    }

    .sidebar-menu a:hover {
      background: rgba(255,255,255,0.1);
      border-left: 3px solid white;
    }

    .sidebar-menu a.active {
      background: rgba(255,255,255,0.2);
      border-left: 3px solid white;
    }

    .sidebar-menu a .icon {
      margin-right: 12px;
      font-size: 1.2rem;
    }

    /* 메인 콘텐츠 */
    .main-content {
      flex: 1;
      margin-left: 250px;
      display: flex;
      flex-direction: column;
    }

    /* 헤더 */
    .header {
      background: white;
      padding: 15px 30px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
      display: flex;
      justify-content: space-between;
      align-items: center;
      z-index: 999;
    }

    .header-title {
      font-size: 1.8rem;
      font-weight: 600;
      color: #333;
    }

    .header-actions {
      display: flex;
      align-items: center;
      gap: 20px;
    }

    .user-info {
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .user-avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background: linear-gradient(135deg, #4ade80, #22c55e);
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      font-weight: bold;
    }

    .user-details h4 {
      font-size: 0.9rem;
      margin-bottom: 2px;
    }

    .user-details p {
      font-size: 0.8rem;
      color: #666;
    }

    .logout-btn {
      background: #ef4444;
      color: white;
      border: none;
      padding: 8px 16px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 0.9rem;
      transition: background 0.3s ease;
    }

    .logout-btn:hover {
      background: #dc2626;
    }

    /* 콘텐츠 영역 */
    .content {
      flex: 1;
      padding: 30px 60px;
      overflow-y: auto;
    }

    .content-header {
      margin-bottom: 30px;
    }

    .content-header h1 {
      font-size: 2rem;
      margin-bottom: 10px;
    }

    .content-header p {
      color: #666;
      font-size: 1rem;
    }

    /* 상점 관리 영역 */
    .menu-actions {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 30px;
    }

    .filter-tabs {
      display: flex;
      gap: 10px;
    }

    .tab-btn {
      padding: 8px 16px;
      border: 1px solid #ddd;
      background: white;
      border-radius: 20px;
      cursor: pointer;
      transition: all 0.3s ease;
      font-size: 0.9rem;
    }

    .tab-btn.active {
      background: #22c55e;
      color: white;
      border-color: #22c55e;
    }

    .add-menu-btn {
      background: #22c55e;
      color: white;
      border: none;
      padding: 12px 24px;
      border-radius: 8px;
      cursor: pointer;
      font-size: 1rem;
      display: flex;
      align-items: center;
      gap: 8px;
      transition: background 0.3s ease;
    }

    .add-menu-btn:hover {
      background: #16a34a;
    }

    /* 상점 그리드 */
    .menu-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
      gap: 20px;
    }

    .menu-card {
      background: white;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .menu-card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 16px rgba(0,0,0,0.15);
    }

    .menu-image {
      width: 100%;
      height: 200px;
      object-fit: cover;
    }

    .menu-info {
      padding: 20px;
    }

    .menu-name {
      font-size: 1.2rem;
      font-weight: 600;
      margin-bottom: 8px;
    }

    .menu-description {
      color: #666;
      font-size: 0.9rem;
      margin-bottom: 15px;
      line-height: 1.4;
    }

    .menu-price {
      font-size: 1.3rem;
      font-weight: 700;
      color: #22c55e;
      margin-bottom: 15px;
    }

    .menu-actions-card {
      display: flex;
      gap: 10px;
    }

    .edit-btn, .delete-btn {
      flex: 1;
      padding: 8px 12px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 0.9rem;
      transition: all 0.3s ease;
    }

    .edit-btn {
      background: #3b82f6;
      color: white;
    }

    .edit-btn:hover {
      background: #2563eb;
    }

    .delete-btn {
      background: #ef4444;
      color: white;
    }

    .delete-btn:hover {
      background: #dc2626;
    }

    /* 모달 */
    .modal {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0,0,0,0.5);
      z-index: 2000;
    }

    .modal-content {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      background: white;
      padding: 30px;
      border-radius: 12px;
      width: 90%;
      max-width: 800px;
      max-height: 90vh;
      overflow-y: auto;
    }

    .modified-content {
    }

    .modal-header {
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 1px solid #eee;
    }

    .modal-header h3 {
      font-size: 1.5rem;
      margin-bottom: 5px;
    }

    .form-group {
      margin-bottom: 20px;
    }

    .form-group.address input{
      width: inherit;
      margin-bottom:8px;
    }

    .form-group label {
      display: block;
      margin-bottom: 8px;
      font-weight: 600;
      color: #333;
    }

    .form-group input,
    .form-group textarea {
      width: 100%;
      padding: 12px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 1rem;
      transition: border-color 0.3s ease;
    }

    .form-group input:focus,
    .form-group textarea:focus {
      outline: none;
      border-color: #22c55e;
    }

    .form-group textarea {
      height: 100px;
      resize: vertical;
    }

    .modal-actions {
      display: flex;
      gap: 10px;
      justify-content: flex-end;
      margin-top: 20px;
    }

    .btn-cancel, .btn-save {
      padding: 10px 20px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 1rem;
      transition: all 0.3s ease;
    }

    .btn-cancel {
      background: #6b7280;
      color: white;
    }

    .btn-cancel:hover {
      background: #4b5563;
    }

    .btn-save {
      background: #22c55e;
      color: white;
    }

    .btn-save:hover {
      background: #16a34a;
    }

    .breadcrumb{display: block; color: #666; }

    #preview {padding: 10px; border-radius: 6px; border:1px solid #ddd; display: none }
    #preview img{width: 100%}

    #storeImagePreview{max-width: 700px}
    #menuImagePreview{max-width: 700px}

    /* 메뉴 옵션 스타일 (editMenu.jsp와 동일하게 복사) */
    .menu-options-container {
      border: 1px solid #ddd;
      border-radius: 8px;
      padding: 20px;
      background: #f9f9f9;
    }
    .options-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 1px solid #eee;
    }
    .options-description {
      flex: 1;
      margin-right: 20px;
    }
    .options-description h4 {
      margin: 0 0 8px 0;
      color: #333;
      font-size: 1.1rem;
    }
    .options-description p {
      margin: 0 0 12px 0;
      color: #666;
      font-size: 0.9rem;
    }
    .btn-add-option {
      background: #22c55e;
      color: white;
      border: none;
      padding: 8px 16px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 0.9rem;
      transition: background 0.3s ease;
    }
    .btn-add-option:hover {
      background: #16a34a;
    }
    .option-group {
      background: white;
      border: 1px solid #ddd;
      border-radius: 8px;
      padding: 20px;
      margin-bottom: 20px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    .option-group-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 1px solid #eee;
    }
    .option-group-title {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }
    .group-number {
      font-weight: 600;
      color: #333;
      font-size: 1rem;
    }
    .group-help {
      font-size: 0.8rem;
      color: #666;
      font-weight: normal;
    }
    .btn-remove-group {
      background: #ef4444;
      color: white;
      border: none;
      padding: 4px 8px;
      border-radius: 4px;
      cursor: pointer;
      font-size: 0.8rem;
      transition: background 0.3s ease;
    }
    .btn-remove-group:hover {
      background: #dc2626;
    }
    .option-group-content {
      margin-bottom: 20px;
    }
    .form-row {
      display: grid;
      grid-template-columns: 1fr 1fr 1fr;
      gap: 20px;
      margin-bottom: 15px;
    }
    .form-field {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }
    .form-field label {
      font-weight: 600;
      color: #333;
      font-size: 0.9rem;
    }
    .form-field input,
    .form-field select {
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 6px;
      font-size: 0.9rem;
      transition: border-color 0.3s ease;
    }
    .form-field input:focus,
    .form-field select:focus {
      outline: none;
      border-color: #22c55e;
      box-shadow: 0 0 0 2px rgba(34, 197, 94, 0.1);
    }
    .form-field small {
      font-size: 0.75rem;
      color: #666;
      line-height: 1.3;
    }
    .option-actions {
      display: flex;
      justify-content: flex-end;
      margin-top: 10px;
    }
    .option-item {
      background: #f8f9fa;
      border: 1px solid #e9ecef;
      border-radius: 8px;
      padding: 15px;
      margin-bottom: 15px;
    }
    .option-item-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 15px;
      padding-bottom: 10px;
      border-bottom: 1px solid #e9ecef;
    }
    .option-item-title {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }
    .item-number {
      font-weight: 600;
      font-size: 0.9rem;
      color: #495057;
    }
    .item-help {
      font-size: 0.75rem;
      color: #6c757d;
      font-weight: normal;
    }
    .btn-remove-option {
      background: #dc3545;
      color: white;
      border: none;
      padding: 2px 6px;
      border-radius: 3px;
      cursor: pointer;
      font-size: 0.7rem;
      transition: background 0.3s ease;
    }
    .btn-remove-option:hover {
      background: #c82333;
    }
    .option-item-content {
      margin-top: 10px;
    }
    .option-item-content .form-row {
      grid-template-columns: 1fr 1fr;
      gap: 15px;
    }
    .btn-add-option-item {
      background: #6c757d;
      color: white;
      border: none;
      padding: 6px 12px;
      border-radius: 4px;
      cursor: pointer;
      font-size: 0.8rem;
      transition: background 0.3s ease;
    }
    .btn-add-option-item:hover {
      background: #5a6268;
    }

  </style>
</head>
<c:if test="${not empty msg}">
  <script>
    alert("${msg}");
  </script>
</c:if>
<body>
<div class="dashboard">
  <!-- 사이드바 -->
  <nav class="sidebar">
    <div class="sidebar-header">
      <h2>🍽️ <c:out value="${restaurantName}" default="Sol Food"/></h2>
      <p>레스토랑 관리 시스템</p>
    </div>
    <ul class="sidebar-menu">
      <li>
        <a href="<c:url value="/owner/store" />" data-tab="store" data-tab="overview" >
          <span class="icon">📅</span>
          <span>상점 관리</span>
        </a>
      </li>
      <li>
        <a href="<c:url value="/owner/menu" />" data-tab="menu" class="active">
          <span class="icon">🍽️</span>
          <span>메뉴 관리</span>
        </a>
      </li>
      <li>
        <a href="#" >
          <span class="icon">📊</span>
          <span>매출 관리</span>
        </a>
      </li>
      <li>
        <a href="#" data-tab="testimonials">
          <span class="icon">💬</span>
          <span>리뷰 관리</span>
        </a>
      </li>
      <li>
        <a href="#" data-tab="faq">
          <span class="icon">❓</span>
          <span>FAQ</span>
        </a>
      </li>
    </ul>
  </nav>

  <!-- 메인 콘텐츠 -->
  <main class="main-content">
    <!-- 헤더 -->
    <header class="header">
      <h1 class="header-title"></h1>
      <div class="header-actions">
        <div class="user-info">
          <div class="user-avatar">관</div>
          <div class="user-details">
            <h4>${ownerLoginSession.ownerEmail}</h4>
            <p>레스토랑 오너</p>
          </div>
        </div>
        <button class="logout-btn" onclick="logout()">로그아웃</button>
      </div>
    </header>

    <!-- 콘텐츠 영역 -->
    <section class="content">
      <div class="content-header">
        <span class="breadcrumb">🏠 메뉴 관리 > 메뉴 등록</span>
        <h1>메뉴 관리</h1>
        <p>메뉴 정보를 등록할 수 있습니다 </p>
      </div>

      <div class="menu-content">
        <form id="menuForm" action="/solfood/owner/menu/add" method="post" enctype="multipart/form-data">
          <div class="form-group">
            <label for="menuName">메뉴명</label>
            <input type="text" id="menuName" name="menuName" required>
          </div>
          <div class="form-group">
            <label for="menuPrice">가격</label>
            <input type="text" id="menuPrice" name="menuPrice" required>
          </div>

          <div class="form-group">
            <label for="menuIntro">메뉴 설명</label>
            <input type="text" id="menuIntro" name="menuIntro" required>
          </div>

          <!-- 메뉴 추가 옵션 섹션 -->
          <div class="form-group">
            <label>메뉴 추가 옵션</label>
            <div class="menu-options-container">
              <div class="options-header">
                <div class="options-description">
                  <h4>🍽️ 메뉴 옵션 설정</h4>
                  <p>고객이 메뉴 주문 시 선택할 수 있는 옵션들을 설정하세요.</p>
                </div>
                <button type="button" class="btn-add-option" id="addOptionGroupBtn">
                  <span>➕ 옵션 그룹 추가</span>
                </button>
              </div>
              <div id="optionsContainer">
                <!-- 옵션 그룹들이 여기에 동적으로 추가됩니다 -->
              </div>
            </div>
            <input type="hidden" id="menuExtraHidden" name="menuExtra" value="">
          </div>

          <div class="form-group">
            <!-- 파일 선택 버튼 (label) -->
            <label for="menuMainimage">메뉴 이미지</label>
            <input type="hidden" name="menuMainimage" id="menuMainimageId" >
            <label for="menuMainimage" class="btn-cancel" style="display: inline-block; color: #fff; font-weight: 400">파일 선택</label>
            <input class="btn-cancel" accept="image/*" type="file" id="menuMainimage" onchange="previewmenuMainimage(event)" style="display: none">

          </div>
          <div id="preview">
            <img id="storeImagePreview" src="" alt="">
            <button type="button" class="btn-cancel" id="deleteImageBtn" onclick="deleteImagePreview()" style="display:none; margin-top: 10px;">이미지 삭제</button>
          </div>

          <div class="modal-actions">
            <button type="button" class="btn-cancel" onclick="location.href='/solfood/owner/menu'">취소</button>
            <button type="submit" class="btn-save">저장</button>
          </div>
        </form>
      </div>
    </section>
  </main>

</div>

<script src="${pageContext.request.contextPath}/js/urlConstants.js"></script>
<script src="${pageContext.request.contextPath}/js/s3Upload.js"></script>
<script>
  function logout(){
    if(confirm("로그아웃 하시겠습니까?😊")){
      window.location.href="/solfood/owner/logout";
    }
  }

  // ---------------------------- 대표이미지 미리보기 -------------------------------------
  async function previewmenuMainimage(event){

    let files = event.target.files; // 파일 선택 input 에서 선택된 파일 리스트 가져오기
    let reader = new FileReader(); // 파일을 읽기 위한 fileReader 객체 생성
    reader.onload = function (e){ // 파일 읽기가 완료 됐을 때 실행할 함수 정의
      let img = document.getElementById("storeImagePreview"); // 미리보기 태그
      img.setAttribute('src',e.target.result); // src 속성 설정

      document.getElementById("preview").style.display = "block";
      document.getElementById("deleteImageBtn").style.display = "block"; // 삭제버튼 표시
    }

    const file = files[0]; // ✅ 이 줄이 꼭 필요합니다!

    reader.readAsDataURL(files[0]); // 첫번째 파일을 인코딩으로 읽기

    // S3 업로드 실행 (s3Upload.js의 s3Uploader 사용)
    const s3Url = await s3Uploader.uploadProfileImage(file, function(progress) {
      updateUploadProgress(progress);
    });

    // 업로드 성공 - hidden input에 S3 URL 저장
    document.getElementById('menuMainimageId').value = s3Url;

    console.log('이미지 업로드 완료:', s3Url);


  }

  // -----------------------------대표이미지 삭제----------------------------------
  function deleteImagePreview(){
    document.getElementById("preview").style.display = "none";
    document.getElementById("storeImagePreview").src = ""; // 미리보기 제거
    document.getElementById("menuMainimage").value = ""; // 파일 input 초기화
    document.getElementById("deleteImageBtn").style.display = "none"; // 미리보기 태그
  }

  // 메뉴 옵션 관련 변수
  let optionGroupCounter = 0;
  let optionItemCounter = 0;

  function addOptionGroup() {
    optionGroupCounter++;
    const groupId = 'optionGroup_' + optionGroupCounter;
    const groupHtml =
      '<div class="option-group" id="' + groupId + '">' +
        '<div class="option-group-header">' +
          '<div class="option-group-title">' +
            '<span class="group-number">옵션 그룹</span>' +
            '<span class="group-help">ℹ️ 고객이 선택할 옵션 그룹을 설정하세요</span>' +
          '</div>' +
          '<button type="button" class="btn-remove-group" data-group-id="' + groupId + '">🗑️ 그룹 삭제</button>' +
        '</div>' +
        '<div class="option-group-content">' +
          '<div class="form-row">' +
            '<div class="form-field">' +
              '<label>📝 그룹명</label>' +
              '<input type="text" class="group-name" placeholder="예: 사이드 선택, 맛 선택, 토핑 추가" onchange="updateMenuExtra()">' +
              '<small>고객에게 표시될 옵션 그룹의 이름입니다.</small>' +
            '</div>' +
            '<div class="form-field">' +
              '<label>⚡ 필수 여부</label>' +
              '<select class="group-required" onchange="updateMenuExtra()">' +
                '<option value="false">선택사항 (고객이 선택하지 않아도 됨)</option>' +
                '<option value="true">필수선택 (반드시 선택해야 함)</option>' +
              '</select>' +
              '<small>필수선택으로 설정하면 고객이 반드시 하나 이상 선택해야 주문이 가능합니다.</small>' +
            '</div>' +
            '<div class="form-field">' +
              '<label>🔢 최대 선택 개수</label>' +
              '<input type="number" class="group-max" min="1" value="1" onchange="updateMenuExtra()">' +
              '<small>고객이 이 그룹에서 최대 몇 개까지 선택할 수 있는지 설정합니다.</small>' +
            '</div>' +
          '</div>' +
          '<div class="option-actions">' +
            '<button type="button" class="btn-add-option-item" data-group-id="' + groupId + '">' +
              '<span>➕ 옵션 추가</span>' +
            '</button>' +
          '</div>' +
        '</div>' +
        '<div class="option-items" id="optionItems_' + groupId + '">' +
          '<!-- 옵션 아이템들이 여기에 추가됩니다 -->' +
        '</div>' +
      '</div>';
    const container = document.getElementById('optionsContainer');
    if (container) {
      container.insertAdjacentHTML('beforeend', groupHtml);
      const groupElement = document.getElementById(groupId);
      if (groupElement) {
        const removeGroupBtn = groupElement.querySelector('.btn-remove-group');
        const addOptionBtn = groupElement.querySelector('.btn-add-option-item');
        if (removeGroupBtn) {
          removeGroupBtn.addEventListener('click', function() {
            removeOptionGroup(groupId);
          });
        }
        if (addOptionBtn) {
          addOptionBtn.addEventListener('click', function() {
            addOptionItem(groupId);
          });
        }
      }
    }
  }

  function removeOptionGroup(groupId) {
    const element = document.getElementById(groupId);
    if (element) {
      element.remove();
      updateMenuExtra();
    }
  }

  function addOptionItem(groupId) {
    optionItemCounter++;
    const itemId = 'optionItem_' + optionItemCounter;
    const itemHtml =
      '<div class="option-item" id="' + itemId + '">' +
        '<div class="option-item-header">' +
          '<div class="option-item-title">' +
            '<span class="item-number">옵션 ' + optionItemCounter + '</span>' +
            '<span class="item-help">고객이 선택할 수 있는 개별 옵션입니다</span>' +
          '</div>' +
          '<button type="button" class="btn-remove-option" data-item-id="' + itemId + '">🗑️ 삭제</button>' +
        '</div>' +
        '<div class="option-item-content">' +
          '<div class="form-row">' +
            '<div class="form-field">' +
              '<label>🍽️ 옵션명</label>' +
              '<input type="text" class="option-name" placeholder="예: 감자튀김, 매운맛, 치즈 추가" onchange="updateMenuExtra()">' +
              '<small>고객에게 표시될 옵션의 이름입니다.</small>' +
            '</div>' +
            '<div class="form-field">' +
              '<label>💰 추가 가격</label>' +
              '<input type="number" class="option-price" placeholder="0" value="0" onchange="updateMenuExtra()">' +
              '<small>이 옵션을 선택했을 때 추가되는 가격입니다. (0원이면 무료)</small>' +
            '</div>' +
          '</div>' +
        '</div>' +
      '</div>';
    const container = document.getElementById('optionItems_' + groupId);
    if (container) {
      container.insertAdjacentHTML('beforeend', itemHtml);
      const itemElement = document.getElementById(itemId);
      if (itemElement) {
        const removeOptionBtn = itemElement.querySelector('.btn-remove-option');
        if (removeOptionBtn) {
          removeOptionBtn.addEventListener('click', function() {
            removeOptionItem(itemId);
          });
        }
      }
    }
  }

  function removeOptionItem(itemId) {
    const element = document.getElementById(itemId);
    if (element) {
      element.remove();
      updateMenuExtra();
    }
  }

  function updateMenuExtra() {
    try {
      const optionGroups = document.querySelectorAll('.option-group');
      const menuExtraData = [];
      optionGroups.forEach((group, groupIndex) => {
        const groupNameElement = group.querySelector('.group-name');
        const groupRequiredElement = group.querySelector('.group-required');
        const groupMaxElement = group.querySelector('.group-max');
        if (!groupNameElement || !groupRequiredElement || !groupMaxElement) {
          return;
        }
        const groupName = groupNameElement.value;
        const groupRequired = groupRequiredElement.value === 'true';
        const groupMax = parseInt(groupMaxElement.value) || 1;
        if (groupName.trim() === '') return;
        const options = [];
        const optionItems = group.querySelectorAll('.option-item');
        optionItems.forEach((item) => {
          const optionNameElement = item.querySelector('.option-name');
          const optionPriceElement = item.querySelector('.option-price');
          if (!optionNameElement || !optionPriceElement) {
            return;
          }
          const optionName = optionNameElement.value;
          const optionPrice = parseInt(optionPriceElement.value) || 0;
          if (optionName.trim() !== '') {
            options.push({
              name: optionName,
              price: optionPrice
            });
          }
        });
        if (options.length > 0) {
          menuExtraData.push({
            groupName: groupName,
            required: groupRequired,
            maxSelect: groupMax,
            options: options
          });
        }
      });
      const menuExtraElement = document.getElementById('menuExtraHidden');
      if (menuExtraElement) {
        menuExtraElement.value = JSON.stringify(menuExtraData);
      }
    } catch (error) {
      // 에러 무시
    }
  }

  // 폼 제출 시 옵션 데이터 업데이트
  document.addEventListener('DOMContentLoaded', function() {
    const menuForm = document.getElementById('menuForm');
    if (menuForm) {
      menuForm.addEventListener('submit', function(e) {
        updateMenuExtra();
      });
    }
    
    // 옵션 그룹 추가 버튼 이벤트 리스너
    const addOptionGroupBtn = document.getElementById('addOptionGroupBtn');
    if (addOptionGroupBtn) {
      addOptionGroupBtn.addEventListener('click', addOptionGroup);
    }
  });


</script>
</body>
</html>
