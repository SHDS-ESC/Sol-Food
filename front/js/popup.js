$(document).ready(function () {
  // 팝업 열기
  $("#open-popup").on("click", function () {
    $(".popup-overlay").fadeIn(200); // 팝업 배경과 함께 등장
  });

  // 팝업 닫기
  $(".popup-close, .popup-overlay").on("click", function (e) {
    // 팝업 바깥 영역 클릭 시에도 닫히도록
    if ($(e.target).is(".popup-close") || $(e.target).is(".popup-overlay")) {
      $(".popup-overlay").fadeOut(200);
    }
  });
});
