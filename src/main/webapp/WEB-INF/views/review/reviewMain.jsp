<%--
  Created by IntelliJ IDEA.
  User: fzaca
  Date: 25. 6. 18.
  Time: 오후 5:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Sol Food - 맛집 리뷰 시스템</title>
  <style>
    body {
      font-family: 'Arial', sans-serif;
      margin: 0;
      padding: 0;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .container {
      background: white;
      padding: 50px;
      border-radius: 20px;
      box-shadow: 0 20px 40px rgba(0,0,0,0.1);
      text-align: center;
      max-width: 600px;
      width: 90%;
    }
    h1 {
      color: #333;
      margin-bottom: 20px;
      font-size: 2.5em;
    }
    .subtitle {
      color: #666;
      margin-bottom: 40px;
      font-size: 1.2em;
    }
    .btn {
      display: inline-block;
      padding: 15px 30px;
      margin: 10px;
      background: #667eea;
      color: white;
      text-decoration: none;
      border-radius: 10px;
      font-size: 1.1em;
      transition: all 0.3s ease;
    }
    .btn:hover {
      background: #5a6fd8;
      transform: translateY(-2px);
      box-shadow: 0 5px 15px rgba(0,0,0,0.2);
    }
    .features {
      margin-top: 40px;
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 20px;
    }
    .feature {
      padding: 20px;
      background: #f8f9fa;
      border-radius: 10px;
      border-left: 4px solid #667eea;
    }
    .feature h3 {
      color: #333;
      margin-bottom: 10px;
    }
    .feature p {
      color: #666;
      font-size: 0.9em;
    }
  </style>
</head>
<body>
<div class="container">
  <h1>🍽️ Sol Food</h1>
  <p class="subtitle">맛집 리뷰 시스템에 오신 것을 환영합니다!</p>

  <div>
    <a href="${pageContext.request.contextPath}/review/list" class="btn">📋 리뷰 목록 보기</a>
    <a href="${pageContext.request.contextPath}/review/write" class="btn">✏️ 리뷰 작성하기</a>
  </div>

  <div class="features">
    <div class="feature">
      <h3>📝 리뷰 작성</h3>
      <p>방문한 맛집에 대한 상세한 리뷰를 작성하고 평점을 남겨보세요.</p>
    </div>
    <div class="feature">
      <h3>🔍 리뷰 검색</h3>
      <p>식당명으로 리뷰를 검색하여 다른 사람들의 경험을 확인해보세요.</p>
    </div>
    <div class="feature">
      <h3>⭐ 평점 시스템</h3>
      <p>1-5점 평점 시스템으로 맛집의 품질을 객관적으로 평가해보세요.</p>
    </div>
  </div>
</div>
</body>
</html>