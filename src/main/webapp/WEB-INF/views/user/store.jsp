<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전체 가게 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
      body {
          background-color: #f5d6db; /* 연분홍 배경 */
          font-family: 'Apple SD Gothic Neo', sans-serif;
      }

      .category-btn {
          border-radius: 20px;
          padding: 6px 18px;
          font-size: 14px;
          margin: 0 5px 10px 0;
      }

      .store-card {
          padding: 10px;
      }

      .card {
          border: none;
          border-radius: 15px;
          box-shadow: 0 4px 12px rgba(0,0,0,0.1);
          overflow: hidden;
          height: 100%;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
      }

      .card-img-placeholder {
          background-color: #eee;
          width: 100%;
          aspect-ratio: 1 / 1;
      }

      .card-body {
          padding: 12px;
      }

      .card-title {
          font-size: 18px;
          font-weight: bold;
      }

      .card-text {
          margin-bottom: 5px;
          font-size: 14px;
      }

      .like-icon {
          float: right;
          font-size: 18px;
          color: #ff4d6d;
          cursor: pointer;
      }

      .bottom-nav {
          position: fixed;
          bottom: 0;
          left: 0;
          right: 0;
          background: white;
          border-top: 1px solid #ddd;
          display: flex;
          justify-content: space-around;
          padding: 10px 0;
      }

      .bottom-nav i {
          font-size: 20px;
      }
  </style>

</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">전체 가게 목록</h2>

    <!-- ✅ 카테고리 버튼 영역 -->
    <div class="mb-4">
        <a href="/solfood/user/store" class="btn btn-outline-primary category-btn">전체</a>
        <a href="/solfood/user/store/category/한식" class="btn btn-outline-primary category-btn">한식</a>
        <a href="/solfood/user/store/category/카페" class="btn btn-outline-primary category-btn">카페</a>
        <a href="/solfood/user/store/category/패스트푸드" class="btn btn-outline-primary category-btn">패스트푸드</a>
    </div>

    <!-- ✅ 가게 목록 영역 -->
    <div class="row">
        <c:forEach items="${store}" var="store">
            <div class="col-md-4 store-card">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">${store.storeName}</h5>
                        <p class="card-text">
                            <span class="badge bg-secondary">${store.storeCategory}</span>
                        </p>
                        <p class="card-text">${store.storeAddress}</p>
                        <p class="card-text">⭐ 평균 평점: ${store.storeAvgStar}</p>
                        <a href="/store/detail/${store.storeId}" class="btn btn-primary">상세보기</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>
