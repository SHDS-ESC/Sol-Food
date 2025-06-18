package config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import properties.DbProperties;
import properties.ServerProperties;
import properties.KakaoProperties;

@Configuration
@PropertySource("classpath:application.properties")
public class PropertiesConfig {

    // 데이터베이스 설정
    @Bean
    public DbProperties dbProperties(
            @Value("${db.driver}") String driver,
            @Value("${db.url}") String url,
            @Value("${db.username}") String username,
            @Value("${db.password}") String password
    ) {
        DbProperties props = new DbProperties();
        props.setDriver(driver);
        props.setUrl(url);
        props.setUsername(username);
        props.setPassword(password);
        return props;
    }

    // 서버 설정
    @Bean
    public ServerProperties serverProperties(
            @Value("${server.ip}") String ip,
            @Value("${server.port}") String port
    ) {
        ServerProperties props = new ServerProperties();
        props.setIp(ip);
        props.setPort(port);
        return props;
    }

    // 카카오 설정
    @Bean
    public KakaoProperties kakaoProperties(
            @Value("${kakao.respApiKey}") String restApiKey
    ) {
        KakaoProperties props = new KakaoProperties();
        props.setRestApiKey(restApiKey);
        return props;
    }
} 