package config;

import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.servlet.config.annotation.*;
import util.Interceptor;

import javax.sql.DataSource;
import java.sql.Connection;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {"kr.co.solfood", "util"}) // 컴포넌트 스캔
@MapperScan(basePackages = "kr.co.solfood", annotationClass = Mapper.class) // @Mapper 어노테이션이 있는 인터페이스만 Proxy개체로 생성
@EnableTransactionManagement // 트랜잭션 활성화
@EnableAspectJAutoProxy // AOP 활성화
public class MvcConfig implements WebMvcConfigurer, InitializingBean {

    @Autowired
    private DataSource dataSource;

    // DB 연결 여부 확인
    @Override
    public void afterPropertiesSet() {
        try (Connection conn = dataSource.getConnection()) {
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

    // 정적리소스 처리(스프링이 아니라 톰캣이 처리하도록) 활성화
    @Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer config) {
        config.enable();
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
                .excludePathPatterns("/user/**")
                .excludePathPatterns("/admin/**")
                .excludePathPatterns("/owner/**")
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