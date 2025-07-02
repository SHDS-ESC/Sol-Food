package config;

import com.google.analytics.data.v1beta.BetaAnalyticsDataClient;
import com.google.analytics.data.v1beta.BetaAnalyticsDataSettings;
import com.google.api.gax.core.FixedCredentialsProvider;
import com.google.auth.oauth2.GoogleCredentials;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.io.FileInputStream;
import java.io.IOException;

@Configuration
public class GoogleAnalyticsConfig {

    @Value("${ga4.property-id}")
    private String propertyId;

    @Value("${ga4.key-path:/opt/ga/key.json}")  // 필요 시
    private String keyPath;

    @Bean(destroyMethod = "close")
    public BetaAnalyticsDataClient betaAnalyticsDataClient() throws IOException {
        // 키 파일을 코드에서 직접 지정
        GoogleCredentials credentials =
                GoogleCredentials.fromStream(new FileInputStream(keyPath));
        BetaAnalyticsDataSettings settings = BetaAnalyticsDataSettings.newBuilder()
                .setCredentialsProvider(FixedCredentialsProvider.create(credentials))
                .build();
        return BetaAnalyticsDataClient.create(settings);
    }

    @Bean
    public String ga4PropertyId() {
        return propertyId;
    }
}