<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>식당 목록</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            background-color: #f5d6db; /* 연분홍 배경 */
            font-family: 'Apple SD Gothic Neo', sans-serif;
        }

        .app-container {
            max-width: 430px;
            margin: 0 auto;
            background: #fff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            position: relative;
            padding-bottom: 80px; /* 하단 바 공간 */
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px;
            border-bottom: 1px solid #ddd;
        }

        .toggle-btns {
            display: flex;
            gap: 5px;
        }

        .search-bar {
            padding: 0 15px;
            margin-top: 10px;
            display: flex;
            gap: 5px;
        }

        .category-scroll {
            overflow-x: auto;
            white-space: nowrap;
            padding: 10px 15px;
        }

        .category-btn {
            border-radius: 20px;
            padding: 6px 14px;
            font-size: 13px;
            display: inline-block;
            margin-right: 8px;
            white-space: nowrap;
        }

        .store-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
            padding: 10px 15px;
        }

        .store-card {
            border: 1px solid #ccc;
            border-radius: 10px;
            overflow: hidden;
            background: #fff;
        }

        .store-img {
            width: 100%;
            height: 120px;
            background-color: #eee;
            object-fit: cover;
        }

        .store-body {
            padding: 10px;
            font-size: 13px;
            position: relative;
        }

        .store-name {
            font-weight: bold;
            font-size: 14px;
        }

        .like-icon {
            position: absolute;
            top: 10px;
            right: 10px;
            color: #ff4d6d;
            font-size: 16px;
        }

        .bottom-nav {
            position: fixed;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 100%;
            max-width: 430px;
            background: #fff;
            border-top: 1px solid #ccc;
            display: flex;
            justify-content: space-around;
            padding: 10px 0;
            z-index: 1000;
        }

        .bottom-nav a {
            color: #555;
            text-decoration: none;
            font-size: 12px;
            text-align: center;
        }

        .bottom-nav i {
            font-size: 20px;
            display: block;
        }
    </style>
</head>
<body>

<div class="app-container">

    <!-- ✅ 상단 헤더 -->
    <div class="header">
        <div><strong>로고</strong></div>
        <div class="toggle-btns">
            <button class="btn btn-outline-secondary btn-sm">지도</button>
            <button class="btn btn-outline-secondary btn-sm">목록</button>
        </div>
        <div><i class="bi bi-list" style="font-size: 20px;"></i></div>
    </div>

    <!-- ✅ 검색바 -->
    <div class="search-bar">
        <input type="text" class="form-control" placeholder="검색어를 입력해주세요">
        <button class="btn btn-primary">검색</button>
    </div>

    <!-- ✅ 카테고리 버튼 -->
    <div class="category-scroll">
        <a href="/solfood/user/store" class="btn btn-outline-primary category-btn">전체</a>
        <a href="/solfood/user/store/category/한식" class="btn btn-outline-primary category-btn">한식</a>
        <a href="/solfood/user/store/category/카페" class="btn btn-outline-primary category-btn">카페</a>
        <a href="/solfood/user/store/category/패스트푸드" class="btn btn-outline-primary category-btn">패스트푸드</a>
    </div>

    <!-- ✅ 식당 카드 리스트 -->
    <div class="store-grid">
        <c:forEach items="${store}" var="store">
            <div class="store-card">
                <img src="${store.mainImage}" alt="${store.storeName}" class="store_mainimage">
                <div class="store-body">
                    <div class="store-name">${store.storeName}</div>
                    <div>${store.storeCategory}</div>
                    <div>⭐별점: ${store.storeAvgStar}</div>
                    <i class="bi bi-heart like-icon"></i> <!-- 찜 기능 -->
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- ✅ 하단바 -->
<div class="bottom-nav">
    <a href="#"><i class="bi bi-house"></i>홈</a>
    <a href="#"><i class="bi bi-list-check"></i>리스트</a>
    <a href="#"><i class="bi bi-calendar2-week"></i>캘린더</a>
    <a href="#"><i class="bi bi-heart-fill"></i>찜</a>
    <a href="#"><i class="bi bi-person-circle"></i>마이</a>
</div>

</body>
</html>
