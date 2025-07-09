$(document).ready(function () {
  const $toggleBtn = $("#darkmode-toggle");
  if ($toggleBtn.length === 0) return;
  const $body = $("body");

  // 1. 저장된 다크모드 상태 적용
  if (localStorage.getItem("darkmode") === "on") {
    $body.addClass("dark");
  }

  function updateIcon() {
    const $icon = $toggleBtn.find("i");
    if ($body.hasClass("dark")) {
      $icon.attr("class", "bi bi-brightness-high");
    } else {
      $icon.attr("class", "bi bi-moon");
    }
  }

  // 2. 토글 시 상태 저장
  $toggleBtn.on("click", function () {
    $body.toggleClass("dark");
    if ($body.hasClass("dark")) {
      localStorage.setItem("darkmode", "on");
    } else {
      localStorage.setItem("darkmode", "off");
    }
    updateIcon();
  });

  updateIcon();
});
