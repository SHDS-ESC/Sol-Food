package properties;

import lombok.Data;

@Data
public class S3Properties {
    private final String bucket;
    private final String region;
    private final String accessKey;
    private final String secretKey;
    
    public S3Properties(String bucket, String region, String accessKey, String secretKey) {
        this.bucket = bucket;
        this.region = region;
        this.accessKey = accessKey;
        this.secretKey = secretKey;
    }
} 