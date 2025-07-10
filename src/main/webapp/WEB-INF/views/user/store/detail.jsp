<%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 25. 6. 17.
  Time: 오후 8:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>가게 상세 - Sol Food</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🍽️</text></svg>">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    
    <!-- 외부 CSS 파일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storedetail.css">
    
    <!-- jQuery (가장 먼저 로드) -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <!-- 카카오맵 SDK -->
    <script>
        // Context Path를 JavaScript에서 사용할 수 있도록 설정
        var contextPath = '${pageContext.request.contextPath}';
        
        // JSP에서 JavaScript로 데이터 전달
        window.kakaoJsKey = '${kakaoJsKey}';
        window.storeLatitude = parseFloat('${store.storeLatitude}');
        window.storeLongitude = parseFloat('${store.storeLongitude}');
        window.storeName = '${store.storeName}';
        window.storeAddress = '${store.storeAddress}';
        window.storeId = parseInt('${store.storeId}');
        
        // 카카오맵 SDK 동적 로딩
        function loadKakaoMapSDK() {
            return new Promise((resolve, reject) => {
                if (typeof kakao !== 'undefined' && kakao.maps) {
                    resolve();
                    return;
                }
                
                const script = document.createElement('script');
                script.type = 'text/javascript';
                script.src = 'https://dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoJsKey}&libraries=services&autoload=false';
                script.onload = () => {
                    kakao.maps.load(() => {
                        resolve();
                    });
                };
                script.onerror = () => {
                    reject();
                };
                document.head.appendChild(script);
            });
        }
        
        // 페이지 로드 후 SDK 로딩
        window.kakaoMapSDKPromise = loadKakaoMapSDK();
    </script>
