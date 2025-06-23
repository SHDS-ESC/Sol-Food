package kr.co.solfood.common.s3;

import com.amazonaws.HttpMethod;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.AWSStaticCredentialsProvider;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import properties.S3Properties;

import javax.annotation.PostConstruct;
import java.net.URL;
import java.util.Date;
import java.util.UUID;

@Service
public class S3Service {
    
    @Autowired
    private S3Properties s3Properties;
    
    private AmazonS3 s3Client;
    
    @PostConstruct
    public void initializeS3Client() {
        try {
            AWSCredentials credentials = new BasicAWSCredentials(
                s3Properties.getAccessKey(), 
                s3Properties.getSecretKey()
            );
            
            this.s3Client = AmazonS3ClientBuilder.standard()
                .withCredentials(new AWSStaticCredentialsProvider(credentials))
                .withRegion(Regions.fromName(s3Properties.getRegion()))
                .build();
                
            System.out.println("✅ S3 클라이언트 초기화 완료");
        } catch (Exception e) {
            System.err.println("❌ S3 클라이언트 초기화 실패: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    /**
     * 프로필 이미지 업로드용 Pre-signed URL 생성
     */
    public String generateProfileUploadUrl(String fileExtension) {
        try {
            // 고유한 파일명 생성
            String fileName = "profiles/" + UUID.randomUUID() + "." + fileExtension;
            
            // 만료 시간 설정 (5분)
            Date expiration = new Date();
            long expTimeMillis = expiration.getTime();
            expTimeMillis += 1000 * 60 * 5; // 5분
            expiration.setTime(expTimeMillis);
            
            // Pre-signed URL 요청 생성
            GeneratePresignedUrlRequest generatePresignedUrlRequest = 
                new GeneratePresignedUrlRequest(s3Properties.getBucket(), fileName)
                    .withMethod(HttpMethod.PUT)
                    .withExpiration(expiration);
            
            // Pre-signed URL 생성
            URL url = s3Client.generatePresignedUrl(generatePresignedUrlRequest);
            
            System.out.println("Pre-signed URL 생성 완료: " + fileName);
            return url.toString();
            
        } catch (Exception e) {
            System.err.println("Pre-signed URL 생성 실패: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("파일 업로드 URL 생성에 실패했습니다.", e);
        }
    }
    
    /**
     * 업로드된 파일의 공개 URL 생성
     */
    public String getPublicUrl(String fileName) {
        try {
            return s3Client.getUrl(s3Properties.getBucket(), fileName).toString();
        } catch (Exception e) {
            System.err.println("공개 URL 생성 실패: " + e.getMessage());
            throw new RuntimeException("파일 URL 생성에 실패했습니다.", e);
        }
    }
    
    /**
     * 파일 삭제
     */
    public boolean deleteFile(String fileName) {
        try {
            s3Client.deleteObject(s3Properties.getBucket(), fileName);
            System.out.println("파일 삭제 완료: " + fileName);
            return true;
        } catch (Exception e) {
            System.err.println("파일 삭제 실패: " + e.getMessage());
            return false;
        }
    }
} 