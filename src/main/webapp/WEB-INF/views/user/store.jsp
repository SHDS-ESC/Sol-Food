<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전체 가게 목록</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .store-card {
            margin-bottom: 20px;
        }
        .category-btn {
            margin-right: 10px;
        }
    </style>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">전체 가게 목록</h2>

    <!-- ✅ 카테고리 버튼 영역 -->
    <div class="mb-4">
        <a href="/user/store" class="btn btn-outline-primary category-btn">전체</a>
        <a href="/user/store/category/한식" class="btn btn-outline-primary category-btn">한식</a>
        <a href="/user/store/category/카페" class="btn btn-outline-primary category-btn">카페</a>
        <a href="/user/store/category/패스트푸드" class="btn btn-outline-primary category-btn">패스트푸드</a>
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
