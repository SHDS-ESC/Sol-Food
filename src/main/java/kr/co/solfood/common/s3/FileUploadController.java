package kr.co.solfood.common.s3;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@Controller
@RequestMapping("/api/file")
public class FileUploadController {
    
    // 🚀 AWS SDK v2 서비스 (성능 향상)
    @Autowired
    private S3ServiceV2 s3ServiceV2;
    
    // 🚀 개선된 Rate Limiting 서비스 (파일 기반 지속성)
    @Autowired
    private RateLimitService rateLimitService;
    
    // 세션당 최대 업로드 횟수
    private static final int MAX_UPLOADS_PER_SESSION = 5;
    
    /**
     * 프로필 이미지 업로드용 Pre-signed URL 생성 API
     */
    @PostMapping("/profile/upload-url")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generateProfileUploadUrl(
            @RequestBody Map<String, String> request, 
            HttpSession session, 
            HttpServletRequest httpRequest) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 1. 세션 보안 검증
            String sessionError = validateSession(session);
            if (sessionError != null) {
                response.put("success", false);
                response.put("message", sessionError);
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }
            
            // 2. 🚀 개선된 Rate Limiting 검증 (파일 기반 지속성)
            String clientIP = getClientIP(httpRequest);
            if (rateLimitService.isRateLimited(clientIP)) {
                response.put("success", false);
                response.put("message", "요청이 너무 많습니다. 잠시 후 다시 시도해주세요.");
                return ResponseEntity.status(HttpStatus.TOO_MANY_REQUESTS).body(response);
            }
            String fileExtension = request.get("fileExtension");
            
            // 파일 확장자 검증
            if (fileExtension == null || fileExtension.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "파일 확장자가 필요합니다.");
                return ResponseEntity.badRequest().body(response);
            }
            
            // 허용된 이미지 확장자만 업로드 가능
            if (!isValidImageExtension(fileExtension)) {
                response.put("success", false);
                response.put("message", "지원하지 않는 파일 형식입니다. (jpg, jpeg, png, gif만 가능)");
                return ResponseEntity.badRequest().body(response);
            }
            
            // 🚀 AWS SDK v2로 Pre-signed URL 생성 (성능 향상)
            String presignedUrl = s3ServiceV2.generateProfileUploadUrl(fileExtension);
            
            // 3. 업로드 성공 시 세션의 업로드 카운트 증가
            Integer uploadCount = (Integer) session.getAttribute("uploadCount");
            session.setAttribute("uploadCount", uploadCount + 1);
            
            // 응답 데이터 구성
            response.put("success", true);
            response.put("presignedUrl", presignedUrl);
            response.put("message", "업로드 URL 생성 완료 (v2 최적화)");
            
            // 업로드 후 접근할 파일 이름 추출 (클라이언트에서 사용)
            String fileName = extractFileNameFromUrl(presignedUrl);
            response.put("fileName", fileName);
            
            // 🚀 개선: 공개 URL을 미리 제공하여 3번째 API 호출 제거 (v2)
            String publicUrl = s3ServiceV2.getPublicUrl(fileName);
            response.put("publicUrl", publicUrl);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "업로드 URL 생성 실패: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    /**
     * 업로드 완료 후 S3 파일의 공개 URL 반환
     */
    @PostMapping("/profile/complete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getUploadedFileUrl(
            @RequestBody Map<String, String> request, 
            HttpSession session, 
            HttpServletRequest httpRequest) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // 세션 보안 검증 (업로드 완료 API도 동일한 보안 적용)
            String sessionError = validateSession(session);
            if (sessionError != null) {
                response.put("success", false);
                response.put("message", sessionError);
                return ResponseEntity.status(HttpStatus.FORBIDDEN).body(response);
            }
            String fileName = request.get("fileName");
            
            if (fileName == null || fileName.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "파일명이 필요합니다.");
                return ResponseEntity.badRequest().body(response);
            }
            
            // 🚀 AWS SDK v2로 공개 URL 생성 (성능 향상)
            String publicUrl = s3ServiceV2.getPublicUrl(fileName);
            
            response.put("success", true);
            response.put("fileUrl", publicUrl);
            response.put("message", "파일 URL 조회 완료");
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "파일 URL 조회 실패: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
    
    /**
     * 이미지 파일 확장자 검증
     */
    private boolean isValidImageExtension(String extension) {
        String[] allowedExtensions = {"jpg", "jpeg", "png", "gif", "webp"};
        String lowerExtension = extension.toLowerCase();
        
        for (String allowed : allowedExtensions) {
            if (allowed.equals(lowerExtension)) {
                return true;
            }
        }
        return false;
    }
    
    /**
     * Pre-signed URL에서 파일명 추출
     */
    private String extractFileNameFromUrl(String presignedUrl) {
        try {
            // URL에서 쿼리 파라미터 제거하고 파일명만 추출
            String urlWithoutQuery = presignedUrl.split("\\?")[0];
            String[] urlParts = urlWithoutQuery.split("/");
            
            // 마지막 두 부분을 합쳐서 "profiles/파일명" 형태로 반환
            if (urlParts.length >= 2) {
                return urlParts[urlParts.length - 2] + "/" + urlParts[urlParts.length - 1];
            }
            
            return urlParts[urlParts.length - 1];
        } catch (Exception e) {
            return "";
        }
    }
    
    /**
     * 세션 보안 검증
     */
    private String validateSession(HttpSession session) {
        // 1. 회원가입 진행 중인지 확인
        Boolean joinInProgress = (Boolean) session.getAttribute("joinInProgress");
        if (joinInProgress == null || !joinInProgress) {
            return "허용되지 않은 접근입니다. 회원가입 페이지에서 시작해주세요.";
        }
        
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
    
    /**
     * 클라이언트 IP 주소 추출
     */
    private String getClientIP(HttpServletRequest request) {
        String xfHeader = request.getHeader("X-Forwarded-For");
        if (xfHeader != null && !xfHeader.isEmpty() && !"unknown".equalsIgnoreCase(xfHeader)) {
            return xfHeader.split(",")[0].trim();
        }
        
        String xrealIpHeader = request.getHeader("X-Real-IP");
        if (xrealIpHeader != null && !xrealIpHeader.isEmpty() && !"unknown".equalsIgnoreCase(xrealIpHeader)) {
            return xrealIpHeader;
        }
        
        return request.getRemoteAddr();
    }
    
    // 🚀 Rate Limiting 로직이 RateLimitService로 이동됨 (개선)
} 