package properties;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Data
@Component
public class KakaoProperties {
    private final String restApiKey;
    
    public KakaoProperties(@Value("${kakao.restApiKey}") String restApiKey) {
        this.restApiKey = restApiKey;
    }
}

