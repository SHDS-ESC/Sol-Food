package kr.co.solfood.common.s3;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import properties.S3Properties;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.GetUrlRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.PresignedPutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.model.PutObjectPresignRequest;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;

import javax.annotation.PostConstruct;
import java.time.Duration;
import java.util.UUID;

@Slf4j
@Service
public class S3ServiceV2 {
    
    @Autowired
    private S3Properties s3Properties;
    
    private S3Client s3Client;
    private S3Presigner s3Presigner;
    
    @PostConstruct
    public void initializeS3Client() {
        try {
            AwsBasicCredentials awsCredentials = AwsBasicCredentials.create(
                s3Properties.getAccessKey(),
                s3Properties.getSecretKey()
            );
            
            s3Client = S3Client.builder()
                .region(Region.of(s3Properties.getRegion()))
                .credentialsProvider(StaticCredentialsProvider.create(awsCredentials))
                .build();
                
            s3Presigner = S3Presigner.builder()
                .region(Region.of(s3Properties.getRegion()))
                .credentialsProvider(StaticCredentialsProvider.create(awsCredentials))
                .build();
                
            log.info("S3 클라이언트 v2 초기화 완료 (성능 향상)");
        } catch (Exception e) {
            log.error("S3 클라이언트 v2 초기화 실패: {}", e.getMessage());
        }
    }
    
    /**
     * 🚀 Pre-signed URL 생성 (성능 최적화)
     */
    public String generatePresignedUploadUrl(String fileExtension) {
        try {
            // 고유한 파일명 생성
            String fileName = "profiles/" + UUID.randomUUID() + "." + fileExtension;

            // Pre-signed URL 요청 생성 (5분 만료)
            PutObjectPresignRequest presignRequest = PutObjectPresignRequest.builder()
                .signatureDuration(Duration.ofMinutes(5))
                .putObjectRequest(builder -> builder
                    .bucket(s3Properties.getBucket())
                    .key(fileName)
                    .build())
                .build();

            // Pre-signed URL 생성
            PresignedPutObjectRequest presignedRequest = s3Presigner.presignPutObject(presignRequest);

            log.info("Pre-signed URL v2 생성 완료: {}", fileName);
            return presignedRequest.url().toString();

        } catch (Exception e) {
            log.error("Pre-signed URL v2 생성 실패: {}", e.getMessage());
            throw new RuntimeException("파일 업로드 URL 생성에 실패했습니다.", e);
        }
    }
    
    /**
     * 🚀 공개 파일 URL 생성 (효율성 개선)
     */
    public String getPublicFileUrl(String fileName) {
        try {
            GetUrlRequest getUrlRequest = GetUrlRequest.builder()
                .bucket(s3Properties.getBucket())
                .key(fileName)
                .build();
                
            return s3Client.utilities().getUrl(getUrlRequest).toString();
        } catch (Exception e) {
            log.error("공개 URL v2 생성 실패: {}", e.getMessage());
            throw new RuntimeException("파일 URL 생성에 실패했습니다.", e);
        }
    }
    
    /**
     * 🚀 파일 삭제 (신뢰성 개선)
     */
    public boolean deleteFile(String fileName) {
        try {
            DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
                .bucket(s3Properties.getBucket())
                .key(fileName)
                .build();
                
            s3Client.deleteObject(deleteObjectRequest);
            log.info("파일 삭제 v2 완료: {}", fileName);
            return true;
        } catch (Exception e) {
            log.error("파일 삭제 v2 실패: {}", e.getMessage());
            return false;
        }
    }

    /**
     * 리뷰 이미지 업로드 (MultipartFile → S3)
     */
    public String uploadReviewImage(MultipartFile file) throws IOException {
        String ext = file.getOriginalFilename() != null ? file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf('.') + 1) : "jpg";
        String fileName = "reviews/" + UUID.randomUUID() + "." + ext;
        PutObjectRequest putObjectRequest = PutObjectRequest.builder()
                .bucket(s3Properties.getBucket())
                .key(fileName)
                .contentType(file.getContentType())
                .build();
        s3Client.putObject(putObjectRequest, software.amazon.awssdk.core.sync.RequestBody.fromInputStream(file.getInputStream(), file.getSize()));
        return fileName;
    }
} 