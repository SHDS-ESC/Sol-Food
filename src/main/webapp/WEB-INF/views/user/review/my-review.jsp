<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 리뷰 관리 - Sol Food</title>
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- Common CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/my-review.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
    <div class="wrap">
        <!-- 헤더 -->
        <jsp:include page="../include/backbtn-header.jsp" />

        <!-- 컨텐츠 -->
        <div class="content my-review">
            <div class="review-container">
                <div class="page-header">
                    <h1><i class="bi bi-chat-square-text"></i> 내 리뷰 관리</h1>
                    <p class="page-description">내가 작성한 리뷰들을 관리할 수 있습니다.</p>
                </div>

                <!-- 리뷰 통계 -->
                <div class="review-stats">
                    <div class="stat-item">
                        <div class="stat-number" id="totalReviews">0</div>
                        <div class="stat-label">총 리뷰</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="avgRating">0.0</div>
                        <div class="stat-label">평균 별점</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number" id="thisMonth">0</div>
                        <div class="stat-label">이번 달</div>
                    </div>
                </div>

                <!-- 필터 및 정렬 -->
                <div class="filter-section">
                    <div class="filter-tabs">
                        <button class="filter-tab active" data-filter="all">전체</button>
                        <button class="filter-tab" data-filter="recent">최근</button>
                        <button class="filter-tab" data-filter="high-rating">높은 별점</button>
                        <button class="filter-tab" data-filter="low-rating">낮은 별점</button>
                    </div>
                    <div class="sort-dropdown">
                        <select id="sortSelect" onchange="changeSort()">
                            <option value="latest">최신순</option>
                            <option value="oldest">오래된순</option>
                            <option value="rating-high">별점 높은순</option>
                            <option value="rating-low">별점 낮은순</option>
                        </select>
                    </div>
                </div>

                <!-- 리뷰 목록 -->
                <div class="review-list" id="reviewList">
                    <!-- 리뷰들이 동적으로 로드됩니다 -->
                </div>

                <!-- 로딩 상태 -->
                <div class="loading-state" id="loadingState" style="display: none;">
                    <div class="spinner"></div>
                    <p>리뷰를 불러오는 중...</p>
                </div>

                <!-- 빈 상태 -->
                <div class="empty-state" id="emptyState" style="display: none;">
                    <i class="bi bi-chat-square-text"></i>
                    <h3>아직 작성한 리뷰가 없습니다</h3>
                    <p>맛있는 음식을 먹고 리뷰를 작성해보세요!</p>
                    <a href="${pageContext.request.contextPath}/user/store" class="btn-primary">
                        <i class="bi bi-shop"></i> 가게 둘러보기
                    </a>
                </div>

                <!-- 더보기 버튼 -->
                <div class="load-more-section" id="loadMoreSection" style="display: none;">
                    <button class="load-more-btn" onclick="loadMoreReviews()">
                        더 많은 리뷰 보기
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- 리뷰 수정 모달 -->
    <div class="modal" id="editReviewModal">
        <div class="modal-overlay" onclick="closeEditModal()"></div>
        <div class="modal-content">
            <div class="modal-header">
                <h3>리뷰 수정</h3>
                <button class="modal-close" onclick="closeEditModal()">×</button>
            </div>
            <div class="modal-body">
                <form id="editReviewForm">
                    <input type="hidden" id="editReviewId" name="reviewId">
                    
                    <div class="form-group">
                        <label for="editReviewTitle">리뷰 제목</label>
                        <input type="text" id="editReviewTitle" name="reviewTitle" required maxlength="50">
                    </div>
                    
                    <div class="form-group">
                        <label for="editReviewContent">리뷰 내용</label>
                        <textarea id="editReviewContent" name="reviewContent" required maxlength="500" rows="4"></textarea>
                    </div>
                    
                    <div class="form-group">
                        <label>별점</label>
                        <div class="star-rating" id="editStarRating">
                            <i class="bi bi-star" data-rating="1"></i>
                            <i class="bi bi-star" data-rating="2"></i>
                            <i class="bi bi-star" data-rating="3"></i>
                            <i class="bi bi-star" data-rating="4"></i>
                            <i class="bi bi-star" data-rating="5"></i>
                        </div>
                        <input type="hidden" id="editReviewRating" name="reviewRating" value="5">
                    </div>
                    
                    <div class="form-group">
                        <label for="editReviewImage">리뷰 이미지</label>
                        <input type="file" id="editReviewImage" name="reviewImage" accept="image/*">
                        <div class="current-image" id="currentImageSection" style="display: none;">
                            <img id="currentImage" src="" alt="현재 이미지">
                            <button type="button" onclick="removeCurrentImage()">이미지 제거</button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeEditModal()">취소</button>
                <button class="btn-primary" onclick="updateReview()">수정하기</button>
            </div>
        </div>
    </div>

    <!-- 삭제 확인 모달 -->
    <div class="modal" id="deleteConfirmModal">
        <div class="modal-overlay" onclick="closeDeleteModal()"></div>
        <div class="modal-content">
            <div class="modal-header">
                <h3>리뷰 삭제</h3>
                <button class="modal-close" onclick="closeDeleteModal()">×</button>
            </div>
            <div class="modal-body">
                <p>정말로 이 리뷰를 삭제하시겠습니까?</p>
                <p class="text-muted">삭제된 리뷰는 복구할 수 없습니다.</p>
            </div>
            <div class="modal-footer">
                <button class="btn-secondary" onclick="closeDeleteModal()">취소</button>
                <button class="btn-danger" onclick="confirmDeleteReview()">삭제하기</button>
            </div>
        </div>
    </div>

    <!-- Context Path 설정 -->
    <script>
        var contextPath = '${pageContext.request.contextPath}';
    </script>
    
    <!-- URL Constants -->
    <script src="<c:url value='/js/urlConstants.js' />?v=${pageContext.session.creationTime}"></script>
    <!-- Common Utils -->
    <script src="<c:url value='/js/common-utils.js' />?v=${pageContext.session.creationTime}"></script>
    <!-- Popup JavaScript -->
    <script src="<c:url value='/js/popup.js' />?v=${pageContext.session.creationTime}"></script>
    <!-- My Review JavaScript -->
    <script src="<c:url value='/js/my-review.js' />?v=${pageContext.session.creationTime}"></script>
    <script src="<c:url value='/js/darkmode.js' />"></script>
</body>
</html> 