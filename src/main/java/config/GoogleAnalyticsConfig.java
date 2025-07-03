package config;

import com.google.analytics.data.v1beta.BetaAnalyticsDataClient;
import com.google.analytics.data.v1beta.BetaAnalyticsDataSettings;
import com.google.api.gax.core.FixedCredentialsProvider;
import com.google.auth.oauth2.GoogleCredentials;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ResourceLoader;

import java.io.IOException;

@Configuration
public class GoogleAnalyticsConfig {

    @Value("${ga4.property-id}")
    private String propertyId;

    @Value("${ga4.key-path:classpath:goyo-415004-a06976a1469f.json}")
    private String keyPath;

    private final ResourceLoader resourceLoader;

    public GoogleAnalyticsConfig(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    @Bean(destroyMethod = "close")
    public BetaAnalyticsDataClient betaAnalyticsDataClient() throws IOException {
        // Spring ResourceLoader를 사용하여 classpath 리소스 읽기
        GoogleCredentials credentials =
                GoogleCredentials.fromStream(resourceLoader.getResource(keyPath).getInputStream());
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