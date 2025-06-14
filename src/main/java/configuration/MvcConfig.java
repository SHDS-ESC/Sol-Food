package configuration;

import com.zaxxer.hikari.HikariDataSource;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.TransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.servlet.config.annotation.*;
import util.Interceptor;

import javax.sql.DataSource;
import java.sql.Connection;

@Configuration
@PropertySource("classpath:application.properties")
@EnableWebMvc
@ComponentScan(basePackages = {"kr.co.solfood", "util"}) // 컴포넌트 스캔
@MapperScan(basePackages = "kr.co.solfood", annotationClass = Mapper.class) // @Mapper 어노테이션이 있는 인터페이스만 Proxy개체로 생성
@EnableTransactionManagement // 트랜잭션 활성화
public class MvcConfig implements WebMvcConfigurer, InitializingBean {

    @Autowired
    private DbProperties dbProperties;

    @Autowired
    private ServerProperties serverProperties;

    @Autowired
    private KakaoProperties kakaoProperties;

    // DB 연결 여부 확인
    @Override
    public void afterPropertiesSet() {
        try (Connection conn = dataSource().getConnection()) {
            System.out.println("✅ DB 연결 성공: " + conn.getMetaData().getURL());
        } catch (Exception e) {
            System.err.println("❌ DB 연결 실패: " + e.getMessage());
        }
    }

    // 뷰리졸버 - 컨트롤러에서 포워딩할 경로(앞/뒤) 설정
    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.jsp("/WEB-INF/views/", ".jsp");
    }

    // 비즈니스로직이 필요없는 페이지 예시
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/home.do").setViewName("home");
    }

    // properties 에서 db정보 가져와 값 세팅
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

    @Bean
    public KakaoProperties kakaoProperties(
            @Value("${kakao.respApiKey}") String restApiKey
    ) {
        KakaoProperties props = new KakaoProperties();
        props.setRestApiKey(restApiKey);
        return props;
    }

    // 정적리소스 처리(스프링이 아니라 톰캣이 처리하도록) 활성화
    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer config) {
        config.enable();
    }


    // HikariCP
    @Bean
    public DataSource dataSource() {
        HikariDataSource ds = new HikariDataSource();
        ds.setDriverClassName(dbProperties.getDriver());
        ds.setJdbcUrl(dbProperties.getUrl());
        ds.setUsername(dbProperties.getUsername());
        ds.setPassword(dbProperties.getPassword());
        return ds;
    }

    // MyBatis
    @Bean
    public SqlSessionFactory sqlSessionFactory() throws Exception {
        SqlSessionFactoryBean ssf = new SqlSessionFactoryBean();
        ssf.setDataSource(dataSource());
        // VO 클래스의 필드명과 MaridDB의 컬럼명을 일치 (VO는 camelCase, DB는 snake_case)
        org.apache.ibatis.session.Configuration config = new org.apache.ibatis.session.Configuration();
        config.setMapUnderscoreToCamelCase(true); // underscores → camelCase
        ssf.setConfiguration(config);

        return ssf.getObject();
    }

    // 트랜잭션매니저 빈 등록
    @Bean
    public TransactionManager tm() {
        return new DataSourceTransactionManager(dataSource());
    }

    // 인터셉터를 빈으로 등록
    @Bean
    public Interceptor interceptor() {
        return new Interceptor();
    }

    // 인터셉터 추가
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(interceptor())
                .excludePathPatterns("/user/login")
                .excludePathPatterns("/user/kakaoLogin");
    }

    // Swagger
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/swagger-ui/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/springfox-swagger-ui/")
                .resourceChain(false);
    }
}
