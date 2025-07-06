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
    <title>가게 리뷰</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'><text y='.9em' font-size='90'>🍽️</text></svg>">
    
    <!-- 외부 CSS 파일 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/storedetail.css">
    
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
<body class="review-page">
    <div class="container">
        <div class="fixed-header">
            <!-- 상단 평점 요약 (리뷰 탭에서만 표시) -->
            <div class="summary hide" id="rating-summary">
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
                <div class="bar-group">
                    <c:forEach begin="1" end="5" var="i">
                        <c:set var="starLevel" value="${6 - i}"/>
                        <c:set var="starCount" value="${starCounts != null && starCounts[starLevel-1] != null ? starCounts[starLevel-1] : 0}"/>
                        <c:set var="totalCountSafe" value="${totalCount != null && totalCount > 0 ? totalCount : 1}"/>
                        <c:set var="percentage" value="${starCount * 100 / totalCountSafe}"/>
                        <div class="bar">
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
            
            <!-- 대표 메뉴 이미지 (메뉴 탭에서만 표시) -->
            <div class="featured-menu show" id="featured-menu">
                <div class="menu-hero">
                    <img src="<c:out value='${store.storeMainimage}'/>" alt="대표 메뉴" class="menu-hero-image">
                    <div class="menu-hero-overlay">
                        <h2>🍽️ <c:out value="${store.storeName}"/></h2>
                        <p><c:out value="${store.storeIntro}"/></p>
                    </div>
                </div>
            </div>
            
            <!-- 상단 액션 바 -->
            <div class="action-bar">
                <a href="javascript:void(0)" onclick="goBack()" class="back-btn">
                    <i class="back-icon">←</i>
                </a>
                <span class="store-title"><c:out value="${store.storeName}"/></span>
                <a href="javascript:void(0)" onclick="goToCart()" class="cart-link">
                    <i class="cart-icon">🛒</i>
                    <span class="cart-badge" style="display: none;">0</span>
                </a>
            </div>
            
            <!-- 탭 메뉴 -->
            <div class="tabs">
                <div class="tab active" data-tab="menu">메뉴</div>
                <div class="tab" data-tab="map">상세정보</div>
                <div class="tab" data-tab="review">리뷰</div>
            </div>
        </div>
        
        <!-- 스크롤 가능한 콘텐츠 -->
        <div class="scrollable-content" data-has-reviews="${not empty reviewList ? 'true' : 'false'}">
            <!-- 메뉴 섹션 -->
            <div class="content-section active" id="menu-section">
                
                <div class="menu-list">
                    <c:choose>
                        <c:when test="${empty menuList}">
                            <div class="no-reviews">아직 등록된 메뉴가 없습니다.</div>
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
                        <h3>🍽️ <c:out value="${store.storeName}"/></h3>
                        <c:if test="${not empty store.storeCategory}">
                            <span class="store-category-badge"><c:out value="${store.storeCategory}"/></span>
                        </c:if>
                    </div>
                    
                    <c:if test="${not empty store.storeIntro}">
                        <div class="store-intro-content">
                            <h4>📝 가게 소개</h4>
                            <p><c:out value="${store.storeIntro}"/></p>
                        </div>
                    </c:if>
                    
                    <div class="store-contact-info">
                        <div class="contact-item">
                            <i class="contact-icon">📞</i>
                            <span><c:out value="${store.storeTel}"/></span>
                        </div>
                        <div class="contact-item">
                            <i class="contact-icon">📍</i>
                            <span><c:out value="${store.storeAddress}"/></span>
                        </div>
                    </div>
                </div>
                
                <!-- 위치 및 도보 시간 섹션 -->
                <div class="location-section">
                    <div class="location-header">
                        <h4>📍 위치 정보</h4>
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
                                    <h3 style="margin-bottom:15px; color:#333;">📍 가게 위치</h3>
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
                <div class="review-list">
                    <c:choose>
                        <c:when test="${empty reviewList}">
                            <div class="no-reviews">
                                <p>아직 등록된 리뷰가 없습니다.</p>
                                <small style="color:#666;">첫 번째 리뷰를 작성해보세요!</small>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="review" items="${reviewList}" varStatus="status">
                                <div class="review-card">
                                    <div class="review-header">
                                        <img class="profile-img" src="${review.userProfile}" alt="프로필" onerror="this.src='https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800'">
                                        <span class="nickname">${review.userNickname}</span>
                                        <span class="review-date">
                                            <fmt:formatDate value="${review.reviewDate}" pattern="yyyy-MM-dd HH:mm"/>
                                        </span>
                                        <span class="stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= review.reviewStar}">⭐</c:when>
                                                    <c:otherwise>☆</c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </span>
                                    </div>
                                    <c:if test="${not empty review.reviewImage}">
                                        <div class="review-image">
                                            <img src="${review.reviewImage}" alt="리뷰 사진" onerror="this.parentElement.style.display='none'">
                                        </div>
                                    </c:if>
                                    <div class="review-content"><c:out value="${review.reviewContent}"/></div>
                                    <c:if test="${not empty review.reviewResponse}">
                                        <div class="review-response">사장님 답글: <c:out value="${review.reviewResponse}"/></div>
                                    </c:if>
                                    <div class="review-actions">
                                        <span>👍</span> <span>👎</span>
                                    </div>
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
                <span class="cart-item-count" id="cartItemCount">0</span>
                <span class="cart-amount" id="cartAmount">0원</span>
            </div>
            <button class="cart-view-btn" onclick="goToCart()">
                카트 보기
            </button>
        </div>
    </div>
    
    <!-- 외부 JavaScript 파일 (로딩 순서 중요!) -->
    <script src="${pageContext.request.contextPath}/js/urlConstants.js"></script>
    <script src="${pageContext.request.contextPath}/js/common-utils.js"></script>
    <script src="${pageContext.request.contextPath}/js/cart.js"></script>
    <script src="${pageContext.request.contextPath}/js/storedetail.js"></script>
</body>
</html>
