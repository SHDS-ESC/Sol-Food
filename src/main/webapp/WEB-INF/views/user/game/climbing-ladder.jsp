<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사다리타기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/game/climbing-ladder.css">
</head>
<body>
<div class="container">
    <div class="container">
        <h1>✨사다리타기✨</h1>

        <div class="setup-section">
            <div class="input-group">
                <div class="input-container">
                    <label for="participants">참가자 수</label>
                    <input type="number" id="participants" min="2" max="10" value="4">
                </div>
                <div class="input-container">
                    <label for="lines">가로줄 수</label>
                    <input type="number" id="lines" min="5" max="20" value="10">
                </div>
                <button class="btn" onclick="generateLadder()">사다리 생성</button>
            </div>

            <div class="labels-section">
                <h3 style="margin-bottom: 15px; color: #555;">참가자 이름과 결과를 입력하세요</h3>
                <div class="labels-container" id="labelsContainer">
                    <!-- 동적으로 생성됨 -->
                </div>
            </div>
        </div>

        <div class="instruction">
            🎯 시작점(참가자)을 클릭하여 사다리타기를 시작하세요!
        </div>

        <div class="ladder-container">
            <div class="ladder" id="ladder">
                <!-- 사다리가 여기에 생성됩니다 -->
            </div>
        </div>

        <div class="result" id="result">
            <!-- 결과가 여기에 표시됩니다 -->
        </div>

        <div class="controls">
            <button class="btn btn-reset" onclick="resetLadder()">🔄 초기화</button>
        </div>
    </div>
<script src="${pageContext.request.contextPath}/js/game/climbing-ladder.js"
        type="text/javascript"
        charset="UTF-8"></script>
</body>
</html>