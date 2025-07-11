<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Sol-Food</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script>
        var contextPath = '${pageContext.request.contextPath}';
    </script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/reset.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/index.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
<body>
<div class="wrap">
    <%@ include file="/WEB-INF/views/user/include/header.jsp" %>
    <div class="content main">
        <div class="main-content">

            <c:if test="${not empty sessionScope.userLoginSession}">
                <!-- 유저 정보/포인트 카드 -->
                <div class="user-main-summary-card">
                    <div class="user-main-summary-head">
                        <div class="user-welcome-section">
                            <div class="user-main-summary-name" style="display:flex">
                                <span class="user-name"style="font-size:20px">${sessionScope.userLoginSession.usersNickname} </span>
                                    <span>님</span>
                            </div>
                            <div class="user-main-summary-slogan">오늘도 든든하게 :)</div>
                        </div>
                    </div>
                    <div class="point-charge-card">
                        <div class="point-display-section">
                            <div class="user-main-summary-point-wrap big">
                                <span class="user-main-summary-point">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.userLoginSession.usersPoint}">
                                            <fmt:formatNumber value="${sessionScope.userLoginSession.usersPoint}" pattern="#,##0"/>
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                P
                                </span>

                            </div>
                            <a href="${pageContext.request.contextPath}/user/mypage/charge" class="user-main-summary-mybtn join-btn pink-btn">
                               MY>
                            </a>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- 이벤트(배너) 영역 -->
            <section class="main-banner">
                <div class="banner-slider">
                    <div class="banner-item active">
                        <img src="${pageContext.request.contextPath}/img/event1.jpg" class="banner-img" alt="신규회원 웰컴 이벤트">
                    </div>
                    <div class="banner-item">
                        <img src="${pageContext.request.contextPath}/img/event2.jpg" class="banner-img" alt="친구초대 이벤트">
                    </div>
                </div>
                <div class="banner-dots">
                    <span class="dot active" onclick="currentSlide(1)"></span>
                    <span class="dot" onclick="currentSlide(2)"></span>
                </div>
            </section>

            <!-- 인기 식당 Top 10 -->
            <section class="popular-section">
                <div class="section-header">
                    <h2 class="section-title">인기 식당 Top 10</h2>
                    <button class="popular-more-btn" onclick="location.href='${pageContext.request.contextPath}/user/store/list'" style="color:var(--color-black)">
                        <span>더보기</span>
                        <i class="bi bi-chevron-right"></i>
                    </button>
                </div>
                <div class="popular-slider-wrap">
                    <button class="slider-btn left" id="prevBtn">
                        <i class="bi bi-chevron-left"></i>
                    </button>
                    <div class="popular-slider" id="popularSlider">
                        <%-- JS가 동적으로 인기식당 카드를 추가 --%>
                    </div>
                    <button class="slider-btn right" id="nextBtn">
                        <i class="bi bi-chevron-right"></i>
                    </button>
                </div>
            </section>

            <!-- 메인 메뉴 그리드 -->
            <section class="main-menu-section">
                <div class="section-header">
                    <h2 class="section-title">서비스 메뉴</h2>
                </div>
                <div class="main-menu-grid">
                    <a class="menu-card primary" href="<c:url value='/user/store/list'/>">
                        <div class="menu-icon">🍽️</div>
                        <div class="menu-content">
                            <div class="menu-title">식사하기</div>
                            <div class="menu-subtitle">맛있는 음식을 주문하세요</div>
                        </div>
                    </a>
                    <a class="menu-card secondary" onclick="location.href='${pageContext.request.contextPath}/user/board/list'" style="cursor: pointer;">
                        <div class="menu-icon">💬</div>
                        <div class="menu-content">
                            <div class="menu-title">커뮤니티</div>
                            <div class="menu-subtitle">다양한 이야기를 나눠보세요</div>
                        </div>
                    </a>
<%--                    <a class="menu-card accent" href="#" onclick="alert('제휴 문의는 contact@solfood.com 으로!')">--%>
<%--                        <div class="menu-icon">🤝</div>--%>
<%--                        <div class="menu-content">--%>
<%--                            <div class="menu-title">제휴 문의</div>--%>
<%--                            <div class="menu-subtitle">비즈니스 파트너십</div>--%>
<%--                        </div>--%>
<%--                    </a>--%>
<%--                    <a class="menu-card support" href="#" onclick="alert('후원 기능은 곧 오픈됩니다!')">--%>
<%--                        <div class="menu-icon">💝</div>--%>
<%--                        <div class="menu-content">--%>
<%--                            <div class="menu-title">후원</div>--%>
<%--                            <div class="menu-subtitle">따뜻한 마음을 전해보세요</div>--%>
<%--                        </div>--%>
<%--                    </a>--%>
                </div>
            </section>
        </div>
        <%@ include file="/WEB-INF/views/user/include/footer.jsp" %>
    </div>
</div>

<!-- JS 리소스는 마지막에 한 번에 정리 -->
<script src="<c:url value='/js/urlConstants.js' />"></script>
<script src="<c:url value='/js/common-utils.js' />?v=${pageContext.session.creationTime}"></script>
<script src="<c:url value='/js/cart.js' />?v=${pageContext.session.creationTime}"></script>
<script src="<c:url value='/js/store.js' />?v=${pageContext.session.creationTime}"></script>
<script src="<c:url value='/js/darkmode.js' />"></script>
<script src="<c:url value='/js/index.js' />"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        // 배너 슬라이더 자동 전환
        initBannerSlider();
    });

    // 배너 슬라이더 기능
    let currentSlideIndex = 0;

    function initBannerSlider() {
        const slides = document.querySelectorAll('.banner-item');
        const dots = document.querySelectorAll('.dot');

        if (slides.length > 1) {
            setInterval(() => {
                currentSlideIndex = (currentSlideIndex + 1) % slides.length;
                showSlide(currentSlideIndex);
            }, 5000); // 5초마다 자동 전환
        }
    }

    function currentSlide(n) {
        currentSlideIndex = n - 1;
        showSlide(currentSlideIndex);
    }

    function showSlide(index) {
        const slides = document.querySelectorAll('.banner-item');
        const dots = document.querySelectorAll('.dot');

        slides.forEach((slide, i) => {
            slide.classList.toggle('active', i === index);
        });

        dots.forEach((dot, i) => {
            dot.classList.toggle('active', i === index);
        });
    }
</script>
</body>
</html>