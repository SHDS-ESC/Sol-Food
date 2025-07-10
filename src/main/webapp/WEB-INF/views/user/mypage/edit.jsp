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
      href="${pageContext.request.contextPath}/css/mypage/edit.css"
    />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  </head>
  <body>
    <div class="wrap">
        <%--헤더--%>
        <jsp:include page="../include/backbtn-header.jsp" />
      <div class="content mypage">
        <div class="info">
          <h1>${userLoginSession.usersNickname}</h1>
          <p>${userLoginSession.usersEmail}</p>
        </div>
        <ul>
          <li >
              <a class="flex flex-sb" href="${pageContext.request.contextPath}/user/mypage/info">
                <p>회원정보 수정</p>
                <i class="bi bi-chevron-right"></i>
              </a>
          </li>
            <li >
                <a class="flex flex-sb" href="${pageContext.request.contextPath}/user/mypage/prev-withdraw">
                    <p>회원탈퇴</p>
                    <i class="bi bi-chevron-right"></i>
                </a>
            </li>
        </ul>
      </div>
        <%--푸터--%>
        <jsp:include page="../include/footer.jsp" />

    </div>
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
    <script src="${pageContext.request.contextPath}/js/popup.js"></script>
    <script>
      function confirmAction(text,type){
        if(type == 'logout'){
          showConfirmPopup(text, function() {
            location.href = `${pageContext.request.contextPath}/user/login/logout`
          });
        }
      }
    </script>
  </body>
</html>
