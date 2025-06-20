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

->

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
      padding: 30px;
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

    /* 주문 사이드바 (오른쪽) */
    .order-sidebar {
      width: 300px;
      background: white;
      border-left: 1px solid #eee;
      padding: 20px;
      position: fixed;
      right: 0;
      top: 0;
      height: 100vh;
      overflow-y: auto;
      z-index: 999;
    }

    .order-header {
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 1px solid #eee;
    }

    .order-header h3 {
      font-size: 1.2rem;
      margin-bottom: 5px;
    }

    .order-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 10px 0;
      border-bottom: 1px solid #f0f0f0;
    }

    .order-item:last-child {
      border-bottom: none;
    }

    .order-total {
      margin-top: 20px;
      padding-top: 15px;
      border-top: 2px solid #eee;
      font-size: 1.2rem;
      font-weight: 600;
    }

    .checkout-btn {
      width: 100%;
      background: #22c55e;
      color: white;
      border: none;
      padding: 15px;
      border-radius: 8px;
      font-size: 1rem;
      font-weight: 600;
      cursor: pointer;
      margin-top: 20px;
      transition: background 0.3s ease;
    }

    .checkout-btn:hover {
      background: #16a34a;
    }

    /* 반응형 */
    @media (max-width: 768px) {
      .main-content {
        margin-left: 0;
      }

      .sidebar {
        transform: translateX(-100%);
        transition: transform 0.3s ease;
      }

      .sidebar.active {
        transform: translateX(0);
      }

      .order-sidebar {
        display: none;
      }

      .menu-grid {
        grid-template-columns: 1fr;
      }
    }
  </style>
