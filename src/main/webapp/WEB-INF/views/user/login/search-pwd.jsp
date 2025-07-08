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
    <title>아이디/비밀번호 찾기</title>
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
      href="${pageContext.request.contextPath}/css/login/search-password.css"
    />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
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
      <div class="content search">
        <div class="search-tab-box">
          <button class="search-tab active" data-tab="id">아이디 찾기</button>
          <button class="search-tab" data-tab="pw">비밀번호 찾기</button>
          <div class="search-tab-bar"></div>
        </div>
        <div class="search-form-box">
          <form class="search-form search-form-id" autocomplete="off">
            <div class="search-group">
              <label for="id-name">이름</label>
              <input
                id="id-name"
                type="text"
                class="border-input"
                placeholder="이름 또는 닉네임을 입력해주세요"
              />
            </div>
            <div class="search-group">
              <label for="id-phone">휴대폰 번호</label>
              <input
                id="id-phone"
                type="tel"
                class="border-input"
                placeholder="'-'를 제외한 숫자만 입력해주세요"
              />
            </div>
            <button class="search-btn" type="submit" disabled>
              인증번호 전송
            </button>
          </form>
          <form
            class="search-form search-form-pw"
            autocomplete="off"
            style="display: none"
            action="${pageContext.request.contextPath}/user/login/search-pwd"
            method="post"
            id="pw-find-form"
          >
            <div class="search-group">
              <label for="pw-email"
                >이메일
                <span class="search-desc"
                  >*이메일 계정만 비밀번호 찾기가 가능해요!</span
                ></label
              >
              <input
                id="pw-email"
                type="email"
                class="border-input"
                placeholder="example@example.com"
                name="usersEmail"
              />
            </div>
            <div class="search-group">
              <label for="pw-name">이름</label>
              <input
                id="pw-name"
                type="text"
                class="border-input"
                placeholder="이름 또는 닉네임을 입력해주세요"
                name="usersName"
              />
            </div>
            <!-- 비밀번호 찾기 결과 영역 (초기에는 숨김) -->
            <div
              class="pw-result search-group"
              style="display: none; margin-top: 20px"
            >
              <label for="new-password">새 비밀번호</label>
              <div style="display: flex; align-items: center; gap: 8px">
                <input
                  id="new-password"
                  type="text"
                  class="border-input"
                  readonly
                  value=""
                  style="flex: 1; margin: 5px 0"
                />
                <button
                  type="button"
                  id="copy-btn"
                  style="
                    background: none;
                    border: none;
                    cursor: pointer;
                    position: absolute;
                    right: 30px;
                  "
                >
                  <i class="bi bi-clipboard"></i>
                </button>
              </div>
              <div
                class="copy-msg"
                style="color: green; font-size: 13px; display: none"
              >
                복사되었습니다!
              </div>
            </div>
            <!-- <div class="search-group">
              <label for="pw-phone">휴대폰 번호</label>
              <input
                id="pw-phone"
                type="tel"
                class="border-input"
                placeholder="'-'를 제외한 숫자만 입력해주세요"
              />
            </div> -->
            <div class="footer flex flex-sa" style="left: 0">
              <button class="search-btn" type="submit" disabled>
                비밀번호 찾기
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
    <script>
      var tabType = "${tabType}";

      document.addEventListener("DOMContentLoaded", function () {
        var type =
          typeof tabType !== "undefined" && tabType === "pw" ? "pw" : "id";

        document.querySelectorAll(".search-tab").forEach((tab) => {
          tab.classList.remove("active");
          if (tab.dataset.tab === type) tab.classList.add("active");
        });
        if (type === "id") {
          document.querySelector(".search-form-id").style.display = "";
          document.querySelector(".search-form-pw").style.display = "none";
        } else {
          document.querySelector(".search-form-id").style.display = "none";
          document.querySelector(".search-form-pw").style.display = "";
        }
      });

      // 탭 전환 스크립트
      document.querySelectorAll(".search-tab").forEach((tab) => {
        tab.addEventListener("click", function () {
          document
            .querySelectorAll(".search-tab")
            .forEach((t) => t.classList.remove("active"));
          this.classList.add("active");
          if (this.dataset.tab === "id") {
            document.querySelector(".search-form-id").style.display = "";
            document.querySelector(".search-form-pw").style.display = "none";
          } else {
            document.querySelector(".search-form-id").style.display = "none";
            document.querySelector(".search-form-pw").style.display = "";
          }
        });
      });

      $(function () {
        // 인풋 -----------------------------
        function togglePwBtn() {
          const email = $("#pw-email").val().trim();
          const name = $("#pw-name").val().trim();
          if (email && name) {
            $(".search-form-pw .search-btn").prop("disabled", false);
          } else {
            $(".search-form-pw .search-btn").prop("disabled", true);
          }
        }
        // 입력값이 바뀔 때마다 체크
        $("#pw-email, #pw-name").on("input", togglePwBtn);

        // 페이지 로드 시 초기 상태도 체크
        togglePwBtn();

        // 복사 버튼 기능
        $(document).on("click", "#copy-btn", function () {
          const pw = $("#new-password").val();
          navigator.clipboard.writeText(pw).then(function () {
            $(".copy-msg").fadeIn(200).delay(1000).fadeOut(200);
          });
        });

        // 비밀번호 찾기 폼 AJAX 처리
        $("#pw-find-form").on("submit", function (e) {
          e.preventDefault();

          const email = $("#pw-email").val().trim();
          const name = $("#pw-name").val().trim();
          if (!email || !name) return;

          const $btn = $(this).find(".search-btn");
          $btn.prop("disabled", true).text("처리중...");

          $.ajax({
            url: $(this).attr("action"),
            method: "POST",
            data: { usersEmail: email, usersName: name },
            dataType: "json", // 응답이 JSON임을 명시
            success: function (res) {
              const newPw = res && res.newPassword;

              if (newPw) {
                $("#new-password").val(newPw);
                $(".pw-result").fadeIn(); // 비밀번호 결과 보여주기
              } else {
                alert("입력하신 정보와 일치하는 계정이 없습니다.");
                $(".pw-result").fadeOut();
              }
            },
            error: function () {
              alert("비밀번호 찾기 요청 중 오류가 발생했습니다.");
              $(".pw-result").fadeOut();
            },
            complete: function () {
              $btn.prop("disabled", false).text("비밀번호 찾기");
            },
          });
        });
      });
    </script>
  </body>
</html>
