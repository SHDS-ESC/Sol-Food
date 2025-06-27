package kr.co.solfood.util;

import lombok.AllArgsConstructor;
import lombok.Getter;

import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum ErrorCode {

    TEST_ERROR(HttpStatus.NOT_FOUND, "TEST_ERROR", "테스트 에러입니다."),
    PASSWORD_NOT_FOUND(HttpStatus.BAD_REQUEST, "PASSWORD_NOT_FOUND", "비밀번호가 없습니다."),
    USER_NOT_FOUND(HttpStatus.NOT_FOUND, "USER_NOT_FOUND", "사용자를 찾을 수 없습니다."),
    UNAUTHORIZED(HttpStatus.UNAUTHORIZED, "UNAUTHORIZED", "로그인이 필요합니다.");

    private final HttpStatus httpStatus;
    private final String code;
    private final String message;

}
