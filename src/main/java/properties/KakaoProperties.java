package properties;

import lombok.Data;

@Data
public class KakaoProperties {
    private final String restApiKey;
    private final String jsApiKey;
    
    public KakaoProperties(String restApiKey, String jsApiKey) {
        this.restApiKey = restApiKey;
        this.jsApiKey = jsApiKey;
    }
}

