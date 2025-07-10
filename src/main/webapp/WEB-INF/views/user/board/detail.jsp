<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
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
      <div class="header flex flex-sb">
        <div
          class="backIco"
          onclick="location.href = '${pageContext.request.contextPath}/user/board/list'"
        >
          <i class="bi bi-arrow-left"></i>
        </div>
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

      <div class="content board-list">
        <ul class="feed">
          <li class="feed-item">
            <input type="hidden" id="boardId" value="${board.boardId}" />
            <!-- 현재 로그인한 사용자 정보 추가 -->
            <input
              type="hidden"
              id="currentUser"
              value="${sessionScope.userId}"
            />

            <div class="board-list-meta">
              <img
                class="board-list-profile"
                src="${board.boardWriterImage}"
                alt="프로필"
              />
              <div class="board-list-info">
                <div>
                  <b>${board.boardWirter}</b>
                  <span class="board-list-time">
                    <fmt:formatDate
                      value="${board.boardDate}"
                      pattern="yyyy-MM-dd"
                    />
                  </span>
                </div>
              </div>
              <c:if test="${isAuthor}">
                <div class="board-list-meta" style="position: relative">
                  <button class="board-list-more">
                    <i class="bi bi-three-dots"></i>
                  </button>
                  <ul class="moreUl">
                    <li>
                      <a
                        href="${pageContext.request.contextPath}/user/board/edit?boardId=${board.boardId}"
                        >수정</a
                      >
                    </li>
                    <li
                      class="board-delete-btn"
                      data-board-id="${board.boardId}"
                    >
                      삭제
                    </li>
                  </ul>
                </div>
              </c:if>
            </div>
            <div class="board-list-title">${board.boardTitle}</div>
            <p style="line-height: 22px; margin-bottom: 16px">
              ${board.boardContent}
            </p>
            <div class="board-list-imgbox">
              <c:if test="${not empty board.boardImage}">
                <img
                  class="board-list-img"
                  src="${board.boardImage}"
                  alt="게시글 이미지"
                />
              </c:if>
            </div>
            <div class="board-list-footer">
              <div class="board-list-footer-left">
                <i class="bi bi-heart"></i> 0 <i class="bi bi-chat"></i>
                <span id="comment-count">${board.commentCount}</span>
                <span>조회수 ${board.boardViewcount}</span>
              </div>
              <div class="board-list-footer-right"></div>
            </div>
          </li>
        </ul>
        <ul class="board-comment-list"></ul>
        <div class="board-comment-footer">
          <input
            type="text"
            class="board-comment-input"
            placeholder="댓글 달기..."
          />
          <button class="board-comment-submit">게시</button>
        </div>
      </div>
      <jsp:include page="../include/footer.jsp" />
    </div>

    <script src="${pageContext.request.contextPath}/js/darkmode.js"></script>
    <script>
      $(document).ready(function () {
        const contextPath = "${pageContext.request.contextPath}";
        const boardId = "${board.boardId}";
        const currentUser = "${sessionScope.userLoginSession.usersNickname}"; // 현재 로그인한 사용자

        // 페이지 로드 시 댓글 조회
        loadComments();

        // 댓글 조회 함수
        function loadComments() {
          $.ajax({
            url: contextPath + "/user/comment/list",
            method: "GET",
            data: { boardId: boardId },
            success: function (res) {
              renderComments(res);
              updateCommentCount(res.length);
            },
            error: function () {
              console.error("댓글 조회 실패");
            },
          });
        }

        // 댓글 렌더링 함수 (권한 체크 포함)
        function renderComments(commentList) {
          const commentContainer = $(".board-comment-list");
          commentContainer.empty();

          if (commentList.length === 0) {
            commentContainer.html(
              '<li class="no-comments">댓글이 없습니다.</li>'
            );
            return;
          }

          // 댓글 그룹화 (부모 댓글과 대댓글)
          const groupedComments = {};

          commentList.forEach((comment) => {
            const gno = comment.gno === 0 ? comment.commentId : comment.gno;

            if (!groupedComments[gno]) {
              groupedComments[gno] = {
                parent: null,
                replies: [],
              };
            }

            if (comment.gno === 0) {
              groupedComments[gno].parent = comment;
            } else {
              groupedComments[gno].replies.push(comment);
            }
          });

          // 댓글 렌더링
          Object.values(groupedComments).forEach((group) => {
            const comment = group.parent;

            if (comment) {
              console.log(comment)
              // 댓글 작성자와 현재 사용자가 같은지 확인
              const isCommentAuthor = comment.commentWriter === currentUser;
              const deleteButton = isCommentAuthor
                ? ` · <span class="comment-delete" data-comment-id="\${comment.commentId}">삭제</span>`
                : "";

              // src="https://mblogthumb-phinf.pstatic.net/MjAyMDExMDFfMyAg/MDAxNjA0MjI5NDA4NDMy.5zGHwAo_UtaQFX8Hd7zrDi1WiV5KrDsPHcRzu3e6b8Eg.IlkR3QN__c3o7Qe9z5_xYyCyr2vcx7L_W1arNFgwAJwg.JPEG.gambasg/%EC%9C%A0%ED%8A%9C%EB%B8%8C_%EA%B8%B0%EB%B3%B8%ED%94%84%EB%A1%9C%ED%95%84_%ED%8C%8C%EC%8A%A4%ED%85%94.jpg?type=w800"

              const commentHtml = `
                <li class="board-comment-item" data-comment-id="\${comment.commentId}">
                  <img class="board-comment-profile"
                       src="\${comment.commentWriterImage}"alt="프로필" />
                  <div class="board-comment-body">
                    <div class="board-comment-meta">
                      <span class="board-comment-nick">\${comment.commentWriter}</span>
                      <span class="board-comment-time">\${formatDate(comment.commentDate)}</span>
                    </div>
                    <div class="board-comment-text">\${comment.commentContent}</div>
                    <div class="board-comment-actions">
                      <span class="comment-like">좋아요</span> ·
                      <span class="comment-reply" data-comment-id="\${comment.commentId}">답글달기</span> ·
                      <span class="comment-report">신고</span>\${deleteButton}
                    </div>
                    <div class="reply-form" style="display: none; margin-top: 10px;">
                      <div style="display: flex; gap: 10px; align-items: center;">
                        <input type="text" class="reply-input" placeholder="답글을 입력하세요..." 
                               style="flex: 1; padding: 8px; border: 1px solid #ddd; border-radius: 4px;" />
                        <button class="reply-submit" data-parent-id="\${comment.commentId}" 
                                style="padding: 8px 16px; background: var(--color-main); color: white; border: none; border-radius: 4px; cursor: pointer;">답글</button>
                      </div>
                    </div>
                  </div>
                </li>
              `;
              commentContainer.append(commentHtml);

              // 대댓글 렌더링
              group.replies.forEach((reply) => {
                console.log(reply)
                const isReplyAuthor = reply.commentWriter === currentUser;
                const replyDeleteButton = isReplyAuthor
                  ? ` · <span class="comment-delete" data-comment-id="\${reply.commentId}">삭제</span>`
                  : "";

                const replyHtml = `
                  <li class="board-comment-item reply-item" data-comment-id="\${reply.commentId}" 
                      style="margin-left: 60px; border-left: 2px solid #f0f0f0; padding-left: 20px;">
                    <img class="board-comment-profile"
                         src="\${comment.commentWriterImage}"alt="프로필" />
                    <div class="board-comment-body">
                      <div class="board-comment-meta">
                        <span class="board-comment-nick">\${reply.commentWriter}</span>
                        <span class="board-comment-time">\${formatDate(reply.commentDate)}</span>
                      </div>
                      <div class="board-comment-text">\${reply.commentContent}</div>
                      <div class="board-comment-actions">
                        <span class="comment-like">좋아요</span> ·
                        <span class="comment-report">신고</span>\${replyDeleteButton}
                      </div>
                    </div>
                  </li>
                `;
                commentContainer.append(replyHtml);
              });
            }
          });

          // 이벤트 리스너 재등록
          attachEventListeners();
        }

        // 댓글 수 업데이트 함수
        function updateCommentCount(count) {
          $("#comment-count").text(count);
        }

        // 날짜 포맷 함수
        function formatDate(timestamp) {
          const date = new Date(timestamp);
          const year = date.getFullYear();
          const month = String(date.getMonth() + 1).padStart(2, "0");
          const day = String(date.getDate()).padStart(2, "0");
          return `${year}-${month}-${day}`;
        }

        // 이벤트 리스너 등록
        function attachEventListeners() {
          // 답글달기 버튼 클릭
          $(".comment-reply")
            .off("click")
            .on("click", function () {
              const commentItem = $(this).closest(".board-comment-item");
              const replyForm = commentItem.find(".reply-form");

              // 다른 답글 폼들 숨기기
              $(".reply-form").not(replyForm).hide();

              // 현재 답글 폼 토글
              replyForm.toggle();

              if (replyForm.is(":visible")) {
                replyForm.find(".reply-input").focus();
              }
            });

          // 답글 등록
          $(".reply-submit")
            .off("click")
            .on("click", function () {
              const content = $(this).siblings(".reply-input").val().trim();
              const parentId = $(this).data("parent-id");

              if (!content) {
                alert("답글 내용을 입력해주세요.");
                return;
              }

              $.ajax({
                url: contextPath + "/user/comment/insert",
                method: "POST",
                data: {
                  commentContent: content,
                  boardId: boardId,
                  gno: parentId,
                },
                success: function () {
                  loadComments(); // 댓글 새로고침
                },
                error: function () {
                  alert("답글 등록 실패");
                },
              });
            });

          // 답글 입력창에서 Enter 키 처리
          $(".reply-input")
            .off("keypress")
            .on("keypress", function (e) {
              if (e.which === 13) {
                $(this).siblings(".reply-submit").click();
              }
            });
        }

        // 새 댓글 등록
        $(".board-comment-submit").on("click", function () {
          const content = $(".board-comment-input").val().trim();

          if (!content) {
            alert("댓글을 입력해주세요.");
            return;
          }

          $.ajax({
            url: contextPath + "/user/comment/insert",
            method: "POST",
            data: {
              commentContent: content,
              boardId: boardId,
              gno: 0,
            },
            success: function () {
              $(".board-comment-input").val("");
              loadComments();
            },
            error: function () {
              alert("댓글 등록 실패");
            },
          });
        });

        // 댓글 입력창에서 Enter 키 처리
        $(".board-comment-input").on("keypress", function (e) {
          if (e.which === 13) {
            $(".board-comment-submit").click();
          }
        });

        // 댓글 삭제 버튼 클릭 (수정됨)
        $(document).on("click", ".comment-delete", function () {
          if (!confirm("댓글을 삭제하시겠습니까?")) return;

          const commentId = $(this).data("comment-id");

          console.log("삭제할 댓글 ID:", commentId); // 디버깅용

          $.ajax({
            url: contextPath + "/user/comment/delete",
            method: "POST",
            data: { commentId: commentId },
            success: function (res) {
              console.log("서버 응답:", res); // 디버깅용

              if (res === "success" || res.trim() === "success") {
                alert("댓글이 삭제되었습니다.");
                loadComments(); // 댓글 새로고침 (올바른 함수 호출)
              } else {
                alert("댓글 삭제에 실패했습니다.");
              }
            },
            error: function (xhr, status, error) {
              console.error("AJAX 오류:", xhr, status, error);
              alert("서버 오류가 발생했습니다.");
            },
          });
        });

        // 좋아요 버튼 클릭
        $(document).on("click", ".comment-like", function () {
          console.log("좋아요 클릭");
        });

        // 신고 버튼 클릭
        $(document).on("click", ".comment-report", function () {
          console.log("신고 클릭");
        });

        // 게시판 삭제 버튼 클릭
        $(document).on("click", ".board-delete-btn", function () {
          const boardId = $(this).data("board-id");

          if (
            confirm(
              "게시글을 삭제할까요? 게시글을 삭제하면 모든 데이터가 삭제되고 다시 볼 수 없어요."
            )
          ) {
            const form = $("<form>", {
              method: "POST",
              action: contextPath + "/user/board/delete",
            });

            const input = $("<input>", {
              type: "hidden",
              name: "boardId",
              value: boardId,
            });

            form.append(input);
            $("body").append(form);
            form.submit();
          }
        });

        // 게시글 더보기 메뉴
        $(document).on("click", ".board-list-more", function (e) {
          e.stopPropagation();
          const $ul = $(this).closest(".feed-item").find(".moreUl");
          if ($ul.hasClass("show")) {
            $ul.removeClass("show").addClass("hide");
            setTimeout(() => $ul.hide().removeClass("hide"), 250);
          } else {
            $(".moreUl").removeClass("show").hide();
            $ul.show().addClass("show");
          }
        });

        // 바깥 클릭 시 메뉴 닫기
        $(document).on("click", function () {
          $(".moreUl.show").removeClass("show").addClass("hide");
          setTimeout(() => $(".moreUl.hide").hide().removeClass("hide"), 250);
        });
      });
    </script>
  </body>
</html>
