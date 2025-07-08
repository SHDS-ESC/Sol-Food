<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
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
      href="${pageContext.request.contextPath}/css/login/native-login.css"
    />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

    <c:if test="${not empty msg}">
      <script>
        $(function () {
          alert("${msg}");
        });
      </script>
    </c:if>
  </head>
  <body>
    <div class="wrap">
      <div class="header flex flex-sb">
        <div><strong>로고</strong></div>
        <div style="display: flex; gap: 12px; align-items: center">
          <button
            id="darkmode-toggle"
            style="
              background: none;
              border: none;
              cursor: pointer;
              font-size: 20px;
              color: var(--color-black);
            "
          >
            <i class="bi bi-moon"></i>
          </button>
          <i class="bi bi-list" style="font-size: 20px"></i>
        </div>
      </div>
      <div class="content native-login">
        <form
          class="native-login-form"
          action="${pageContext.request.contextPath}/user/login/native-login"
          method="post"
        >
          <div class="form-group">
            <label for="email">이메일</label>
            <input
              id="email"
              type="email"
              class="border-input"
              placeholder="example@example.com"
              name="usersEmail"
            />
            <!-- <div class="border-error">올바른 이메일 주소를 입력해 주세요</div> -->
          </div>
          <div class="form-group">
            <label for="password">비밀번호</label>
            <input
              id="password"
              type="password"
              class="border-input"
              placeholder="영문/숫자/특수문자 혼합 8~20자"
              name="usersPwd"
            />
            <div class="c-kfnGxn eye-closed" style="display: none">
              <svg
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M4.13149 12.556C3.99969 12.3329 3.89893 12.1429 3.8274 12C3.89893 11.8571 3.99969 11.6671 4.13149 11.444C4.44195 10.9187 4.92019 10.2174 5.58797 9.51786C6.91833 8.12415 8.9838 6.75 12 6.75C15.0162 6.75 17.0817 8.12415 18.412 9.51786C19.0798 10.2174 19.5581 10.9187 19.8685 11.444C20.0003 11.6671 20.1011 11.8571 20.1726 12C20.1011 12.1429 20.0003 12.3329 19.8685 12.556C19.5581 13.0813 19.0798 13.7826 18.412 14.4821C17.0817 15.8759 15.0162 17.25 12 17.25C8.9838 17.25 6.91833 15.8759 5.58797 14.4821C4.92019 13.7826 4.44195 13.0813 4.13149 12.556Z"
                  stroke="#BDBDBD"
                  stroke-width="1.5"
                ></path>
                <circle cx="12" cy="12" r="3" fill="#BDBDBD"></circle>
              </svg>
            </div>

            <div class="c-kfnGxn eye-open">
              <svg
                width="24"
                height="24"
                viewBox="0 0 24 24"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M9.87869 14.1213C11.0503 15.2929 12.9498 15.2929 14.1213 14.1213L9.87869 9.87866C8.70712 11.0502 8.70712 12.9497 9.87869 14.1213Z"
                  fill="#BDBDBD"
                ></path>
                <path
                  fill-rule="evenodd"
                  clip-rule="evenodd"
                  d="M7.86229 6.92295C4.38865 8.60551 3 12 3 12C3 12 5.45455 18 12 18C14.2282 18 15.9823 17.3047 17.3268 16.3875L16.2441 15.3047C15.1436 15.9991 13.7481 16.5 12 16.5C9.24032 16.5 7.35938 15.2517 6.13049 13.9643C5.51084 13.3151 5.06571 12.6627 4.77719 12.1744C4.74111 12.1134 4.70762 12.0551 4.67667 12C4.70762 11.9449 4.74111 11.8866 4.77719 11.8256C5.06571 11.3373 5.51084 10.6849 6.13049 10.0357C6.84881 9.28319 7.78991 8.54403 8.99906 8.05972L7.86229 6.92295ZM17.4435 14.3829C17.5935 14.2449 17.7354 14.1048 17.8695 13.9643C18.4892 13.3151 18.9343 12.6627 19.2228 12.1744C19.2589 12.1134 19.2924 12.0551 19.3233 12C19.2924 11.9449 19.2589 11.8866 19.2228 11.8256C18.9343 11.3373 18.4892 10.6849 17.8695 10.0357C16.6406 8.7483 14.7597 7.5 12 7.5C11.5293 7.5 11.0842 7.53631 10.6636 7.60293L9.40323 6.34257C10.186 6.12642 11.0499 6 12 6C18.5455 6 21 12 21 12C21 12 20.2588 13.8118 18.5049 15.4442L17.4435 14.3829ZM4.38589 12.5739L4.3869 12.5715L4.38667 12.572L4.38589 12.5739ZM4.38667 11.428L4.3869 11.4285C4.38598 11.4264 4.38565 11.4256 4.38589 11.4261L4.38667 11.428ZM19.6141 11.4262C19.6139 11.4266 19.6136 11.4274 19.6131 11.4285L19.6133 11.428L19.6141 11.4262ZM19.6141 11.4261L19.6141 11.4262L19.6141 11.4261Z"
                  fill="#BDBDBD"
                ></path>
                <path
                  d="M5 5L19 19"
                  stroke="#BDBDBD"
                  stroke-width="1.5"
                  stroke-linecap="round"
                ></path>
              </svg>
            </div>
            <!-- <div class="border-error">
              비밀번호는 영문/숫자/특수문자 혼합 8~20자입니다
            </div> -->
          </div>
          <div class="form-row">
            <a
              href="${pageContext.request.contextPath}/user/login/search-id"
              class="form-link"
              >아이디 찾기</a
            >
            <a
              href="${pageContext.request.contextPath}/user/login/search-pwd"
              class="form-link"
              >비밀번호 찾기</a
            >
          </div>
          <div class="footer flex flex-sa" style="left: 0">
            <button class="footer-btn" type="submit">로그인</button>
          </div>
        </form>
        <style>
          .kakao {
            display: inline-block;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(255, 205, 0, 0.15);
            transition: transform 0.15s, box-shadow 0.15s;
          }
          .kakao:hover {
            transform: translateY(-2px) scale(1.03);
            box-shadow: 0 6px 16px rgba(255, 205, 0, 0.25);
          }
        </style>
        <a
          id="login-kakao-btn"
          class="kakao"
          href="https://kauth.kakao.com/oauth/authorize?client_id=${apiKey}&redirect_uri=http://${serverMap.ip}:${serverMap.port}${pageContext.request.contextPath}/user/login/kakao-login&response_type=code"
        >
          <img
            src="https://k.kakaocdn.net/14/dn/btroDszwNrM/I6efHub1SN5KCJqLm1Ovx1/o.jpg"
            alt="카카오 로그인 버튼"
            width="222"
          />
        </a>
      </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
    <script>
      $(function () {
        // 눈 감은 아이콘 클릭 시
        $(".eye-closed").on("click", function () {
          $("#password").attr("type", "password");
          $(".eye-closed").hide();
          $(".eye-open").show();
        });
        // 눈 뜬 아이콘 클릭 시
        $(".eye-open").on("click", function () {
          $("#password").attr("type", "text");
          $(".eye-open").hide();
          $(".eye-closed").show();
        });
      });
    </script>
  </body>
</html>
