package properties;

import lombok.Data;

@Data
public class KakaoProperties {
    private final String restApiKey;
    
    public KakaoProperties(String restApiKey) {
        this.restApiKey = restApiKey;
    }
}

