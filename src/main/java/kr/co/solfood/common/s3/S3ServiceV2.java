package kr.co.solfood.common.s3;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import properties.S3Properties;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.GetUrlRequest;
import software.amazon.awssdk.services.s3.presigner.S3Presigner;
import software.amazon.awssdk.services.s3.presigner.model.PresignedPutObjectRequest;
import software.amazon.awssdk.services.s3.presigner.model.PutObjectPresignRequest;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;
import java.time.Duration;
import java.util.UUID;

@Service
public class S3ServiceV2 {
    
    @Autowired
    private S3Properties s3Properties;
    
    private S3Client s3Client;
    private S3Presigner s3Presigner;
    
    @PostConstruct
    public void initializeS3Client() {
        try {
            AwsBasicCredentials credentials = AwsBasicCredentials.create(
                s3Properties.getAccessKey(), 
                s3Properties.getSecretKey()
            );
            
            StaticCredentialsProvider credentialsProvider = StaticCredentialsProvider.create(credentials);
            Region region = Region.of(s3Properties.getRegion());
            
            // S3 클라이언트 초기화
            this.s3Client = S3Client.builder()
                .credentialsProvider(credentialsProvider)
                .region(region)
                .build();
                
            // S3 Presigner 초기화 (Pre-signed URL 생성용)
            this.s3Presigner = S3Presigner.builder()
                .credentialsProvider(credentialsProvider)
                .region(region)
                .build();
                
            System.out.println("✅ S3 클라이언트 v2 초기화 완료 (성능 향상)");
        } catch (Exception e) {
            System.err.println("❌ S3 클라이언트 v2 초기화 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    @PreDestroy // Bean 소멸 전 연결 해제
    public void cleanup() {
        if (s3Client != null) {
            s3Client.close();
        }
        if (s3Presigner != null) {
            s3Presigner.close();
        }
    }
    
    /**
     * 프로필 이미지 업로드용 Pre-signed URL 생성 (AWS SDK v2)
     */
    public String generateProfileUploadUrl(String fileExtension) {
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
            
            System.out.println("Pre-signed URL v2 생성 완료: " + fileName);
            return presignedRequest.url().toString();
            
        } catch (Exception e) {
            System.err.println("Pre-signed URL v2 생성 실패: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("파일 업로드 URL 생성에 실패했습니다.", e);
        }
    }
    
    /**
     * 업로드된 파일의 공개 URL 생성 (AWS SDK v2)
     */
    public String getPublicUrl(String fileName) {
        try {
            GetUrlRequest getUrlRequest = GetUrlRequest.builder()
                .bucket(s3Properties.getBucket())
                .key(fileName)
                .build();
                
            return s3Client.utilities().getUrl(getUrlRequest).toString();
        } catch (Exception e) {
            System.err.println("공개 URL v2 생성 실패: " + e.getMessage());
            throw new RuntimeException("파일 URL 생성에 실패했습니다.", e);
        }
    }
    
    /**
     * 파일 삭제 (AWS SDK v2)
     */
    public boolean deleteFile(String fileName) {
        try {
            DeleteObjectRequest deleteObjectRequest = DeleteObjectRequest.builder()
                .bucket(s3Properties.getBucket())
                .key(fileName)
                .build();
                
            s3Client.deleteObject(deleteObjectRequest);
            System.out.println("파일 삭제 v2 완료: " + fileName);
            return true;
        } catch (Exception e) {
            System.err.println("파일 삭제 v2 실패: " + e.getMessage());
            return false;
        }
    }
} 