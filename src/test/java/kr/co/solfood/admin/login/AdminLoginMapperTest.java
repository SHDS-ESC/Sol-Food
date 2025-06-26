// src/test/java/kr/co/solfood/admin/login/AdminLoginMapperTest.java
package kr.co.solfood.admin.login;

import config.MvcConfig;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.web.WebAppConfiguration;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@ExtendWith(SpringExtension.class)
@ContextConfiguration(classes = MvcConfig.class)
@WebAppConfiguration
class AdminLoginMapperTest {

    @Autowired
    private AdminLoginMapper adminLoginMapper;

    @BeforeEach
    void setUp(@Autowired SqlSessionFactory sqlSessionFactory) {
        // SqlSessionTemplate 생성 후 매퍼 획득
        SqlSessionTemplate template = new SqlSessionTemplate(sqlSessionFactory);
        this.adminLoginMapper = template.getMapper(AdminLoginMapper.class);
    }

    @Test
    void login() {
        // given
        String password = "admin123";

        // when
        AdminVO result = adminLoginMapper.login(password);

        // then
        assertEquals(result, null);
    }
}