</head>
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
        <a href="#" class="active" data-tab="overview">
          <span class="icon">📊</span>
          <span>개요</span>
        </a>
      </li>
      <li>
        <a href="#" data-tab="menu">
          <span class="icon">🍽️</span>
          <span>메뉴 관리</span>
        </a>
      </li>
      <li>
        <a href="#" data-tab="orders">
          <span class="icon">📋</span>
          <span>주문 관리</span>
        </a>
      </li>
      <li>
        <a href="#" data-tab="calendar">
          <span class="icon">📅</span>
          <span>일정 관리</span>
        </a>
      </li>
      <li>
        <a href="#" data-tab="testimonials">
          <span class="icon">💬</span>
          <span>고객 후기</span>
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
      <h1 class="header-title">메뉴 관리</h1>
      <div class="header-actions">
        <div class="user-info">
          <div class="user-avatar">관</div>
          <div class="user-details">
              <h4><c:out value="${ownerName}" default="관리자님"/></h4>
              <p>레스토랑 오너</p>
          </div>
        </div>
        <button class="logout-btn" onclick="logout()">로그아웃</button>
      </div>
    </header>

    <!-- 콘텐츠 영역 -->
    <section class="content">
      <div class="content-header">
        <h1>메뉴 관리</h1>
        <p>레스토랑 메뉴를 추가, 수정, 삭제할 수 있습니다.</p>
      </div>

      <div class="menu-actions">
        <div class="filter-tabs">
          <button class="tab-btn active" data-category="all">전체 메뉴</button>
          <button class="tab-btn" data-category="popular">인기 메뉴</button>
          <button class="tab-btn" data-category="new">신메뉴</button>
          <button class="tab-btn" data-category="discount">할인 메뉴</button>
        </div>
        <button class="add-menu-btn" onclick="openAddModal()">
          <span>➕</span>
          메뉴 추가
        </button>
      </div>

      <div class="menu-grid" id="menuGrid">
        <!-- 메뉴 카드들이 여기에 동적으로 추가됩니다 -->
      </div>
    </section>
  </main>

  <!-- 주문 사이드바 (오른쪽) -->
  <aside class="order-sidebar">
    <div class="order-header">
      <h3>My Order</h3>
      <p>📍 서울특별시 강남구</p>
    </div>
    <div id="orderItems">
      <div class="order-item">
        <div>
          <div style="font-weight: 600;">Beef soup</div>
          <div style="color: #666; font-size: 0.9rem;">1x</div>
        </div>
        <div style="font-weight: 600;">$8.99</div>
      </div>
      <div class="order-item">
        <div>
          <div style="font-weight: 600;">Noodle salad</div>
          <div style="color: #666; font-size: 0.9rem;">1x</div>
        </div>
        <div style="font-weight: 600;">$6.50</div>
      </div>
      <div class="order-item">
        <div>
          <div style="font-weight: 600;">Fried vegetables</div>
          <div style="color: #666; font-size: 0.9rem;">1x</div>
        </div>
        <div style="font-weight: 600;">$4.99</div>
      </div>
    </div>
    <div class="order-total">
      <div style="display: flex; justify-content: space-between;">
        <span>Total</span>
        <span>$15.48</span>
      </div>
    </div>
    <button class="checkout-btn">Checkout</button>
  </aside>
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
  // 메뉴 데이터
  let menus = [
    {
      id: 1,
      name: "불고기 정식",
      description: "부드러운 한우 불고기와 다양한 반찬",
      price: 15000,
      image: "https://images.unsplash.com/photo-1590301157890-4810ed352733?w=300&h=200&fit=crop",
      category: "main"
    },
    {
      id: 2,
      name: "김치찌개",
      description: "매콤달콤한 김치찌개",
      price: 9000,
      image: "https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=300&h=200&fit=crop",
      category: "soup"
    },
    {
      id: 3,
      name: "된장찌개",
      description: "깊은 맛의 전통 된장찌개",
      price: 8000,
      image: "https://images.unsplash.com/photo-1596797038530-2c107229654b?w=300&h=200&fit=crop",
      category: "soup"
    },
    {
      id: 4,
      name: "제육볶음",
      description: "매콤한 양념 돼지고기 볶음",
      price: 12000,
      image: "https://images.unsplash.com/photo-1564834724105-918b73d1b9e0?w=300&h=200&fit=crop",
      category: "main"
    },
    {
      id: 5,
      name: "순두부찌개",
      description: "부드러운 순두부와 해산물",
      price: 8500,
      image: "https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=300&h=200&fit=crop",
      category: "soup"
    },
    {
      id: 6,
      name: "비빔밥",
      description: "신선한 나물과 고추장 양념",
      price: 10000,
      image: "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?w=300&h=200&fit=crop",
      category: "main"
    }
  ];

  let editingMenuId = null;

  // 페이지 로드 시 메뉴 렌더링
  document.addEventListener('DOMContentLoaded', function() {
    renderMenus();
    setupEventListeners();
  });

  // 메뉴 렌더링
  function renderMenus(filter = 'all') {
    const menuGrid = document.getElementById('menuGrid');
    let filteredMenus = menus;

    if (filter !== 'all') {
      filteredMenus = menus.filter(menu => menu.category === filter);
    }

    menuGrid.innerHTML = filteredMenus.map(menu => `
                <div class="menu-card">
                    <img src="${menu.image}" alt="${menu.name}" class="menu-image" onerror="this.src='https://via.placeholder.com/300x200/22c55e/ffffff?text=${encodeURIComponent(menu.name)}'">
                    <div class="menu-info">
                        <div class="menu-name">${menu.name}</div>
                        <div class="menu-description">${menu.description}</div>
                        <div class="menu-price">₩${menu.price.toLocaleString()}</div>
                        <div class="menu-actions-card">
                            <button class="edit-btn" onclick="editMenu(${menu.id})">수정</button>
                            <button class="delete-btn" onclick="deleteMenu(${menu.id})">삭제</button>
                        </div>
                    </div>
                </div>
            `).join('');
  }

  // 이벤트 리스너 설정
  function setupEventListeners() {
    // 탭 버튼 클릭
    document.querySelectorAll('.tab-btn').forEach(btn => {
      btn.addEventListener('click', function() {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        renderMenus(this.dataset.category);
      });
    });

    // 사이드바 메뉴 클릭
    document.querySelectorAll('.sidebar-menu a').forEach(link => {
      link.addEventListener('click', function(e) {
        e.preventDefault();
        document.querySelectorAll('.sidebar-menu a').forEach(l => l.classList.remove('active'));
        this.classList.add('active');

        const tab = this.dataset.tab;
        const headerTitle = document.querySelector('.header-title');

        switch(tab) {
          case 'overview':
            headerTitle.textContent = '개요';
            break;
          case 'menu':
            headerTitle.textContent = '메뉴 관리';
            break;
          case 'orders':
            headerTitle.textContent = '주문 관리';
            break;
          case 'calendar':
            headerTitle.textContent = '일정 관리';
            break;
          case 'testimonials':
            headerTitle.textContent = '고객 후기';
            break;
          case 'faq':
            headerTitle.textContent = 'FAQ';
            break;
        }
      });
    });

    // 메뉴 폼 제출
    document.getElementById('menuForm').addEventListener('submit', function(e) {
      e.preventDefault();
      saveMenu();
    });
  }

  // 메뉴 추가 모달 열기
  function openAddModal() {
    editingMenuId = null;
    document.getElementById('modalTitle').textContent = '메뉴 추가';
    document.getElementById('menuForm').reset();
    document.getElementById('menuModal').style.display = 'block';
  }

  // 메뉴 수정
  function editMenu(id) {
    const menu = menus.find(m => m.id === id);
    if (!menu) return;

    editingMenuId = id;
    document.getElementById('modalTitle').textContent = '메뉴 수정';
    document.getElementById('menuName').value = menu.name;
    document.getElementById('menuDescription').value = menu.description;
    document.getElementById('menuPrice').value = menu.price;
    document.getElementById('menuImage').value = menu.image;
    document.getElementById('menuCategory').value = menu.category;
    document.getElementById('menuModal').style.display = 'block';
  }

  // 메뉴 삭제
  function deleteMenu(id) {
    if (confirm('정말로 이 메뉴를 삭제하시겠습니까?')) {
      menus = menus.filter(m => m.id !== id);
      renderMenus();
    }
  }

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
    renderMenus();
  }

  // 모달 닫기
  function closeModal() {
    document.getElementById('menuModal').style.display = 'none';
    editingMenuId = null;
  }

  // 로그아웃
  function logout() {
      if (confirm('로그아웃 하시겠습니까?')) {
      window.location.href = '${pageContext.request.contextPath}/owner/login';
    }
  }
 
  // 모달 외부 클릭 시 닫기
  window.onclick = function(event) {
    const modal = document.getElementById('menuModal');
    if (event.target === modal) {
      closeModal();
    }
  }
</script>
</body>
</html>
