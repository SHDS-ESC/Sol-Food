<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>찜 목록</title>
    <link href="<c:url value='/css/store.css' />" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <style>
        .store-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        .like-btn.liked {
            background-color: #ff4b4b;
            color: white;
            border: none;
        }
    </style>
</head>
    <body>
    <div class="app-container">
        <div class="header">
            <h3>내 찜 목록</h3>
        </div>
        <div class = "store-count">
            <span>찜한 식당 수: <span id="likeCount">${store.totalCount}개</span></span>
        <div class="store-grid" id="storeGrid">
            <!-- JS로 동적으로 store 목록이 추가될 것 -->
        </div>
        <button id="loadMoreBtn" class="more-btn" style="width:100%;margin:20px auto;display:none;">더보기</button>
    </div>
        <script src="<c:url value='/js/like.js' />"></script>
        <script src="<c:url value='/js/store.js' />"></script>
</body>
</html>