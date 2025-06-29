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
    UNAUTHORIZED(HttpStatus.UNAUTHORIZED, "UNAUTHORIZED", "로그인이 필요합니다."),
    UNDEFINED_SEARCH(HttpStatus.BAD_REQUEST, "UNDEFINED_SEARCH", "검색어가 정의되지 않았습니다."),
    INCORRECT_DATE_FORMAT(HttpStatus.BAD_REQUEST, "INCORRECT_DATE_FORMAT", "날짜 형식이 잘못되었습니다."),
    INCORRECT_DATA(HttpStatus.BAD_REQUEST, "INCORRECT_DATE_FORMAT", "잘못된 데이터 입니다.");

    private final HttpStatus httpStatus;
    private final String code;
    private final String message;

}
