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
      href="${pageContext.request.contextPath}/css/board/board-list.css"
    />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  </head>

  <body>
    <div class="wrap">
      <jsp:include page="../include/backbtn-header.jsp" />
      <div class="content board-list">
        <form
          class="board-add-form"
          action="${pageContext.request.contextPath}/user/board/add"
          method="post"
          enctype="multipart/form-data"
        >
          <%--사진등록--%>
          <div class="board-add-photo-box flex">
            <label class="board-add-photo-label">
              <input
                type="file"
                multiple
                accept="image/*"
                style="display: none"
                onchange="previewStoreMainimage(event)"
              />
              <div class="board-add-photo-thumb">
                <i
                  class="bi bi-camera"
                  style="font-size: 28px; color: #bbb"
                ></i>
                <div class="board-add-photo-count">0/1</div>
              </div>
            </label>

            <div class="preview" style="position: relative">
              <img id="previewImg" src="" alt="" />
              <button
                type="button"
                class="preview-close"
                aria-label="이미지 삭제"
              >
                &times;
              </button>
            </div>
          </div>
          <div class="board-add-group">
            <label for="board-add-title">제목</label>
            <input
              id="board-add-title"
              class="board-add-input"
              type="text"
              placeholder="글 제목"
              name="boardTitle"
              required
            />
          </div>
          <div class="board-add-group">
            <label for="board-add-desc">자세한 설명</label>
            <textarea
              id="board-add-desc"
              class="board-add-textarea"
              rows="5"
              placeholder="게시글 내용을 작성해 주세요."
              name="boardContent"
              required
            ></textarea>
          </div>
          <input type="hidden" name="boardImage" id="boardImage" />
          <!-- <div class="board-add-group board-add-checkbox-row">
            <input
              type="checkbox"
              id="board-add-suggest"
              class="board-add-checkbox"
            />
            <label for="board-add-suggest">임시 체크박스</label>
          </div> -->
          <button class="board-add-submit" type="submit">작성 완료</button>
        </form>
      </div>
      <div class="footer flex flex-sa">
        <div class="bottom-nav">
          <a href="${pageContext.request.contextPath}/"
            ><i class="bi bi-house"></i>홈</a
          >
          <a
            href="${pageContext.request.contextPath}/user/cart"
            class="cart-nav-item"
          >
            <i class="bi bi-bag"></i>장바구니
            <span class="cart-nav-badge">0</span>
          </a>
          <a href="#"><i class="bi bi-calendar2-week"></i>캘린더</a>
          <a href="${pageContext.request.contextPath}/user/mypage/like"
            ><i class="bi bi-heart-fill"></i>찜</a
          >
          <a href="${pageContext.request.contextPath}/user/mypage"
            ><i class="bi bi-person-circle"></i>마이</a
          >
        </div>
      </div>
    </div>
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
    <script src="${pageContext.request.contextPath}/js/urlConstants.js"></script>
    <script src="${pageContext.request.contextPath}/js/s3Upload.js"></script>

    <script>
      // Context Path를 JavaScript에서 사용할 수 있도록 설정
      var contextPath = "${pageContext.request.contextPath}";

      async function previewStoreMainimage(event) {
        let files = event.target.files;
        let reader = new FileReader();
        reader.onload = function (e) {
          let img = document.getElementById("previewImg");
          img.setAttribute("src", e.target.result);
          img.style.opacity = "1";
          img.style.borderRadius = "12px";
          document.querySelector(".board-add-photo-count").innerText = "1/1";
          document.querySelector(".preview-close").style.opacity = 1; // X 버튼 보이기
        };

        const file = files[0];
        reader.readAsDataURL(files[0]);

        try {
          // S3 업로드 실행 (s3Upload.js의 s3Uploader 사용)
          const s3Url = await s3Uploader.uploadProfileImage(
            file,
            function (progress) {
              updateUploadProgress(progress);
            }
          );
          document.getElementById("boardImage").value = s3Url;
        } catch (error) {
          alert("이미지 업로드에 실패했습니다. 다시 시도해주세요.");
        }
      }

      // X 버튼 클릭 시 미리보기/값 제거
      document.addEventListener("DOMContentLoaded", function () {
        document
          .querySelector(".preview-close")
          .addEventListener("click", function () {
            document.getElementById("previewImg").setAttribute("src", "");
            document.getElementById("previewImg").style.opacity = "0";
            document.getElementById("boardImage").value = "";
            document.querySelector(".board-add-photo-count").innerText = "0/1";
            this.style.display = "none";
          });
      });
    </script>
  </body>
</html>
