package properties;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Data
@Component
public class ServerProperties {
    private final String ip;
    private final String port;
    
    public ServerProperties(
            @Value("${server.ip}") String ip,
            @Value("${server.port}") String port
    ) {
        this.ip = ip;
        this.port = port;
    }
}

