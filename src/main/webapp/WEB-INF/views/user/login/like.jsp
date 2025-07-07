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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    <style>
        .store-grid {
            display: flex;
            flex-direction: column;
            gap: 24px;
            padding: 20px 0 40px 0;
            max-width: 620px;
            margin: 0 auto;
        }

        .store-card {
            display: flex;
            align-items: center;
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
            padding: 20px 24px;
            position: relative;
            min-height: 110px;
            transition: box-shadow 0.15s;
        }
        .store-card:hover {
            box-shadow: 0 8px 24px rgba(0,0,0,0.12);
        }

        .store-mainimage {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: 10px;
            margin-right: 28px;
            flex-shrink: 0;
            background: #f9f9f9;
            border: 1px solid #f3f3f3;
        }

        .store-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 3px;
        }

        .store-title {
            font-size: 1.13rem;
            font-weight: 600;
            margin-bottom: 3px;
        }

        .store-category {
            font-size: 0.98rem;
            color: #888;
        }
        .store-address {
            font-size: 0.98rem;
            color: #666;
        }
        .store-rating {
            font-size: 0.97rem;
            color: #ffb300;
        }
        .store-tel {
            font-size: 0.97rem;
            color: #46b48c;
        }

        /* 하트 버튼은 기존 스타일 그대로 써도 됩니다 */
        .like-btn {
            background: none;
            border: none;
            outline: none;
            cursor: pointer;
            position: absolute;
            top: 22px;
            right: 24px;
            z-index: 10;
            padding: 0;
        }
        .like-btn i {
            font-size: 22px;
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
        .store-img {
            width: 90px;         /* 원하는 고정 크기(px) */
            height: 90px;
            object-fit: cover;   /* 이미지가 꽉 차게, 찌그러지지 않게 */
            border-radius: 10px;
            margin-right: 28px;
            flex-shrink: 0;
            background: #f9f9f9;
            border: 1px solid #f3f3f3;
            display: block;
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
        <script src="<c:url value='/js/common-utils.js' />"></script>
        <script src="<c:url value='/js/like.js' />"></script>
</body>
</html>