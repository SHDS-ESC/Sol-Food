// 공통 유효성 검사 유틸
function validateInput($input, validator, $errorMsg) {
  $input.on("input", function () {
    const value = $(this).val();
    if (validator(value)) {
      $(this).closest(".form-group").removeClass("error");
      $errorMsg.hide();
    } else {
      $(this).closest(".form-group").addClass("error");
      $errorMsg.show();
    }
  });
}

// 예시: 각 필드별 유효성 검사
$(function () {
  // 이메일
  validateInput(
    $("#email"),
    function (v) {
      return /^[\\w.-]+@[\\w.-]+\\.[A-Za-z]{2,}$/.test(v);
    },
    $("#email").siblings(".border-error")
  );

  // 비밀번호 (6자 이상)
  validateInput(
    $("#password"),
    function (v) {
      return v.length >= 6;
    },
    $("#password").closest(".form-group").find(".border-error")
  );

  // 비밀번호 확인 (일치)
  $("#password2").on("input", function () {
    const pw1 = $("#password").val();
    const pw2 = $(this).val();
    const $group = $(this).closest(".form-group");
    const $err = $group.find(".border-error");
    if (pw1 && pw2 && pw1 === pw2) {
      $group.removeClass("error");
      $err.hide();
    } else {
      $group.addClass("error");
      $err.show();
    }
  });

  // 닉네임 (2~16자)
  validateInput(
    $("#nickname"),
    function (v) {
      return v.length >= 2 && v.length <= 16;
    },
    $("#nickname").closest(".form-group").find(".border-error")
  );

  // 이름 (2~16자)
  validateInput(
    $("#name"),
    function (v) {
      return v.length >= 2 && v.length <= 16;
    },
    $("#name").closest(".form-group").find(".border-error")
  );

  // 휴대폰 (숫자 10~11자리)
  validateInput(
    $("#phone"),
    function (v) {
      return /^\\d{10,11}$/.test(v.replace(/-/g, ""));
    },
    $("#phone").closest(".form-group").find(".border-error")
  );
});
