<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>💳 카드 계산 뽑기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/game/roulette.css">
</head>
<body>
<div class="restaurant-container">
    <div class="restaurant-header">
        <div class="restaurant-name">🍽️ 맛있는 집</div>
        <div class="restaurant-subtitle">식사 감사합니다! 카드 계산 뽑기에 도전해보세요!</div>
    </div>

    <div class="bill-section">
        <div class="bill-item">
            <span>🍜 김치찌개</span>
            <span>8,000원</span>
        </div>
        <div class="bill-item">
            <span>🍚 공기밥</span>
            <span>2,000원</span>
        </div>
        <div class="bill-item">
            <span>🥤 음료수</span>
            <span>3,000원</span>
        </div>
        <div class="bill-item">
            <span>🥗 밑반찬</span>
            <span>무료</span>
        </div>

        <div class="bill-total">
            <div class="bill-item">
                <span>총 금액</span>
                <span>13,000원</span>
            </div>
        </div>

        <div class="payment-info">
            💳 카드로 결제하실 분을 뽑아드립니다!
        </div>
    </div>

    <div class="lottery-machine">
        <div class="lottery-screen" id="lotteryScreen">
            🎲 버튼을 눌러서<br>카드 계산 뽑기에 도전하세요!
        </div>

        <button class="lottery-button" id="lotteryButton" onclick="drawPrize()">
            뽑기<br>START!
        </button>
    </div>

    <div class="prizes-grid">
        <div class="prize-card" id="prize-sangUn">
            <div class="prize-emoji">
                <img src="https://github.com/5y1ee.png" alt="이상윤" class="github-profile">
            </div>
            <div class="prize-name">이상윤</div>
            <div class="prize-description">카드 계산</div>
        </div>

        <div class="prize-card" id="prize-jiwon">
            <div class="prize-emoji">
                <img src="https://github.com/jiwonns.png" alt="박지원" class="github-profile">
            </div>
            <div class="prize-name">박지원</div>
            <div class="prize-description">카드 계산</div>
        </div>

        <div class="prize-card" id="prize-gahee">
            <div class="prize-emoji">
                <img src="https://github.com/ogh010.png" alt="오가희" class="github-profile">
            </div>
            <div class="prize-name">오가희</div>
            <div class="prize-description">카드 계산</div>
        </div>

        <div class="prize-card" id="prize-sunwoo">
            <div class="prize-emoji">
                <img src="https://github.com/dlsundn.png" alt="이선우" class="github-profile">
            </div>
            <div class="prize-name">이선우</div>
            <div class="prize-description">카드 계산</div>
        </div>

        <div class="prize-card" id="prize-minseok">
            <div class="prize-emoji">
                <img src="https://github.com/sngsngUDON.png" alt="안민석" class="github-profile">
            </div>
            <div class="prize-name">안민석</div>
            <div class="prize-description">카드 계산</div>
        </div>

        <div class="prize-card" id="prize-again">
            <div class="prize-emoji">🔄</div>
            <div class="prize-name">다시 뽑기</div>
            <div class="prize-description">한번 더!</div>
        </div>
    </div>

    <button class="reset-button" onclick="resetGame()">
        🔄 다시 주문하기
    </button>
</div>

<div class="celebration" id="celebration"></div>

<script src="${pageContext.request.contextPath}/js/game/roulette.js"
        type="text/javascript"
        charset="UTF-8"></script>

</body>
</html>