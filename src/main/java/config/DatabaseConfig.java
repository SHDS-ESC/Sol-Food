package config;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.TransactionManager;

import com.zaxxer.hikari.HikariDataSource;

import properties.DbProperties;

@Configuration
public class DatabaseConfig {

    private final DbProperties dbProperties;

    @Autowired
    public DatabaseConfig(DbProperties dbProperties) {
        this.dbProperties = dbProperties;
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

        // VO 필드명과 MariaDB 컬럼명 일치
        org.apache.ibatis.session.Configuration config = new org.apache.ibatis.session.Configuration();
        config.setMapUnderscoreToCamelCase(true);
        ssf.setConfiguration(config);

        return ssf.getObject();
    }

    // 트랜잭션 관리
    @Bean
    public TransactionManager transactionManager() {
        return new DataSourceTransactionManager(dataSource());
    }

}
