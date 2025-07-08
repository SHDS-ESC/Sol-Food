$(document).ready(function () {
  // 토글 버튼 요소 캐싱
  const $toggleBtn = $("#darkmode-toggle");

  // 토글 버튼이 없으면 실행 중단 (확장성을 위한 방어 코드)
  if ($toggleBtn.length === 0) return;

  // body를 jQuery 객체로 캐싱
  const $body = $("body");

  // 아이콘 업데이트 함수 정의
  function updateIcon() {
    const $icon = $toggleBtn.find("i"); // 버튼 안의 <i> 아이콘 선택

    // body에 'dark' 클래스가 있을 경우 해제 아이콘으로
    if ($body.hasClass("dark")) {
      $icon.attr("class", "bi bi-brightness-high"); // 밝은 아이콘
    } else {
      $icon.attr("class", "bi bi-moon"); // 어두운 아이콘
    }
  }

  // 버튼 클릭 시 body에 'dark' 클래스를 토글
  $toggleBtn.on("click", function () {
    $body.toggleClass("dark"); // dark 클래스 추가/제거
    updateIcon(); // 상태에 맞게 아이콘도 변경
  });

  // 페이지 로드시 초기 아이콘 상태 설정
  updateIcon();
});