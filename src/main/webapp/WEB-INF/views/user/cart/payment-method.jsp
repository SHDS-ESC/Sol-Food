<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>결제 방식 선택 - Sol Food</title>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- Common CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reset.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment-method.css?v=${pageContext.session.creationTime}" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment-method-dark.css?v=${pageContext.session.creationTime}" />
</head>
<body>
    <div class="wrap">
        <jsp:include page="../include/backbtn-header.jsp" />

        <!-- 컨텐츠 -->
        <div class="content payment-method">
            <div class="payment-container">

                <!-- 주문 내역 -->
                <div class="receipt">
                    <div class="receipt-header">
                        <span>주문 내역</span>
                        <span>금액</span>
                    </div>
                    <div class="menu-list">
                        <c:forEach items="${cart.items}" var="item">
                            <div class="menu-item">
                                <div class="menu-main">
                                    <div class="menu-name-row">
                                        <span class="menu-name">${item.menuName}</span>
                                        <span class="menu-quantity">
                                            <span class="unit-price">
                                                (<fmt:formatNumber value="${item.menuPrice}" pattern="#,###"/>)
                                            </span>
                                            ${item.quantity}개
                                        </span>
                                    </div>
                                    <div class="menu-price">
                                        <fmt:formatNumber value="${item.menuPrice * item.quantity}" pattern="#,###"/>원
                                    </div>
                                </div>
                                <c:if test="${not empty item.options}">
                                    <div class="menu-options" data-menu-id="${item.menuId}">
                                        <script type="application/json" class="options-data">
                                            ${item.options}
                                        </script>
                                        <c:if test="${not empty item.menuExtra}">
                                            <script type="application/json" class="menu-extra-data">
                                                ${item.menuExtra}
                                            </script>
                                        </c:if>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="total-section">
                        <div class="total-row">
                            <span>주문 금액</span>
                            <span><fmt:formatNumber value="${cart.totalAmount}" pattern="#,###"/>원</span>
                        </div>
                        <div class="total-row final">
                            <span>총 결제금액</span>
                            <span class="final-price" style="color: #ff3b30;"><fmt:formatNumber value="${cart.totalAmount}" pattern="#,###"/>원</span>
                        </div>
                    </div>
                </div>

                <!-- 결제 방식 선택 -->
                <div class="payment-methods">
                    <button class="payment-option" data-method="solo">
                        <div class="emoji">😊</div>
                        <div class="payment-title">혼자 결제하기</div>
                        <div class="payment-desc">
                            일반적인 개인 결제 방식입니다.<br>
                            바로 결제를 진행합니다.
                        </div>
                    </button>

                    <button class="payment-option" data-method="group">
                        <div class="emoji">👥</div>
                        <div class="payment-title">함께 결제하기</div>
                        <div class="payment-desc">
                            친구들과 함께 나눠서 결제합니다.<br>
                            더치페이 및 미니게임을 즐길 수 있어요!
                        </div>
                    </button>
                </div>
            </div>
        </div>

        <!-- 결제 버튼: 푸터 위에 고정 -->
        <div class="footer-btn-bar">
            <button class="footer-btn" id="continueBtn" disabled>
                <span class="total-amount"><fmt:formatNumber value="${cart.totalAmount}" pattern="#,###"/>원</span>
                다음 단계로
            </button>
        </div>


    </div>

<!-- JavaScript -->
<script>
    var contextPath = '${pageContext.request.contextPath}';

    // 옵션 정보 렌더링
    document.addEventListener('DOMContentLoaded', function() {
        const menuOptions = document.querySelectorAll('.menu-options');

        menuOptions.forEach(function(menuOption) {
            const optionsData = menuOption.querySelector('.options-data');
            const menuExtraData = menuOption.querySelector('.menu-extra-data');

            if (optionsData && menuExtraData) {
                try {
                    const selectedOptions = JSON.parse(optionsData.textContent.trim());
                    const optionGroups = JSON.parse(menuExtraData.textContent.trim());
                    let optionsHtml = '';

                    Object.entries(selectedOptions).forEach(([category, selected]) => {
                        const group = optionGroups.find(g => g.groupName === category);

                        if (group && Array.isArray(selected)) {
                            optionsHtml += '<div class="option-title">추가옵션</div>';

                            selected.forEach((optionName) => {
                                const optionInfo = group.options.find(opt => opt.name === optionName);

                                if (optionInfo) {
                                    // 옵션 이름에서 모든 + 기호와 앞뒤 공백 제거
                                    const cleanOptionName = optionName.replace(/^\+\s*/, '').replace(/^\+/, '').trim();

                                    optionsHtml +=
                                        '<div class="option-row">' +
                                            '<span class="option-plus">+</span>' +
                                            '<span class="option-name">' + cleanOptionName + '</span>' +
                                            '<span class="option-price">(' + (optionInfo.price > 0 ? '+' + optionInfo.price.toLocaleString() : '0') + '원)</span>' +
                                        '</div>';
                                }
                            });
                        }
                    });

                    menuOption.innerHTML = optionsHtml;
                } catch (e) {
                    console.error('옵션 파싱 에러:', e);
                    menuOption.innerHTML = '옵션 정보를 불러올 수 없습니다.';
                }
            }
        });
    });
</script>

<!-- URL Constants -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="<c:url value='/js/urlConstants.js' />"></script>
<!-- Common Utils -->
<script src="<c:url value='/js/common-utils.js' />"></script>
<!-- Payment Method JavaScript -->
<script src="<c:url value='/js/payment-method.js' />"></script>
<!-- Darkmode JavaScript -->
<script src="<c:url value='/js/darkmode.js' />"></script>
</body>
</html> 