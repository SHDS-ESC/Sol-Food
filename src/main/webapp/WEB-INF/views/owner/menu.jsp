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
<html>
<head>
  <title>Title</title>
</head>
<body>

</body>
</html>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sol Food - 레스토랑 관리</title>
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

    /* 메뉴 관리 영역 */
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

    /* 메뉴 그리드 */
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
      max-width: 500px;
      max-height: 90vh;
      overflow-y: auto;
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
        <a href="#" data-tab="menu" class="active">
          <span class="icon">🍽️</span>
          <span>메뉴 관리</span>
        </a>
      </li>
      <%--<li>
        <a href="#" data-tab="orders">
          <span class="icon">📋</span>
          <span>예약 관리</span>
        </a>
      </li>--%>
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
        <span class="breadcrumb">🏠 메뉴 관리</span>
        <h1>메뉴 관리</h1>
        <p>상점의 메뉴를 추가, 수정, 삭제할 수 있습니다.</p>
      </div>

      <div class="menu-actions">
        <div class="filter-tabs">
        </div>
<%--        <button class="add-menu-btn" onclick="openAddModal()">--%>
        <button class="add-menu-btn"   onclick = "location.href = 'menu/add' ">
          <span>➕</span>
          메뉴 추가
        </button>
      </div>


        <div class="menu-grid" id="menuGrid">
<%--          <div class="menu-card">--%>
<%--            <img src="https://images.unsplash.com/photo-1590301157890-4810ed352733?w=300&amp;h=200&amp;fit=crop" alt="불고기 정식" class="menu-image" onerror="this.src='https://via.placeholder.com/300x200/22c55e/ffffff?text=%EB%B6%88%EA%B3%A0%EA%B8%B0%20%EC%A0%95%EC%8B%9D'">--%>
<%--            <div class="menu-info">--%>
<%--              <div class="menu-name">불고기 정식</div>--%>
<%--              <div class="menu-description">부드러운 한우 불고기와 다양한 반찬</div>--%>
<%--              <div class="menu-price">₩15,000</div>--%>
<%--            </div>--%>
<%--          </div>--%>

<%--          <div class="menu-card">--%>
<%--            <img src="https://images.unsplash.com/photo-1596797038530-2c107229654b?w=300&amp;h=200&amp;fit=crop" alt="된장찌개" class="menu-image" onerror="this.src='https://via.placeholder.com/300x200/22c55e/ffffff?text=%EB%90%9C%EC%9E%A5%EC%B0%8C%EA%B0%9C'">--%>
<%--            <div class="menu-info">--%>
<%--              <div class="menu-name">된장찌개</div>--%>
<%--              <div class="menu-description">깊은 맛의 전통 된장찌개</div>--%>
<%--              <div class="menu-price">₩8,000</div>--%>
<%--            </div>--%>
<%--          </div>--%>


<%--          <div class="menu-card">--%>
<%--            <img src="https://images.unsplash.com/photo-1564834724105-918b73d1b9e0?w=300&amp;h=200&amp;fit=crop" alt="제육볶음" class="menu-image" onerror="this.src='https://via.placeholder.com/300x200/22c55e/ffffff?text=%EC%A0%9C%EC%9C%A1%EB%B3%B6%EC%9D%8C'">--%>
<%--            <div class="menu-info">--%>
<%--              <div class="menu-name">잡채</div>--%>
<%--              <div class="menu-description">매콤하고 달콤한 잡채</div>--%>
<%--              <div class="menu-price">₩12,000</div>--%>
<%--            </div>--%>
<%--          </div>--%>

<%--          <div class="menu-card">--%>
<%--            <img src="https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=300&amp;h=200&amp;fit=crop" alt="순두부찌개" class="menu-image" onerror="this.src='https://via.placeholder.com/300x200/22c55e/ffffff?text=%EC%88%9C%EB%91%90%EB%B6%80%EC%B0%8C%EA%B0%9C'">--%>
<%--            <div class="menu-info">--%>
<%--              <div class="menu-name">순두부찌개</div>--%>
<%--              <div class="menu-description">부드러운 순두부와 해산물</div>--%>
<%--              <div class="menu-price">₩8,500</div>--%>
<%--            </div>--%>
<%--          </div>--%>

