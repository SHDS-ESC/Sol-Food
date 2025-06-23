package properties;

import lombok.Data;

@Data
public class ServerProperties {
    private final String ip;
    private final String port;
    
    public ServerProperties(String ip, String port) {
        this.ip = ip;
        this.port = port;
    }
}

