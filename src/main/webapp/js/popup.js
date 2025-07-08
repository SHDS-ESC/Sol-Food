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

// 팝업 알림 함수들
function showPopup(message, type = 'info', title = '알림') {
  // 기존 팝업이 있다면 제거
  $('.custom-popup').remove();
  
  // 팝업 HTML 생성
  const popupHtml = `
    <div class="popup-overlay custom-popup">
      <div class="popup-content">
        <div class="popup-header ${type}">
          <h3>${title}</h3>
          <button class="popup-close">×</button>
        </div>
        <div class="popup-body">
          <p>${message}</p>
        </div>
        <div class="popup-footer">
          <button class="popup-btn confirm-btn">확인</button>
        </div>
      </div>
    </div>
  `;
  
  // 팝업을 body에 추가
  $('body').append(popupHtml);
  
  // 팝업 표시
  $('.custom-popup').addClass('show').fadeIn(200);
  
  // 이벤트 바인딩
  $('.custom-popup .popup-close, .custom-popup .confirm-btn, .custom-popup .popup-overlay').on('click', function() {
    $('.custom-popup').fadeOut(200, function() {
      $(this).remove();
    });
  });
}

// 성공 팝업
function showSuccessPopup(message, title = '성공') {
  showPopup(message, 'success', title);
}

// 에러 팝업
function showErrorPopup(message, title = '오류') {
  showPopup(message, 'error', title);
}

// 경고 팝업
function showWarningPopup(message, title = '경고') {
  showPopup(message, 'warning', title);
}

// 정보 팝업
function showInfoPopup(message, title = '정보') {
  showPopup(message, 'info', title);
}

// 확인 팝업 (콜백 함수 지원)
function showConfirmPopup(message, onConfirm, title = '확인') {
  // 기존 팝업이 있다면 제거
  $('.custom-popup').remove();
  
  // 팝업 HTML 생성
  const popupHtml = `
    <div class="popup-overlay custom-popup">
      <div class="popup-content">
        <div class="popup-header info">
          <h3>${title}</h3>
          <button class="popup-close">×</button>
        </div>
        <div class="popup-body">
          <p>${message}</p>
        </div>
        <div class="popup-footer">
          <button class="popup-btn cancel-btn">취소</button>
          <button class="popup-btn confirm-btn">확인</button>
        </div>
      </div>
    </div>
  `;
  
  // 팝업을 body에 추가
  $('body').append(popupHtml);
  
  // 팝업 표시
  $('.custom-popup').addClass('show').fadeIn(200);
  
  // 이벤트 바인딩
  $('.custom-popup .popup-close, .custom-popup .cancel-btn, .custom-popup .popup-overlay').on('click', function() {
    $('.custom-popup').fadeOut(200, function() {
      $(this).remove();
    });
  });
  
  $('.custom-popup .confirm-btn').on('click', function() {
    $('.custom-popup').fadeOut(200, function() {
      $(this).remove();
      if (onConfirm) onConfirm();
    });
  });
}

// 기존 alert 함수 오버라이드 (선택적)
if (typeof window.originalAlert === 'undefined') {
  window.originalAlert = window.alert;
  window.alert = function(message) {
    showInfoPopup(message);
  };
}