</head>
<body>
    <div class="wrap">
        <!-- 헤더 -->
        <jsp:include page="../include/backbtn-header.jsp" />
        
        <!-- 컨텐츠 -->
        <div class="content store-detail">
            <!-- 가게 정보 헤더 -->
            <div class="store-header">
                <div class="store-hero">
                    <img src="<c:out value='${store.storeMainimage}'/>" alt="<c:out value='${store.storeName}'/>" class="store-hero-image" onerror="this.src='https://images.unsplash.com/photo-1590301157890-4810ed352733?w=400&h=200&fit=crop'">
                    <div class="store-hero-overlay">
                        <h1><i class="bi bi-shop"></i> <c:out value="${store.storeName}"/></h1>
                        <p><c:out value="${store.storeIntro}"/></p>
                    </div>
                </div>
            </div>
            
            <!-- 탭 메뉴 -->
            <div class="tabs">
                <div class="tab active" data-tab="menu">
                    <i class="bi bi-list-ul"></i> 메뉴
                </div>
                <div class="tab" data-tab="map">
                    <i class="bi bi-geo-alt"></i> 상세정보
                </div>
                <div class="tab" data-tab="review">
                    <i class="bi bi-chat-dots"></i> 리뷰
                </div>
            </div>
            
            <!-- 탭 콘텐츠 -->
            <div class="tab-content">
                <!-- 메뉴 섹션 -->
                <div class="content-section active" id="menu-section">
                    <div class="menu-list">
                        <c:choose>
                            <c:when test="${empty menuList}">
                                <div class="empty-state">
                                    <i class="bi bi-list-ul"></i>
                                    <h4>등록된 메뉴가 없습니다</h4>
                                    <p class="text-muted">곧 맛있는 메뉴가 추가될 예정입니다!</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="menu" items="${menuList}">
                                    <div class="menu-item" 
                                         data-menu-id="${menu.menuId}"
                                         data-menu-name="<c:out value='${menu.menuName}'/>"
                                         data-menu-intro="<c:out value='${menu.menuIntro}'/>"
                                         data-menu-price="${menu.menuPrice}"
                                         data-menu-image="<c:out value='${menu.menuMainimage}'/>"
                                         data-menu-extra="<c:out value='${menu.menuExtra}'/>"
                                         onclick="openMenuDetailFromElement(this)" 
                                         style="cursor: pointer;">
                                        <img src="<c:out value='${menu.menuMainimage}'/>" alt="<c:out value='${menu.menuName}'/>" class="menu-image" onerror="this.src='https://images.unsplash.com/photo-1590301157890-4810ed352733?w=80&h=80&fit=crop'">
                                        <div class="menu-info">
                                            <h3><c:out value="${menu.menuName}"/></h3>
                                            <p><c:out value="${menu.menuIntro}"/></p>
                                        </div>
                                        <div class="menu-price-area">
                                            <div class="menu-price">₩<fmt:formatNumber value="${menu.menuPrice}" type="number" groupingUsed="true"/></div>
                                            <div class="quick-add-icon">+</div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <!-- 상세정보 섹션 -->
                <div class="content-section" id="map-section">
                    <!-- 가게 소개 섹션 -->
                    <div class="store-intro-section">
                        <div class="store-intro-header">
                            <h3><i class="bi bi-shop"></i> <c:out value="${store.storeName}"/></h3>
                            <c:if test="${not empty store.storeCategory}">
                                <span class="store-category-badge"><c:out value="${store.storeCategory}"/></span>
                            </c:if>
                        </div>
                        
                        <c:if test="${not empty store.storeIntro}">
                            <div class="store-intro-content">
                                <h4><i class="bi bi-info-circle"></i> 가게 소개</h4>
                                <p><c:out value="${store.storeIntro}"/></p>
                            </div>
                        </c:if>
                        
                        <div class="store-contact-info">
                            <div class="contact-item">
                                <i class="bi bi-telephone"></i>
                                <span><c:out value="${store.storeTel}"/></span>
                            </div>
                            <div class="contact-item">
                                <i class="bi bi-geo-alt"></i>
                                <span><c:out value="${store.storeAddress}"/></span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 위치 및 도보 시간 섹션 -->
                    <div class="location-section">
                        <div class="location-header">
                            <h4><i class="bi bi-geo-alt"></i> 위치 정보</h4>
                            <div class="walking-time-info" id="walkingTimeInfo">
                                <div class="walking-time-loading">
                                    <div class="spinner"></div>
                                    <span>도보 시간 계산 중...</span>
                                </div>
                            </div>
                        </div>
                        
                        <div class="map-container">
                            <div id="map">
                                <div style="width:100%; height:100%; background:#f0f0f0; display:flex; align-items:center; justify-content:center; flex-direction:column;">
                                    <div style="background:white; padding:20px; border-radius:10px; box-shadow:0 2px 10px rgba(0,0,0,0.1); text-align:center; max-width:300px;">
                                        <h3 style="margin-bottom:15px; color:#333;"><i class="bi bi-geo-alt"></i> 가게 위치</h3>
                                        <p style="margin:5px 0; color:#666;"><c:out value="${store.storeAddress}"/></p>
                                        <p style="margin:5px 0; color:#666;">위도: <c:out value="${store.storeLatitude}"/></p>
                                        <p style="margin:5px 0; color:#666;">경도: <c:out value="${store.storeLongitude}"/></p>
                                        <div style="margin-top:15px;">
                                            <button onclick="loadKakaoMap()" style="background:#fee500; color:#000; border:none; padding:8px 16px; border-radius:5px; margin-right:10px; cursor:pointer; font-weight:bold;">카카오맵 재시도</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- 리뷰 섹션 -->
                <div class="content-section" id="review-section">
                    <!-- 평점 요약 -->
                    <div class="rating-summary" id="rating-summary">
                        <div class="rating-score">
                            <div class="score">
                                <c:choose>
                                    <c:when test="${not empty avgStar}">${avgStar}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stars">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${not empty avgStar and i <= avgStar}">★</c:when>
                                        <c:otherwise>☆</c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                            <div class="count">
                                평가 <c:choose>
                                    <c:when test="${not empty totalCount}">${totalCount}</c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>개
                            </div>
                        </div>
                        <div class="rating-bars">
                            <c:forEach begin="1" end="5" var="i">
                                <c:set var="starLevel" value="${6 - i}"/>
                                <c:set var="starCount" value="${starCounts != null && starCounts[starLevel-1] != null ? starCounts[starLevel-1] : 0}"/>
                                <c:set var="totalCountSafe" value="${totalCount != null && totalCount > 0 ? totalCount : 1}"/>
                                <c:set var="percentage" value="${starCount * 100 / totalCountSafe}"/>
                                <div class="rating-bar">
                                    <div class="bar-label">${starLevel}</div>
                                    <div class="bar-bg">
                                        <div class="bar-fill" data-percentage="<c:out value='${percentage}'/>"></div>
                                    </div>
                                    <div class="bar-percent">
                                        <fmt:formatNumber value="${percentage}" pattern="#.#"/>%
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <div class="review-list">
                        <c:choose>
                            <c:when test="${empty reviewList}">
                                <div class="empty-state">
                                    <i class="bi bi-chat-dots"></i>
                                    <h4>등록된 리뷰가 없습니다</h4>
                                    <p class="text-muted">첫 번째 리뷰를 작성해보세요!</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="review" items="${reviewList}" varStatus="status">
                                    <div class="review-card">
                                        <div class="review-header">
                                            <div class="review-user">
                                                <img class="profile-img" src="${review.userProfile}" alt="프로필" onerror="this.src='https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800'">
                                                <div class="user-info">
                                                    <span class="nickname">${review.userNickname}</span>
                                                    <div class="review-stars">
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <c:choose>
                                                                <c:when test="${i <= review.reviewStar}">★</c:when>
                                                                <c:otherwise>☆</c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                        <span class="star-count">${review.reviewStar}점</span>
                                                    </div>
                                                </div>
                                            </div>
                                            <span class="review-date">
                                                <fmt:formatDate value="${review.reviewDate}" pattern="yyyy-MM-dd HH:mm"/>
                                            </span>
                                        </div>
                                        <div class="review-title-area">
                                            <span class="review-title">
                                                ${review.reviewTitle}
                                            </span>
                                        </div>
                                        <c:if test="${not empty review.reviewImage}">
                                            <div class="review-image">
                                                <img src="${review.reviewImage}" alt="리뷰 사진" onerror="this.parentElement.style.display='none'">
                                            </div>
                                        </c:if>
                                        <div class="review-content"><c:out value="${review.reviewContent}"/></div>
                                        <c:if test="${not empty review.reviewResponse}">
                                            <div class="review-response">
                                                <i class="bi bi-reply"></i> <c:out value="${review.reviewResponse}"/>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- 메뉴 상세 모달 -->
        <div id="menuDetailModal" class="menu-modal" style="display: none;">
            <div class="menu-modal-overlay" onclick="closeMenuDetail()"></div>
            <div class="menu-modal-content">
                <!-- 모달 헤더 -->
                <div class="menu-modal-header">
                    <button class="menu-modal-close" onclick="closeMenuDetail()">×</button>
                    <img id="modalMenuImage" src="" alt="메뉴 이미지" class="menu-modal-image">
                </div>
                
                <!-- 모달 바디 -->
                <div class="menu-modal-body">
                    <h2 id="modalMenuName" class="menu-modal-title"></h2>
                    <p id="modalMenuIntro" class="menu-modal-description"></p>
                    
                    <!-- 기본 가격 -->
                    <div class="menu-modal-price">
                        <span class="price-label">가격</span>
                        <span id="modalMenuPrice" class="price-value"></span>
                    </div>
                    
                    <!-- 수량 선택 -->
                    <div class="quantity-section">
                        <span class="quantity-label">수량</span>
                        <div class="quantity-controls">
                            <button class="quantity-btn" onclick="decreaseQuantity()" id="decreaseBtn">-</button>
                            <span class="quantity-value" id="quantityValue">1</span>
                            <button class="quantity-btn" onclick="increaseQuantity()">+</button>
                        </div>
                    </div>
                    
                    <!-- 옵션 선택 섹션 (동적 옵션만) -->
                    <div class="options-section">
                        <!-- 동적 옵션들이 여기에 추가됩니다 -->
                    </div>
                </div>
                
                <!-- 하단 고정 버튼 -->
                <div class="menu-modal-footer">
                    <button class="add-to-cart-btn" onclick="addMenuToCart()">
                        <span class="cart-text">장바구니에 담기</span>
                        <span class="total-price" id="totalPrice">0원</span>
                    </button>
                </div>
            </div>
        </div>
        
        <!-- 하단 카트 바 -->
        <div class="bottom-cart-bar" id="bottomCartBar" style="display: none;">
            <div class="cart-bar-content">
                <div class="cart-info">
                    <span class="cart-item-count"><i class="bi bi-bag"></i> <span id="cartItemCount">0</span>개</span>
                    <span class="cart-amount" id="cartAmount">0원</span>
                </div>
                <button class="cart-view-btn" onclick="goToCart()">
                    카트 보기
                </button>
            </div>
        </div>
    </div>
    
    <!-- 외부 JavaScript 파일 (로딩 순서 중요!) -->
    <script src="${pageContext.request.contextPath}/js/urlConstants.js"></script>
    <script src="${pageContext.request.contextPath}/js/common-utils.js"></script>
    <script src="${pageContext.request.contextPath}/js/popup.js"></script>
    <script src="${pageContext.request.contextPath}/js/cart.js"></script>
    <script src="${pageContext.request.contextPath}/js/storedetail.js"></script>
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
    
    <script>
    // 페이지 로드 시 장바구니 개수 조회
    document.addEventListener('DOMContentLoaded', function() {
        // 로그인된 사용자인 경우에만 장바구니 개수 조회
        <c:if test="${not empty sessionScope.userLoginSession}">
            fetchCartCount();
        </c:if>
    });

    // 장바구니 개수 조회 함수
    function fetchCartCount() {
        fetch(UrlConstants.Builder.fullUrl(UrlConstants.API.CART_COUNT))
            .then(response => response.json())
            .then(data => {
                const count = data.count || 0;
                SolFoodUtils.updateBadge('.cart-nav-badge', count);
                document.getElementById('cartItemCount').textContent = count;
            })
            .catch(error => {
                console.log('장바구니 개수 조회 실패 (로그인하지 않은 경우 등):', error);
            });
    }
    </script>
</body>
</html>
