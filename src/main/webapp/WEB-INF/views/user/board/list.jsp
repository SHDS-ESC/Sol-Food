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
      <jsp:include page="../include/header.jsp" />
      <div class="content board-list">
        <ul class="feed"></ul>
        <button class="btn submit" id="load-more-btn" style="display: block">
          더보기
        </button>
        <div class="writeBtn">
          <a href="${pageContext.request.contextPath}/user/board/add">
            <i class="bi bi-plus" style="font-size: 20px"></i
            ><span>글쓰기</span>
          </a>
        </div>
      </div>
      <jsp:include page="../include/footer.jsp" />
    </div>
    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
      const contextPath = "${pageContext.request.contextPath}";

      let offset = 0;
      const pageSize = 10;

      function loadBoardList() {
        // $("#load-more-btn").hide();
        // $("#loading-spinner").show();
        $.ajax({
          url: contextPath + "/user/board/api/list",
          method: "GET",
          async: false,
          data: { offset, pageSize },
          success: function (res) {
            if (res.error) {
              alert("목록을 불러오는 데 실패했습니다.");
              return;
            }

            const list = res.list;
            const container = $(".feed");

            list.forEach((board) => {
              const boardDate = new Date(board.boardDate).toLocaleDateString(
                "ko-KR",
                {
                  year: "numeric",
                  month: "2-digit",
                  day: "2-digit",
                }
              );

              console.log(board);

              let boardImgHtml = board.boardImage
                ? `<img class="board-list-img" src="\${board.boardImage}" alt="게시글 이미지" />`
                : "";

              let contentWithBr = board.boardContent
                ? board.boardContent.replace(/(?:\r\n|\r|\n)/g, "<br>")
                : "";

              let html = `
                        <li class="feed-item">
                            <a href="\${contextPath}/user/board/detail?boardId=\${board.boardId}" style="text-decoration:none">
                                <div class="board-list-meta">
                                <img
                                    class="board-list-profile"
                                    src="\${board.boardWriterImage}"
                                    alt="프로필"
                                />
                                <div class="board-list-info">
                                    <div>
                                    <b>\${board.boardWirter}</b> <span class="board-list-time">\${boardDate}</span>
                                    </div>
                                </div>
                                
                                </div>
                                <div class="board-list-title">\${board.boardTitle}</div>
                                <p class="board-list-content">\${contentWithBr}</p>
                                <div class="board-list-imgbox">
                                \${boardImgHtml}
                                </div>
                                <div class="board-list-footer">
                                <div class="board-list-footer-left">
                                    <i class="bi bi-heart"></i> 0 <i class="bi bi-chat"></i> \${board.commentCount}
                                    <span>조회수 \${board.boardViewcount}</span>
                                </div>
                                <div class="board-list-footer-right"></div>
                                </div>
                            </a>
                        </li>
                    `;
              container.append(html);
            });

            offset += pageSize;
            // if (!res.hasNext) {
            //   console.log(res.hasNext);
            //   console.log("더보기 없음");
            //   $("#load-more-btn").hide();
            // } else {
            //   console.log(res.hasNext);
            //   console.log("더보기 있음");

            //   $("#load-more-btn").show();
            // }
            // $("#loading-spinner").hide();
          },
          error: function () {
            alert("서버 요청 실패");
            // $("#loading-spinner").hide();
            // $("#load-more-btn").show();
          },
        });
      }

      $(document).ready(function () {
        loadBoardList();

        $("#load-more-btn").on("click", function () {
          loadBoardList();
        });

        // 스크롤 감지 이벤트
        $("body").on("mousewheel", function (e) {
          var wheel = e.originalEvent.wheelDelta;

          if (wheel > 0) {
            // 스크롤 올릴 때
            $(".writeBtn").removeClass("hide-text");
          } else {
            // 스크롤 내릴 때
            $(".writeBtn").addClass("hide-text");
          }
        });
      });
    </script>
  </body>
</html>
