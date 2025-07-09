<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리뷰 관리 - Sol Food</title>
    
    <!-- 외부 라이브러리 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- 커스텀 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/owner-review.css">
    
    <script>
        // 컨텍스트 패스 설정
        const contextPath = '${pageContext.request.contextPath}';
    </script>
</head>
<body>
    <div class="layout">
        <!-- 사이드바 -->
        <nav class="sidebar">
            <div class="sidebar-header">
                <h2>🍽️ Sol Food</h2>
                <p>레스토랑 관리 시스템</p>
            </div>
            <ul class="sidebar-menu">
                <li>
                    <a href="${pageContext.request.contextPath}/owner/store">
                        <span class="icon">📅</span>
                        <span>상점 관리</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/owner/menu">
                        <span class="icon">🍽️</span>
                        <span>메뉴 관리</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/owner/sales">
                        <span class="icon">📊</span>
                        <span>매출 관리</span>
                    </a>
                </li>
                <li>
                    <a href="${pageContext.request.contextPath}/owner/review" class="active">
                        <span class="icon">💬</span>
                        <span>리뷰 관리</span>
                    </a>
                </li>
            </ul>
        </nav>

        <!-- 메인 컨텐츠 -->
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

            <!-- 필터 섹션 -->
            <section class="filter-section">
                <div class="filter-grid">
                    <input type="hidden" id="storeIdInput" value="${store.storeId}">
<%--                    <div class="filter-group">--%>
<%--                        <select id="storeFilter">--%>
<%--                            <option value="">가게를 선택하세요</option>--%>
<%--                            <option value="322">테스트 가게 (Store ID: 322)</option>--%>
<%--                        </select>--%>
<%--                    </div>--%>
                    <div class="filter-group">
                        <label for="ratingFilter">별점 필터</label>
                        <select id="ratingFilter">
                            <option value="">전체</option>
                            <option value="5">5점</option>
                            <option value="4">4점</option>
                            <option value="3">3점</option>
                            <option value="2">2점</option>
                            <option value="1">1점</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="responseFilter">답글 상태</label>
                        <select id="responseFilter">
                            <option value="">전체</option>
                            <option value="completed">답글 완료</option>
                            <option value="pending">미답글</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label for="sortFilter">정렬</label>
                        <select id="sortFilter">
                            <option value="latest">최신순</option>
                            <option value="oldest">오래된순</option>
                            <option value="rating_high">별점 높은순</option>
                            <option value="rating_low">별점 낮은순</option>
                        </select>
                    </div>
                    <div class="filter-actions">
                        <button type="button" id="filterBtn" class="btn btn-primary">필터 적용</button>
                        <button type="button" id="resetBtn" class="btn btn-secondary">초기화</button>
                    </div>
                </div>
            </section>

            <!-- 컨텐츠 영역 (3블럭 구조) -->
            <section class="content-area">
                <!-- 왼쪽 블럭: 리뷰 목록 -->
                <div class="review-list-panel">
                    <div class="panel-header">
                        <h3 class="panel-title">리뷰 목록</h3>
                        <div class="store-info">가게를 선택해주세요</div>
                    </div>
                    <div class="review-list">
                        <!-- 리뷰 목록이 동적으로 로드됩니다 -->
                    </div>
                </div>

                <!-- 오른쪽 영역 -->
                <div class="right-panel">
                    <!-- 오른쪽 위 블럭: 리뷰 상세 -->
                    <div class="review-detail-panel">
                        <div class="review-detail-empty">
                            <div>
                                <i class="fas fa-star" style="font-size: 3rem; margin-bottom: 15px; color: #d1d5db;"></i>
                                <p>리뷰를 선택하면 상세 내용을 볼 수 있습니다.</p>
                            </div>
                        </div>
                        <div class="review-detail-content">
                            <!-- 리뷰 상세 내용이 동적으로 로드됩니다 -->
                        </div>
                    </div>

                    <!-- 오른쪽 아래 블럭: 답글 작성 -->
                    <div class="response-panel">
                        <div class="response-empty">
                            <div>
                                <i class="fas fa-comment" style="font-size: 2rem; margin-bottom: 10px; color: #d1d5db;"></i>
                                <p>리뷰를 선택하면 답글을 작성할 수 있습니다.</p>
                            </div>
                        </div>
                        <div class="response-input-area" style="display: none;">
                            <div class="response-header">
                                <h4 class="response-title">점주 답글</h4>
                            </div>
                            <div class="current-response">
                                <div class="current-response-content"></div>
                            </div>
                            <textarea id="responseText" class="response-textarea" placeholder="고객에게 답글을 작성해주세요..."></textarea>
                            <div class="response-actions">
                                <div class="response-actions-left">
                                    <button type="button" id="deleteResponseBtn" class="btn btn-danger" style="display: none;">답글 삭제</button>
                                </div>
                                <button type="button" id="submitResponseBtn" class="btn btn-success">답글 저장</button>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main>
    </div>

    <!-- 커스텀 JavaScript -->
    <script src="${pageContext.request.contextPath}/js/popup.js"></script>
    <script src="${pageContext.request.contextPath}/js/owner-review.js"></script>
</body>
</html> 