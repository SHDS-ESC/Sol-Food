package properties;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Data
@Component
public class DbProperties {
    private final String driver;
    private final String url;
    private final String username;
    private final String password;
    
    public DbProperties(
            @Value("${db.driver}") String driver,
            @Value("${db.url}") String url,
            @Value("${db.username}") String username,
            @Value("${db.password}") String password
    ) {
        this.driver = driver;
        this.url = url;
        this.username = username;
        this.password = password;
    }
}
