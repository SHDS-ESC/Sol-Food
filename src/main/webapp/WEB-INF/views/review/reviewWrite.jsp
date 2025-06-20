<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>리뷰 작성</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"], textarea, select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
            box-sizing: border-box;
        }
        textarea {
            height: 150px;
            resize: vertical;
        }
        .rating-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .star-rating {
            font-size: 24px;
            cursor: pointer;
        }
        .star-rating input {
            display: none;
        }
        .star-rating label {
            cursor: pointer;
            color: #ddd;
        }
        .star-rating input:checked ~ label {
            color: #ffc107;
        }
        .star-rating label:hover,
        .star-rating label:hover ~ label {
            color: #ffc107;
        }
        .btn-container {
            text-align: center;
            margin-top: 30px;
        }
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin: 0 10px;
        }
        .btn-primary {
            background: #667eea;
            color: white;
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>✏️ 리뷰 작성</h1>
        <p>맛집 경험을 공유해보세요!</p>
    </div>

    <div class="form-container">
        <form action="${pageContext.request.contextPath}/review/write" method="post">
            <div class="form-group">
                <label for="usersId">사용자 ID *</label>
                <input type="number" id="usersId" name="usersId" required placeholder="사용자 ID를 입력하세요">
            </div>
            <div class="form-group">
                <label for="storeId">가게 ID *</label>
                <input type="number" id="storeId" name="storeId" required placeholder="가게 ID를 입력하세요">
            </div>
            <div class="form-group">
                <label for="usersPaymentId">결제 ID *</label>
                <input type="number" id="usersPaymentId" name="usersPaymentId" required placeholder="결제 ID를 입력하세요">
            </div>
            <div class="form-group">
                <label for="reviewCommentId">리뷰 댓글 ID *</label>
                <input type="number" id="reviewCommentId" name="reviewCommentId" required placeholder="리뷰 댓글 ID를 입력하세요">
            </div>
            <div class="form-group">
                <label>평점(REVIEW_STAR) *</label>
                <div class="rating-container">
                    <div class="star-rating">
                        <input type="radio" name="reviewStar" value="5" id="star5" required>
                        <label for="star5">⭐</label>
                        <input type="radio" name="reviewStar" value="4" id="star4">
                        <label for="star4">⭐</label>
                        <input type="radio" name="reviewStar" value="3" id="star3">
                        <label for="star3">⭐</label>
                        <input type="radio" name="reviewStar" value="2" id="star2">
                        <label for="star2">⭐</label>
                        <input type="radio" name="reviewStar" value="1" id="star1">
                        <label for="star1">⭐</label>
                    </div>
                    <span id="rating-text">평점을 선택해주세요</span>
                </div>
            </div>
            <div class="form-group">
                <label for="reviewImage">리뷰 이미지</label>
                <input type="text" id="reviewImage" name="reviewImage" placeholder="이미지 URL을 입력하세요">
            </div>
            <div class="form-group">
                <label for="reviewDate">리뷰 날짜</label>
                <input type="date" id="reviewDate" name="reviewDate">
            </div>
            <div class="form-group">
                <label for="reviewStatus">리뷰 상태</label>
                <input type="text" id="reviewStatus" name="reviewStatus" placeholder="리뷰 상태를 입력하세요">
            </div>
            <div class="form-group">
                <label for="reviewTitle">리뷰 제목 *</label>
                <input type="text" id="reviewTitle" name="reviewTitle" required placeholder="리뷰 제목을 입력하세요">
            </div>
            <div class="form-group">
                <label for="reviewContent">리뷰 내용 *</label>
                <textarea id="reviewContent" name="reviewContent" required placeholder="맛집에 대한 상세한 리뷰를 작성해주세요."></textarea>
            </div>
            <div class="form-group">
                <label for="reviewResponse">사장님 답글</label>
                <input type="text" id="reviewResponse" name="reviewResponse" placeholder="사장님 답글을 입력하세요">
            </div>
            <div class="btn-container">
                <button type="submit" class="btn btn-primary">리뷰 등록</button>
                <a href="${pageContext.request.contextPath}/review/list" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>

    <script>
        // 평점 선택 시 텍스트 업데이트
        const ratingInputs = document.querySelectorAll('input[name="reviewStar"]');
        const ratingText = document.getElementById('rating-text');
        
        ratingInputs.forEach(input => {
            input.addEventListener('change', function() {
                const rating = this.value;
                const ratingDescriptions = {
                    '1': '매우 나쁨',
                    '2': '나쁨', 
                    '3': '보통',
                    '4': '좋음',
                    '5': '매우 좋음'
                };
                ratingText.textContent = `${rating}점 - ${ratingDescriptions[rating]}`;
            });
        });
    </script>
</body>
</html> 