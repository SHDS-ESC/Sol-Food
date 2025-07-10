<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <!-- <link
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
          rel="stylesheet"
        /> -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    <title>solfood</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/reset.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/mypage/prev-withdraw.css"
    />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

  </head>
  <body>
    <div class="wrap">
      <jsp:include page="../include/backbtn-header.jsp" />
      <div class="content mypage-withdraw">
        <div class="info">
          <h1>${userLoginSession.usersNickname}님,<br />탈퇴하기 전에 꼭 확인해주세요.</h1>
        </div>
        <ul class="withdraw-ul">
          <li>
            <i class="bi bi-info-lg"></i>
            <p>보유한<br />모든 포인트와 쿠폰이 사라져요.</p>
            <span>또한 다시가입하더라도 첫 가입 혜택을 받을 수 없어요.</span>
          </li>
          <li>
            <i class="bi bi-arrow-through-heart"></i>
            <p>즐겨찾기, 찜한 상품 등<br />소중한 기록이 모두 사라져요.</p>
            <span>탈퇴하면 되돌릴 수 없어요.</span>
          </li>
        </ul>
        <div class="footer flex flex-sa" style="left: 0">
          <form
            action="${pageContext.request.contextPath}/user/mypage/withdraw"
            method="post"
            style="width: 100%; box-sizing: border-box"
          >
            <button class="footer-btn" type="submit">탈퇴하기</button>
          </form>
        </div>
      </div>
    </div>

    <!-- 팝업 -->
    <div class="popup-overlay" style="display: none">
      <div class="popup-box">
        <p class="popup-text">탈퇴가 성공적으로 처리되었습니다.</p>
        <div class="flex">
          <button class="btn submit popup-close">확인</button>
        </div>
      </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
    <script>
      //   $(document).ready(function () {
      //     $(".footer-btn").on("click", function () {
      //       $(".popup-overlay").fadeIn(200); // 팝업 배경과 함께 등장
      //     });
      //     // 팝업 닫기
      //     $(".popup-close, .popup-overlay").on("click", function (e) {
      //       // 팝업 바깥 영역 클릭 시에도 닫히도록
      //       if (
      //         $(e.target).is(".popup-close") ||
      //         $(e.target).is(".popup-overlay")
      //       ) {
      //         $(".popup-overlay").fadeOut(200);
      //       }
      //     });
      //   });
    </script>
  </body>
</html>
