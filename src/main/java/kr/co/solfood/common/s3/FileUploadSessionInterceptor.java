package kr.co.solfood.common.s3;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 파일 업로드 API 전용 세션 검증 인터셉터
 * 기존 FileUploadController의 validateSession 로직을 분리
 */
public class FileUploadSessionInterceptor implements HandlerInterceptor {
    
    // 세션당 최대 업로드 횟수
    private static final int MAX_UPLOADS_PER_SESSION = 5;
    
    private final ObjectMapper objectMapper = new ObjectMapper();
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        
        // 세션 검증 수행
        String errorMessage = validateSession(session);
        
        if (errorMessage != null) {
            // 검증 실패 시 JSON 응답 반환
            sendErrorResponse(response, errorMessage, HttpServletResponse.SC_FORBIDDEN);
            return false; // 컨트롤러 진입 차단
        }
        
        // POST 요청인 경우 업로드 카운트 증가 (presigned URL 생성 시)
        if ("POST".equalsIgnoreCase(request.getMethod()) && 
            request.getRequestURI().contains("/upload-url")) {
            incrementUploadCount(session);
        }
        
        return true; // 컨트롤러 진입 허용
    }
    
    /**
     * 세션 보안 검증 (기존 FileUploadController의 validateSession 로직)
     */
    private String validateSession(HttpSession session) {
        // 1. 회원가입 or 마이페이지 수정
        Boolean joinInProgress = (Boolean) session.getAttribute("joinInProgress");
        Boolean mypageInProgress = (Boolean) session.getAttribute("mypageInProgress");
        
        // 둘 중 하나라도 true면 통과
        if ((joinInProgress != null && joinInProgress) || (mypageInProgress != null && mypageInProgress)) {
            // 2. 세션당 업로드 횟수 제한 확인
            Integer uploadCount = (Integer) session.getAttribute("uploadCount");
            if (uploadCount == null) {
                uploadCount = 0;
                session.setAttribute("uploadCount", uploadCount);
            }
            
            if (uploadCount >= MAX_UPLOADS_PER_SESSION) {
                return "업로드 횟수를 초과했습니다. (최대 " + MAX_UPLOADS_PER_SESSION + "회)";
            }
            
            return null; // 검증 통과
        }
        
        return "허용되지 않은 접근입니다. 회원가입 또는 마이페이지에서 시작해주세요.";
    }
    
    /**
     * 업로드 카운트 증가
     */
    private void incrementUploadCount(HttpSession session) {
        Integer uploadCount = (Integer) session.getAttribute("uploadCount");
        if (uploadCount == null) {
            uploadCount = 0;
        }
        session.setAttribute("uploadCount", uploadCount + 1);
    }
    
    /**
     * 에러 응답 JSON 전송
     */
    private void sendErrorResponse(HttpServletResponse response, String message, int statusCode) throws IOException {
        response.setStatus(statusCode);
        response.setContentType("application/json;charset=UTF-8");
        
        Map<String, Object> errorResponse = new HashMap<>();
        errorResponse.put("success", false);
        errorResponse.put("message", message);
        errorResponse.put("timestamp", System.currentTimeMillis());
        
        String jsonResponse = objectMapper.writeValueAsString(errorResponse);
        response.getWriter().write(jsonResponse);
        response.getWriter().flush();
    }
} 