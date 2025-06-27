package kr.co.solfood.util;

import lombok.AllArgsConstructor;
import lombok.Getter;

import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public enum ErrorCode {

    TEST_ERROR(HttpStatus.NOT_FOUND, "TEST_ERROR", "테스트 에러입니다.");

    private final HttpStatus httpStatus;
    private final String code;
    private final String message;

}
