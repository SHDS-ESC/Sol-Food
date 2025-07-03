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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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

    .store-detail {
      background: white;
      padding: 30px;
      border-radius: 12px;
      font-size: 18px;
      line-height: 30px;
      text-align: center;
    }

    .store-detail h2{font-size: 26px}

    .edit-btn, .delete-btn {
      padding: 8px 12px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 0.9rem;
      transition: all 0.3s ease;
      width: 100px;
      margin-right: 10px;
    }

    .edit-btn {
      background: #22c55e;
      color: white;
    }

    .edit-btn:hover {
      background: #16a34a;
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

    .yellow{display: inline-block; color: orange}
    .blue{display: inline-block; color: #0d6efd}
    .red{display: inline-block; color: darkred}

    /* 탭 관련 스타일 */
    .tab-content {
      display: none;
    }

    .tab-content.active {
      display: block;
    }

    /* 리뷰 관리 스타일 */
    .store-selector {
      background: white;
      padding: 20px;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      margin-bottom: 30px;
    }

    .store-input-group {
      display: flex;
      gap: 15px;
      align-items: end;
    }

    .search-btn {
      background: #22c55e;
      color: white;
      border: none;
      padding: 12px 24px;
      border-radius: 6px;
      cursor: pointer;
      font-size: 1rem;
      transition: background 0.3s ease;
    }

    .search-btn:hover {
      background: #16a34a;
    }

    .review-stats {
      background: white;
      padding: 20px;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      margin-bottom: 30px;
      display: none;
    }

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
    }

    .stat-card {
      text-align: center;
      padding: 15px;
      border: 1px solid #eee;
      border-radius: 8px;
    }

    .stat-value {
      font-size: 2rem;
      font-weight: 700;
      color: #22c55e;
      margin-bottom: 5px;
    }

    .stat-label {
      font-size: 0.9rem;
      color: #666;
    }

    /* 리뷰 관리 레이아웃 */
    .review-management {
      display: none;
      gap: 20px;
    }

    .review-management.active {
      display: flex;
    }

    /* 왼쪽 리뷰 목록 */
    .review-list-panel {
      flex: 1;
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      overflow: hidden;
      max-height: 600px;
    }

    .review-list-header {
      background: #f8f9fa;
      padding: 15px 20px;
      border-bottom: 1px solid #eee;
      font-weight: 600;
    }

    .review-cards {
      overflow-y: auto;
      max-height: 520px;
    }

    .review-card {
      padding: 15px 20px;
      border-bottom: 1px solid #eee;
      cursor: pointer;
      transition: background-color 0.2s ease;
      position: relative;
    }

    .review-card:hover {
      background-color: #f8f9fa;
    }

    .review-card.active {
      background-color: #e3f2fd;
      border-left: 4px solid #22c55e;
    }

    .review-card:last-child {
      border-bottom: none;
    }

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 8px;
    }

    .card-rating {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .rating-number {
      font-size: 1.1rem;
      font-weight: 700;
      color: #22c55e;
    }

    .rating-stars {
      color: #ffc107;
      font-size: 0.9rem;
    }

    .reply-status {
      width: 20px;
      height: 20px;
      border-radius: 3px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      font-weight: bold;
    }

    .reply-status.completed {
      background-color: #22c55e;
      color: white;
    }

    .reply-status.pending {
      background-color: #6b7280;
      color: white;
    }

    .card-title {
      font-weight: 600;
      margin-bottom: 5px;
      font-size: 0.95rem;
      line-height: 1.3;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .card-date {
      font-size: 0.8rem;
      color: #666;
    }

    /* 오른쪽 상세 보기 */
    .review-detail-panel {
      flex: 1;
      display: flex;
      flex-direction: column;
      gap: 20px;
    }

    .review-detail {
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      padding: 20px;
      min-height: 400px;
    }

    .detail-header {
      font-size: 1.1rem;
      font-weight: 600;
      margin-bottom: 20px;
      color: #333;
    }

    .detail-content {
      display: none;
    }

    .detail-content.active {
      display: block;
    }

    .detail-rating {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 15px;
    }

    .detail-rating-number {
      font-size: 1.3rem;
      font-weight: 700;
      color: #22c55e;
    }

    .detail-stars {
      color: #ffc107;
      font-size: 1.2rem;
    }

    .detail-meta {
      display: flex;
      justify-content: space-between;
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 1px solid #eee;
    }

    .detail-user {
      font-weight: 600;
    }

    .detail-date {
      color: #666;
      font-size: 0.9rem;
    }

    .detail-title {
      font-size: 1.1rem;
      font-weight: 600;
      margin-bottom: 10px;
    }

    .detail-text {
      line-height: 1.6;
      margin-bottom: 20px;
    }

    .detail-image {
      max-width: 100%;
      border-radius: 8px;
      margin-bottom: 20px;
    }

    .existing-reply {
      background: #f8f9fa;
      padding: 15px;
      border-radius: 8px;
      border-left: 4px solid #22c55e;
      margin-bottom: 20px;
    }

    .existing-reply-label {
      font-weight: 600;
      color: #22c55e;
      margin-bottom: 8px;
    }

    .existing-reply-actions {
      margin-top: 10px;
      display: flex;
      gap: 10px;
    }

    /* 답글 달기 */
    .reply-section {
      background: white;
      border-radius: 12px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
      padding: 20px;
    }

    .reply-header {
      font-size: 1.1rem;
      font-weight: 600;
      margin-bottom: 15px;
      color: #333;
    }

    .reply-textarea {
      width: 100%;
      padding: 12px;
      border: 1px solid #ddd;
      border-radius: 6px;
      resize: vertical;
      min-height: 100px;
      margin-bottom: 15px;
      font-family: inherit;
    }

    .reply-actions {
      display: flex;
      gap: 10px;
      justify-content: flex-end;
    }

    .btn {
      padding: 8px 16px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 0.9rem;
      transition: all 0.3s ease;
    }

    .btn-primary {
      background: #22c55e;
      color: white;
    }

    .btn-primary:hover {
      background: #16a34a;
    }

    .btn-secondary {
      background: #6b7280;
      color: white;
    }

    .btn-secondary:hover {
      background: #4b5563;
    }

    .btn-danger {
      background: #ef4444;
      color: white;
    }

    .btn-danger:hover {
      background: #dc2626;
    }

    .empty-state {
      text-align: center;
      color: #666;
      padding: 40px 20px;
    }

    .star {
      color: #ffc107;
      font-size: 1rem;
    }

    .star.empty {
      color: #ddd;
    }

    .loading {
      text-align: center;
      padding: 40px;
      color: #666;
    }

    .no-reviews {
      text-align: center;
      padding: 40px;
      color: #666;
    }

    .alert {
      padding: 12px 16px;
      border-radius: 6px;
      margin-bottom: 20px;
    }

    .alert-success {
      background: #d1fae5;
      color: #065f46;
      border: 1px solid #a7f3d0;
    }

    .alert-error {
      background: #fee2e2;
      color: #991b1b;
      border: 1px solid #fca5a5;
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
        <a href="#" data-tab="store" data-tab="overview" class="active" >
          <span class="icon">📅</span>
          <span>상점 관리</span>
        </a>
      </li>
      <li>
        <a href="<c:url value="/owner/menu" />" data-tab="menu">
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
        <a href="#" data-tab="reviews">
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
      <h1 class="header-title">상점 관리</h1>
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
        <span class="breadcrumb" id="breadcrumb">🏠 상점 관리</span>
        <h1 id="contentTitle">상점 관리</h1>
        <p id="contentDescription">상점 정보를 등록하거나 수정할 수 있습니다</p>
      </div>

      <!-- 상점 관리 탭 -->
      <div id="storeTab" class="tab-content active">
        <c:if test="${store == null}">
          <div class="menu-actions">
            <div class="filter-tabs">
            </div>
              <button class="add-menu-btn" onclick="location.href='store/add'">
                <span>➕</span>
                상점 등록
              </button>
          </div>
        </c:if>

        <div class="menu-content">
          <c:if test="${store != null}">
            <div class="store-detail">
              <h2>상점명 : ${store.storeName}</h2>
              <c:if test="${not empty store.storeMainimage}">
                <img src="${store.storeMainimage}" style="width: 100%; max-width: 600px; border-radius: 12px; margin: 20px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1)">
              </c:if>
              <c:if test="${!not empty store.storeMainimage}">
                <img src="https://cdn.spectory.net/src/images/noImg.gif" style="width: 100%; max-width: 400px; border-radius: 12px; margin: 20px 0;">
              </c:if>
              <p><strong>주소 : </strong> ${fn:replace(store.storeAddress, '|', ' ')}</p>
              <p><strong>연락처 : </strong> ${store.storeTel}</p>
              <p><strong>소개 : </strong> ${store.storeIntro}</p>
              <p><strong>승인상태 : </strong>
              <c:choose>
                <c:when test="${store.storeStatus eq '승인대기' }">
                  <span class="yellow">${store.storeStatus}</span>
                </c:when>
                <c:when test="${store.storeStatus eq '승인완료' }">
                  <span class="blue">${store.storeStatus}</span>
                </c:when>
                <c:when test="${store.storeStatus eq '승인거절' }">
                  <span class="red">${store.storeStatus}</span>
                <p><strong>거절사유 : </strong> ${store.storeRejectReason}</p>
                </c:when>
                <c:otherwise>
                  <span> ${store.storeStatus}</span>
                </c:otherwise>
              </c:choose>
              </p>
            </div>
            <div style="margin-top: 30px; justify-content: center;display: flex;align-items: center;">
              <button class="edit-btn" onclick="location.href='/solfood/owner/store/edit'">수정</button>
              <form action="/solfood/owner/store/delete" method="post" style="display:inline;">
                <input type="hidden" name="storeId" value="${store.storeId}">
                <button type="submit" class="delete-btn" onclick="return confirm('정말 삭제하시겠습니까?🥹')">삭제</button>
              </form>
            </div>
          </c:if>
        </div>
      </div>

      <!-- 리뷰 관리 탭 -->
      <div id="reviewTab" class="tab-content">
        <!-- 가게 선택 -->
        <div class="store-selector">
          <div class="store-input-group">
            <div class="form-group">
              <label for="storeId">가게 ID</label>
              <input type="number" id="storeId" placeholder="가게 ID를 입력하세요" min="1" value="${store != null ? store.storeId : ''}">
            </div>
            <button class="search-btn" onclick="loadReviews()">검색</button>
          </div>
        </div>

        <!-- 알림 메시지 -->
        <div id="alertMessage" style="display: none;"></div>

        <!-- 리뷰 통계 -->
        <div class="review-stats" id="reviewStats">
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-value" id="totalReviews">0</div>
              <div class="stat-label">총 리뷰 수</div>
            </div>
            <div class="stat-card">
              <div class="stat-value" id="averageRating">0.0</div>
              <div class="stat-label">평균 별점</div>
            </div>
          </div>
        </div>

        <!-- 리뷰 관리 레이아웃 -->
        <div class="review-management" id="reviewManagement">
          <!-- 왼쪽: 리뷰 목록 -->
          <div class="review-list-panel">
            <div class="review-list-header">
              리뷰 목록
            </div>
            <div class="review-cards" id="reviewCards">
              <!-- 리뷰 카드들이 여기에 동적으로 추가됩니다 -->
            </div>
          </div>

          <!-- 오른쪽: 상세 보기 및 답글 달기 -->
          <div class="review-detail-panel">
            <!-- 리뷰 상세 보기 -->
            <div class="review-detail">
              <div class="detail-header">리뷰 자세히 보기</div>
              <div id="reviewDetailContent" class="empty-state">
                리뷰를 선택하면 상세 내용이 표시됩니다.
              </div>
            </div>

            <!-- 답글 달기 -->
            <div class="reply-section">
              <div class="reply-header">↺ 답글 달기</div>
              <textarea id="replyTextarea" class="reply-textarea" placeholder="고객에게 답글을 작성해주세요..." disabled></textarea>
              <div class="reply-actions">
                <button id="replySubmitBtn" class="btn btn-primary" disabled onclick="submitReply()">등록</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </main>

</div>

<!-- 상점 추가/수정 모달 -->
<div class="modal" id="storeModal">
  <div class="modal-content">
    <div class="modal-header">
      <h3 id="modalTitle">상점 등록</h3>
      <p>상점 정보를 입력해주세요.</p>
    </div>
    <form id="storeForm" enctype="multipart/form-data" >
      <div class="form-group">
        <label for="storeName">상점명</label>
        <input type="text" id="storeName" name="storeName" required>
      </div>

      <div class="form-group">
        <label for="categoryId">상점 카테고리</label>
        <select id="categoryId" name="categoryId" style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px;">
          <option value="1">--카테고리 선택--</option>
          <c:forEach var="c" items="${categoryList}">
            <option value="${c.categoryId}">${c.categoryName}</option>
          </c:forEach>
        </select>
      </div>

      <div class="form-group address">
        <label for="storeAddress">상점 위치</label>
        <div class="test">
          <input type="text" id="sample3_postcode" placeholder="우편번호">
          <input type="button" onclick="sample3_execDaumPostcode()" value="우편번호 찾기" class="btn-cancel" style="padding: 9px"><br>
          <input type="text" id="sample3_address" placeholder="주소" style="width: 100%"><br>
          <input type="text" id="sample3_detailAddress" style="width: 100%" placeholder="상세주소">
          <input type="text" id="sample3_extraAddress" style="width: 100%" placeholder="참고항목">

          <div id="wrap" style="display:none;border:1px solid;width:500px;height:300px;margin:5px 0;position:relative">
            <img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap" style="cursor:pointer;position:absolute;right:0px;top:-1px;z-index:1" onclick="foldDaumPostcode()" alt="접기 버튼">
          </div>
        </div>
      </div>
      <input type="hidden" id="storeAddress" name="storeAddress">

      <div class="form-group">
        <label for="storeTel">상점 번호</label>
        <input type="text" id="storeTel" name="storeTel" required>
      </div>
      <div class="form-group">
        <label for="storeIntro">상점 소개</label>
        <input type="text" id="storeIntro" name="storeIntro" required>
      </div>
      <div class="form-group">
        <!-- 파일 선택 버튼 (label) -->
        <input type="hidden" name="storeMainimage" id="storeMainimageId" >
        <label for="storeMainimage" class="btn-cancel" style="display: inline-block; color: #fff; font-weight: 400">파일 선택</label>
        <input class="btn-cancel" accept="image/*" type="file" id="storeMainimage" onchange="previewStoreMainimage(event)" style="display: none">

      </div>
      <div id="preview">
        <img id="storeImagePreview" src="" alt="">
        <button type="button" class="btn-cancel" id="deleteImageBtn" onclick="deleteImagePreview()" style="display:none; margin-top: 10px;">이미지 삭제</button>
      </div>
      <%--위도--%>
      <input type="hidden" name="storeLatitude" id="storeLatitude" >
      <%--경도--%>
      <input type="hidden" name="storeLongitude" id="storeLongitude" >
      <div class="modal-actions">
        <button type="button" class="btn-cancel" onclick="closeModal()">취소</button>
        <button type="submit" class="btn-save">수정</button>
      </div>
    </form>
  </div>
</div>

<script src="${pageContext.request.contextPath}/js/s3Upload.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
  // 현재 활성 탭 관리
  let currentTab = 'store';
  let currentStoreId = null;
  let selectedReviewId = null;
  let reviewsData = [];

  // 페이지 로드 시 초기화
  document.addEventListener('DOMContentLoaded', function() {
    setupTabNavigation();
    
    // 리뷰 관리 탭에서 Enter 키로 검색
    const storeIdInput = document.getElementById('storeId');
    if (storeIdInput) {
      storeIdInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
          loadReviews();
        }
      });
    }

    // 사이드바 첫 번째 링크를 활성화
    const firstLink = document.querySelector('.sidebar-menu a[data-tab="store"]');
    if (firstLink) {
      firstLink.classList.add('active');
    }
  });

  // 탭 네비게이션 설정
  function setupTabNavigation() {
    const sidebarLinks = document.querySelectorAll('.sidebar-menu a[data-tab]');
    
    sidebarLinks.forEach(link => {
      link.addEventListener('click', function(e) {
        e.preventDefault();
        
        const tab = this.dataset.tab;
        
        // 사이드바 활성 상태 업데이트
        sidebarLinks.forEach(l => l.classList.remove('active'));
        this.classList.add('active');
        
        // 탭 전환
        switchTab(tab);
      });
    });
  }

  // 탭 전환 함수
  function switchTab(tab) {
    currentTab = tab;
    
    // 모든 탭 컨텐츠 숨기기
    document.querySelectorAll('.tab-content').forEach(content => {
      content.classList.remove('active');
    });
    
    // 선택된 탭 보이기
    if (tab === 'store') {
      document.getElementById('storeTab').classList.add('active');
      updateHeader('🏠 상점 관리', '상점 관리', '상점 정보를 등록하거나 수정할 수 있습니다');
    } else if (tab === 'reviews') {
      document.getElementById('reviewTab').classList.add('active');
      updateHeader('💬 리뷰 관리', '리뷰 관리', '가게의 리뷰를 확인하고 답글을 관리할 수 있습니다');
      
      // 가게 ID가 이미 있으면 자동으로 로드
      const storeIdInput = document.getElementById('storeId');
      if (storeIdInput && storeIdInput.value) {
        loadReviews();
      }
    }
  }

  // 헤더 업데이트
  function updateHeader(breadcrumb, title, description) {
    document.getElementById('breadcrumb').textContent = breadcrumb;
    document.getElementById('contentTitle').textContent = title;
    document.getElementById('contentDescription').textContent = description;
    document.querySelector('.header-title').textContent = title;
  }

  function logout(){
    if(confirm("로그아웃 하시겠습니까?😊")){
      window.location.href="/solfood/owner/logout";
    }
  }

  // ========== 리뷰 관리 기능 ==========

  // 리뷰 목록 로드
  function loadReviews() {
    const storeId = document.getElementById('storeId').value;
    
    if (!storeId || storeId < 1) {
      showAlert('가게 ID를 올바르게 입력해주세요.', 'error');
      return Promise.reject('Invalid store ID');
    }

    currentStoreId = storeId;
    showLoading();

    return fetch('${pageContext.request.contextPath}/owner/review/list?storeId=' + storeId)
      .then(response => response.json())
      .then(data => {
        hideLoading();
        if (data.success) {
          displayReviews(data);
          showReviewSection();
          return data;
        } else {
          showAlert(data.message || '리뷰를 불러오는데 실패했습니다.', 'error');
          throw new Error(data.message);
        }
      })
      .catch(error => {
        hideLoading();
        console.error('Error:', error);
        showAlert('서버 오류가 발생했습니다.', 'error');
        throw error;
      });
  }

  // 리뷰 표시
  function displayReviews(data) {
    // 통계 업데이트
    document.getElementById('totalReviews').textContent = data.totalCount || 0;
    document.getElementById('averageRating').textContent = (data.averageStar || 0).toFixed(1);

    // 리뷰 데이터 저장
    reviewsData = data.reviews || [];
    
    // 리뷰 카드 목록 표시
    const reviewCards = document.getElementById('reviewCards');
    
    if (reviewsData.length === 0) {
      reviewCards.innerHTML = '<div class="empty-state">등록된 리뷰가 없습니다.</div>';
      return;
    }

    reviewCards.innerHTML = reviewsData.map(review => {
      const hasReply = review.reviewResponse && review.reviewResponse.trim() !== '';
      const replyStatusClass = hasReply ? 'completed' : 'pending';
      const replyStatusIcon = hasReply ? '✓' : '✗';
      
      return '<div class="review-card" data-review-id="' + review.reviewId + '" onclick="selectReview(' + review.reviewId + ')">' +
        '<div class="card-header">' +
          '<div class="card-rating">' +
            '<span class="rating-number">' + review.reviewStar + '</span>' +
            '<span class="rating-stars">' + generateStars(review.reviewStar) + '</span>' +
          '</div>' +
          '<div class="reply-status ' + replyStatusClass + '">' + replyStatusIcon + '</div>' +
        '</div>' +
        '<div class="card-title">' + escapeHtml(review.reviewTitle || review.reviewContent) + '</div>' +
        '<div class="card-date">' + formatDate(review.reviewDate) + '</div>' +
      '</div>';
    }).join('');

    // 첫 번째 리뷰 자동 선택
    if (reviewsData.length > 0) {
      selectReview(reviewsData[0].reviewId);
    }
  }

  // 별점 생성
  function generateStars(rating) {
    let stars = '';
    for (let i = 1; i <= 5; i++) {
      stars += '<span class="star ' + (i <= rating ? '' : 'empty') + '">★</span>';
    }
    return stars;
  }

  // 리뷰 선택
  function selectReview(reviewId) {
    selectedReviewId = reviewId;
    
    // 카드 활성화 상태 업데이트
    document.querySelectorAll('.review-card').forEach(card => {
      card.classList.remove('active');
    });
    document.querySelector('.review-card[data-review-id="' + reviewId + '"]').classList.add('active');
    
    // 선택된 리뷰 찾기
    const selectedReview = reviewsData.find(review => review.reviewId === reviewId);
    if (!selectedReview) return;
    
    // 상세 내용 표시
    const detailContent = document.getElementById('reviewDetailContent');
    const hasImage = selectedReview.reviewImage && selectedReview.reviewImage.trim() !== '';
    const imageHtml = hasImage ? '<img src="' + selectedReview.reviewImage + '" class="detail-image" alt="리뷰 이미지">' : '';
    
    const existingReplyHtml = selectedReview.reviewResponse ? 
      '<div class="existing-reply">' +
        '<div class="existing-reply-label">📝 사장님 답글</div>' +
        '<div>' + escapeHtml(selectedReview.reviewResponse) + '</div>' +
        '<div class="existing-reply-actions">' +
          '<button class="btn btn-secondary" onclick="editReply(' + reviewId + ', \'' + escapeHtml(selectedReview.reviewResponse) + '\')">수정</button>' +
          '<button class="btn btn-danger" onclick="deleteReply(' + reviewId + ')">삭제</button>' +
        '</div>' +
      '</div>' : '';
    
    detailContent.innerHTML = 
      '<div class="detail-content active">' +
        '<div class="detail-rating">' +
          '<span class="detail-rating-number">' + selectedReview.reviewStar + '</span>' +
          '<span class="detail-stars">' + generateStars(selectedReview.reviewStar) + '</span>' +
        '</div>' +
        '<div class="detail-meta">' +
          '<div class="detail-user">사용자 ID: ' + selectedReview.usersId + '</div>' +
          '<div class="detail-date">' + formatDate(selectedReview.reviewDate) + '</div>' +
        '</div>' +
        (selectedReview.reviewTitle ? '<div class="detail-title">' + escapeHtml(selectedReview.reviewTitle) + '</div>' : '') +
        '<div class="detail-text">' + escapeHtml(selectedReview.reviewContent) + '</div>' +
        imageHtml +
        existingReplyHtml +
      '</div>';
    
    // 답글 입력창 활성화/비활성화
    const replyTextarea = document.getElementById('replyTextarea');
    const replySubmitBtn = document.getElementById('replySubmitBtn');
    
    if (selectedReview.reviewResponse) {
      replyTextarea.value = selectedReview.reviewResponse;
      replyTextarea.disabled = true;
      replySubmitBtn.disabled = true;
      replySubmitBtn.textContent = '답글 완료';
    } else {
      replyTextarea.value = '';
      replyTextarea.disabled = false;
      replySubmitBtn.disabled = false;
      replySubmitBtn.textContent = '등록';
    }
  }

  // 날짜 포맷
  function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('ko-KR');
  }

  // HTML 이스케이프
  function escapeHtml(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  // 답글 제출
  function submitReply() {
    if (!selectedReviewId) {
      showAlert('리뷰를 먼저 선택해주세요.', 'error');
      return;
    }

    const replyText = document.getElementById('replyTextarea').value.trim();
    
    if (!replyText) {
      showAlert('답글 내용을 입력해주세요.', 'error');
      return;
    }

    const formData = new FormData();
    formData.append('reviewId', selectedReviewId);
    formData.append('reviewResponse', replyText);

    fetch('${pageContext.request.contextPath}/owner/review/reply', {
      method: 'POST',
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        showAlert(data.message, 'success');
        const currentSelected = selectedReviewId;
        loadReviews().then(() => {
          if (currentSelected) {
            selectReview(currentSelected);
          }
        }).catch(() => {
          // 로드 실패 시 무시 (이미 에러 메시지 표시됨)
        });
      } else {
        showAlert(data.message, 'error');
      }
    })
    .catch(error => {
      console.error('Error:', error);
      showAlert('답글 저장 중 오류가 발생했습니다.', 'error');
    });
  }

  // 답글 수정
  function editReply(reviewId, currentReply) {
    const newReply = prompt('답글을 수정하세요:', currentReply);
    
    if (newReply === null) return; // 취소
    
    if (!newReply.trim()) {
      showAlert('답글 내용을 입력해주세요.', 'error');
      return;
    }

    const formData = new FormData();
    formData.append('reviewId', reviewId);
    formData.append('reviewResponse', newReply.trim());

    fetch('${pageContext.request.contextPath}/owner/review/reply', {
      method: 'PUT',
      body: formData
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        showAlert(data.message, 'success');
        const currentSelected = selectedReviewId;
        loadReviews().then(() => {
          if (currentSelected) {
            selectReview(currentSelected);
          }
        }).catch(() => {
          // 로드 실패 시 무시 (이미 에러 메시지 표시됨)
        });
      } else {
        showAlert(data.message, 'error');
      }
    })
    .catch(error => {
      console.error('Error:', error);
      showAlert('답글 수정 중 오류가 발생했습니다.', 'error');
    });
  }

  // 답글 삭제
  function deleteReply(reviewId) {
    if (!confirm('정말로 답글을 삭제하시겠습니까?')) {
      return;
    }

    fetch('${pageContext.request.contextPath}/owner/review/reply?reviewId=' + reviewId, {
      method: 'DELETE'
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        showAlert(data.message, 'success');
        const currentSelected = selectedReviewId;
        loadReviews().then(() => {
          if (currentSelected) {
            selectReview(currentSelected);
          }
        }).catch(() => {
          // 로드 실패 시 무시 (이미 에러 메시지 표시됨)
        });
      } else {
        showAlert(data.message, 'error');
      }
    })
    .catch(error => {
      console.error('Error:', error);
      showAlert('답글 삭제 중 오류가 발생했습니다.', 'error');
    });
  }

  // 리뷰 섹션 표시
  function showReviewSection() {
    document.getElementById('reviewStats').style.display = 'block';
    document.getElementById('reviewManagement').classList.add('active');
  }

  // 로딩 표시
  function showLoading() {
    document.getElementById('reviewCards').innerHTML = '<div class="loading">리뷰를 불러오는 중...</div>';
    document.getElementById('reviewDetailContent').innerHTML = '<div class="empty-state">리뷰를 불러오는 중...</div>';
    showReviewSection();
  }

  // 로딩 숨기기
  function hideLoading() {
    // 로딩은 displayReviews에서 처리됨
  }

  // 알림 메시지 표시
  function showAlert(message, type) {
    const alertDiv = document.getElementById('alertMessage');
    alertDiv.className = `alert alert-${type}`;
    alertDiv.textContent = message;
    alertDiv.style.display = 'block';
    
    setTimeout(() => {
      alertDiv.style.display = 'none';
    }, 5000);
  }

  // --------------------------------위치 찾기---------------------------------
  // 우편번호 찾기 찾기 화면을 넣을 element
  var element_wrap = document.getElementById('wrap');

  function foldDaumPostcode() {
    // iframe을 넣은 element를 안보이게 한다.
    element_wrap.style.display = 'none';
  }

  function sample3_execDaumPostcode() {
    // 현재 scroll 위치를 저장해놓는다.
    var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
    new daum.Postcode({
      oncomplete: function(data) {
        // 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

        // 각 주소의 노출 규칙에 따라 주소를 조합한다.
        // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
        var addr = ''; // 주소 변수
        var extraAddr = ''; // 참고항목 변수

        //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
        if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
          addr = data.roadAddress;
        } else { // 사용자가 지번 주소를 선택했을 경우(J)
          addr = data.jibunAddress;
        }

        // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
        if(data.userSelectedType === 'R'){
          // 법정동명이 있을 경우 추가한다. (법정리는 제외)
          // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
          if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
            extraAddr += data.bname;
          }
          // 건물명이 있고, 공동주택일 경우 추가한다.
          if(data.buildingName !== '' && data.apartment === 'Y'){
            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
          }
          // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
          if(extraAddr !== ''){
            extraAddr = ' (' + extraAddr + ')';
          }
          // 조합된 참고항목을 해당 필드에 넣는다.
          document.getElementById("sample3_extraAddress").value = extraAddr;

        } else {
          document.getElementById("sample3_extraAddress").value = '';
        }

        // 우편번호와 주소 정보를 해당 필드에 넣는다.
        document.getElementById('sample3_postcode').value = data.zonecode;
        document.getElementById("sample3_address").value = addr;
        // 커서를 상세주소 필드로 이동한다.
        document.getElementById("sample3_detailAddress").focus();

        // iframe을 넣은 element를 안보이게 한다.
        // (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
        element_wrap.style.display = 'none';

        // 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
        document.body.scrollTop = currentScroll;

        // ----------------------추가 --------------------
        const fullAddress = addr + document.getElementById("sample3_detailAddress").value+' ' + (extraAddr || '');
        document.getElementById("storeAddress").value = fullAddress;

        getLatLngFromAddress(fullAddress);
      },
      // 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
      onresize : function(size) {
        element_wrap.style.height = size.height+'px';
      },
      width : '100%',
      height : '100%'
    }).embed(element_wrap);

    // iframe을 넣은 element를 보이게 한다.
    element_wrap.style.display = 'block';
  }

  document.getElementById("sample3_detailAddress").addEventListener("blur",function (){
    const addr = document.getElementById("sample3_address").value;
    const detail = this.value;
    const extra = document.getElementById("sample3_extraAddress").value;

    document.getElementById("storeAddress").value = addr + ' ' + detail + ' ' + extra;
  })

  // ---------------------------- 대표이미지 미리보기 -------------------------------------
  async function previewStoreMainimage(event){

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
    document.getElementById('storeMainimageId').value = s3Url;

    console.log('프로필 이미지 업로드 완료:', s3Url);


  }

  // -----------------------------대표이미지 삭제----------------------------------

  function deleteImagePreview() {
    document.getElementById("preview").style.display = "none";
    document.getElementById("storeImagePreview").src = ""; // 미리보기 이미지 제거
    document.getElementById("storeMainimage").value = ""; // ✅ 이 줄은 그대로 OK
    document.getElementById("deleteImageBtn").style.display = "none";
  }

  // ----------------------------위도 경도 ---------------------------------------
  function getLatLngFromAddress(fullAddress){
    var geocoder = new kakao.maps.services.Geocoder();

    var callback = function(result, status) {
      if (status === kakao.maps.services.Status.OK) {
        console.log(result);
        const lat = result[0].y; // 위도
        const lng = result[0].x; // 경도
        document.getElementById("storeLatitude").value = lat;
        document.getElementById("storeLongitude").value = lng;
      } else{
        alert("위도 경도 조회 실패",status)
      }
    };

    geocoder.addressSearch(fullAddress, callback);
  }
  // --------------------------------파싱--------------------------------

  // 페이지 로드 완료 후 헤더 초기화
  window.addEventListener('load', function() {
    updateHeader('🏠 상점 관리', '상점 관리', '상점 정보를 등록하거나 수정할 수 있습니다');
  });

</script>
</body>
</html>
