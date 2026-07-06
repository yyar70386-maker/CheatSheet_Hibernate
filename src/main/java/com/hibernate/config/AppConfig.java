package com.hibernate.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.orm.hibernate5.LocalSessionFactoryBean;
import javax.sql.DataSource;
import org.springframework.jdbc.datasource.DriverManagerDataSource;


import java.util.Properties;

@Configuration
@ComponentScan(basePackages = {"com.hibernate.controller", "com.hibernate.service", "com.hibernate.repository","com.hibernate"})
@Import({WebSocketConfig.class})
public class AppConfig {

    @Bean
    public LocalSessionFactoryBean sessionFactory() {
        LocalSessionFactoryBean sessionFactory = new LocalSessionFactoryBean();
        sessionFactory.setDataSource(dataSource());
        sessionFactory.setPackagesToScan("com.hibernate.entity"); // သင်၏ Entity များရှိရာ Package
        sessionFactory.setHibernateProperties(hibernateProperties());
        return sessionFactory;
    }
    
    
    @Bean
    public DataSource dataSource() {
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("com.mysql.cj.jdbc.Driver"); // သင့် Driver
        dataSource.setUrl("jdbc:mysql://localhost:3306/cheat_sheetsdb"); // သင့် DB URL
        dataSource.setUsername("root");
        dataSource.setPassword("myanmary");
        return dataSource;
    }

    private Properties hibernateProperties() {
        Properties properties = new Properties();
        properties.put("hibernate.dialect", "org.hibernate.dialect.MySQLDialect");
        properties.put("hibernate.show_sql", "true");
        properties.put("hibernate.hbm2ddl.auto", "update");
        return properties;
    }
}