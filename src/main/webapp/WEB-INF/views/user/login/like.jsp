<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>찜 목록</title>
    <script>
        // Context Path를 JavaScript에서 사용할 수 있도록 설정
        var contextPath = '${pageContext.request.contextPath}';
        // 로그인한 사용자 ID를 JavaScript에서 사용할 수 있도록 설정
        window.loginUserId = '${sessionScope.userLoginSession.usersId}';
    </script>
    <link href="<c:url value='/css/store.css' />" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <style>
        .store-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            padding: 20px;
        }
        
        /* 찜 페이지 하트 버튼 스타일 - store 메인과 동일 */
        .like-btn {
            background: none;
            border: none;
            outline: none;
            cursor: pointer;
            position: absolute;
            top: 12px;
            right: 12px;
            z-index: 10;
            padding: 0;
        }
        
        .like-btn i {
            font-size: 20px;
            transition: color 0.2s;
        }
        
        .like-btn .bi-heart {
            color: #bbb;
        }
        
        .like-btn .bi-heart-fill {
            color: #ff4d6d;
        }
        
        .like-btn.liked .bi-heart {
            color: #ff4d6d;
        }
        
        .like-btn.liked .bi-heart-fill {
            color: #ff4d6d;
        }
    </style>
</head>
    <body>
    <div class="app-container">
        <div class="header">
            <h3>내 찜 목록</h3>
        </div>
        <div class="store-count">
            <span>찜한 식당 수: <span id="likeCount">${totalCount}개</span></span>
        </div>
        <div class="store-grid" id="storeGrid">
            <!-- JS로 동적으로 store 목록이 추가될 것 -->
        </div>
        <button id="loadMoreBtn" class="more-btn" style="width:100%;margin:20px auto;display:none;">더보기</button>
    </div>
        <script src="<c:url value='/js/urlConstants.js' />"></script>
<script src="<c:url value='/js/like.js' />"></script>
        <script src="<c:url value='/js/store.js' />"></script>
</body>
</html>