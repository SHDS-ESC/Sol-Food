package config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import properties.DbProperties;
import properties.KakaoProperties;
import properties.S3Properties;
import properties.ServerProperties;

@Configuration
public class PropertiesConfig {
    // 데이터베이스 설정
    @Bean
    public DbProperties dbProperties(
            @Value("${db.driver}") String driver,
            @Value("${db.url}") String url,
            @Value("${db.username}") String username,
            @Value("${db.password}") String password
    ) {
        DbProperties props = new DbProperties(driver, url, username, password);
        return props;
    }

    // 서버 설정
    @Bean
    public ServerProperties serverProperties(
            @Value("${server.ip}") String ip,
            @Value("${server.port}") String port
    ) {
        ServerProperties props = new ServerProperties(ip, port);
        return props;
    }

    // 카카오 설정
    @Bean
    public KakaoProperties kakaoProperties(
            @Value("${kakao.restApiKey}") String restApiKey,
            @Value("${kakao.jsApiKey}") String jsApiKey
            ) {
        KakaoProperties props = new KakaoProperties(restApiKey, jsApiKey);
        return props;
    }

    // AWS S3 설정
    @Bean
    public S3Properties s3Properties(
            @Value("${aws.s3.bucket}") String bucket,
            @Value("${aws.s3.region}") String region,
            @Value("${aws.access.key}") String accessKey,
            @Value("${aws.secret.key}") String secretKey
            ) {
        S3Properties props = new S3Properties(bucket, region, accessKey, secretKey);
        return props;
    }

}
