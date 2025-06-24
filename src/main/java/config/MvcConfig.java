package config;

import java.sql.Connection;

import javax.sql.DataSource;

import kr.co.solfood.admin.login.OwnerLoginInterceptor;
import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.PropertySource;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import kr.co.solfood.admin.login.AdminLoginInterceptor;
import kr.co.solfood.user.login.UserLoginInterceptor;

@Configuration
@EnableWebMvc
@ComponentScan(basePackages = {"kr.co.solfood", "util", "config", "properties"}) // 컴포넌트 스캔
@MapperScan(basePackages = "kr.co.solfood", annotationClass = Mapper.class) // @Mapper 어노테이션이 있는 인터페이스만 Proxy개체로 생성
@EnableTransactionManagement // 트랜잭션 활성화
@EnableAspectJAutoProxy // AOP 활성화
@PropertySource("classpath:application.properties")
public class MvcConfig implements WebMvcConfigurer, InitializingBean {
    @Autowired
    private DataSource dataSource;

    // DB 연결 여부 확인
    @Override
    public void afterPropertiesSet() {
        System.out.println("Name:"+dataSource.getClass().getName());

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
    public UserLoginInterceptor userLoginInterceptor() {
        return new UserLoginInterceptor();
    }

    @Bean
    public OwnerLoginInterceptor ownerLoginInterceptor() {
        return new OwnerLoginInterceptor();
    }

    @Bean
    public AdminLoginInterceptor adminLoginInterceptor() {
        return new AdminLoginInterceptor();
    }

    // 인터 셉터 추가
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(userLoginInterceptor())
                .addPathPatterns("/user/**")
                .excludePathPatterns("/user/login")
                .excludePathPatterns("/user/kakaoLogin");
//
//        registry.addInterceptor(adminLoginInterceptor())
//                .addPathPatterns("/admin/**")
//                .excludePathPatterns("/admin/login")
//                .excludePathPatterns("/admin/kakaoLogin");

        registry.addInterceptor(ownerLoginInterceptor())
                .addPathPatterns("/owner/**")
                .excludePathPatterns("/owner/login")
                .excludePathPatterns("/owner/kakaoLogin");
    }

    // Swagger
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/swagger-ui/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/springfox-swagger-ui/")
                .resourceChain(false);
    }
}