<%--          <div class="menu-card">--%>
<%--            <img src="https://images.unsplash.com/photo-1498654896293-37aacf113fd9?w=300&amp;h=200&amp;fit=crop" alt="비빔밥" class="menu-image" onerror="this.src='https://via.placeholder.com/300x200/22c55e/ffffff?text=%EB%B9%84%EB%B9%94%EB%B0%A5'">--%>
<%--            <div class="menu-info">--%>
<%--              <div class="menu-name">비빔밥</div>--%>
<%--              <div class="menu-description">신선한 나물과 고추장 양념</div>--%>
<%--              <div class="menu-price">₩10,000</div>--%>
<%--            </div>--%>
<%--          </div>--%>

          <c:forEach var="item" items="${menu}">
            <div class="menu-card" onclick="location.href = 'menu/edit?menuId=${item.menuId}'">

              <c:if test="${not empty item.menuMainimage}">
                <img src="${item.menuMainimage}" class="menu-image" >
              </c:if>
              <c:if test="${!not empty item.menuMainimage}">
                <img src="https://cdn.spectory.net/src/images/noImg.gif" class="menu-image" >
              </c:if>
               <div class="menu-info">
                <div class="menu-name">${item.menuName}</div>
                <div class="menu-description">${item.menuIntro}</div>
                <div class="menu-price">₩${item.menuPrice}</div>
              </div>
            </div>
          </c:forEach>

        </div>

    </section>
  </main>

</div>

<!-- 메뉴 추가/수정 모달 -->
<div class="modal" id="menuModal">
  <div class="modal-content">
    <div class="modal-header">
      <h3 id="modalTitle">메뉴 추가</h3>
      <p>새로운 메뉴 정보를 입력해주세요.</p>
    </div>
    <form id="menuForm">
      <div class="form-group">
        <label for="menuName">메뉴명</label>
        <input type="text" id="menuName" name="menuName" required>
      </div>
      <div class="form-group">
        <label for="menuDescription">메뉴 설명</label>
        <textarea id="menuDescription" name="menuDescription" required></textarea>
      </div>
      <div class="form-group">
        <label for="menuPrice">가격</label>
        <input type="number" id="menuPrice" name="menuPrice" min="0" step="1000" required>
      </div>
      <div class="form-group">
        <label for="menuImage">이미지 URL</label>
        <input type="url" id="menuImage" name="menuImage">
      </div>
      <div class="form-group">
        <label for="menuCategory">카테고리</label>
        <select id="menuCategory" name="menuCategory" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px;">
          <option value="main">메인 요리</option>
          <option value="soup">국물 요리</option>
          <option value="side">사이드 메뉴</option>
          <option value="dessert">디저트</option>
          <option value="drink">음료</option>
        </select>
      </div>
      <div class="modal-actions">
        <button type="button" class="btn-cancel" onclick="closeModal()">취소</button>
        <button type="submit" class="btn-save">저장</button>
      </div>
    </form>
  </div>
</div>

<script>
  function logout() {
    if (confirm("로그아웃 하시겠습니까?😊")) {
      window.location.href = "/solfood/owner/logout";
    }
  }
  let editingMenuId = null;

  // 페이지 로드
  document.addEventListener('DOMContentLoaded', function() {
    setupEventListeners();
  });


  // 이벤트 리스너 설정
  function setupEventListeners() {


    // 메뉴 폼 제출
    document.getElementById('menuForm').addEventListener('submit', function(e) {
      e.preventDefault();
      saveMenu();
    });
  }

  // 메뉴 추가 모달 열기
  // function openAddModal() {
  //   editingMenuId = null;
  //   document.getElementById('modalTitle').textContent = '메뉴 추가';
  //   document.getElementById('menuForm').reset();
  //   document.getElementById('menuModal').style.display = 'block';
  // }


  // 메뉴 저장
  function saveMenu() {
    const formData = new FormData(document.getElementById('menuForm'));
    const menuData = {
      name: formData.get('menuName'),
      description: formData.get('menuDescription'),
      price: parseInt(formData.get('menuPrice')),
      image: formData.get('menuImage') || 'https://via.placeholder.com/300x200/22c55e/ffffff?text=' + encodeURIComponent(formData.get('menuName')),
      category: formData.get('menuCategory')
    };

    if (editingMenuId) {
      // 수정
      const index = menus.findIndex(m => m.id === editingMenuId);
      if (index !== -1) {
        menus[index] = { ...menus[index], ...menuData };
      }
    } else {
      // 추가
      const newId = Math.max(...menus.map(m => m.id)) + 1;
      menus.push({ id: newId, ...menuData });
    }

    closeModal();
  }

  // 모달 닫기
  function closeModal() {
    document.getElementById('menuModal').style.display = 'none';
    editingMenuId = null;
  }


 

</script>
</body>
</html>
