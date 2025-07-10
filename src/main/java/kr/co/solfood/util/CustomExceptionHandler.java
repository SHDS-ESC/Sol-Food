package kr.co.solfood.util;

import kr.co.solfood.common.constants.UrlConstants;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.view.RedirectView;

import javax.servlet.http.HttpServletRequest;

@ControllerAdvice
public class CustomExceptionHandler {

    @ExceptionHandler(CustomException.class)
    public Object handleCustomException(CustomException e, HttpServletRequest request) {
        
        // AJAX 요청인지 확인
        String requestedWith = request.getHeader("X-Requested-With");
        boolean isAjaxRequest = "XMLHttpRequest".equals(requestedWith);
        
        // Content-Type이 application/json인지 확인
        String contentType = request.getContentType();
        boolean isJsonRequest = contentType != null && contentType.contains("application/json");
        
        // Accept 헤더가 application/json을 포함하는지 확인
        String accept = request.getHeader("Accept");
        boolean acceptsJson = accept != null && accept.contains("application/json");
        
        // API 요청인 경우 JSON 응답
        if (isAjaxRequest || isJsonRequest || acceptsJson) {
            return ErrorResponseEntity.toResponseEntity(e.getErrorCode());
        }
        
        // 페이지 요청인 경우 리다이렉트
        if (e.getErrorCode() == ErrorCode.UNAUTHORIZED) {
            return UrlConstants.Redirect.TO_USER_LOGIN;
        }
        
        // 기타 예외는 기본 에러 페이지로 리다이렉트
        return UrlConstants.Redirect.TO_ERROR;
    }
}