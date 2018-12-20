package com.fanyin;

import com.fanyin.utils.SpringContextUtil;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.Banner;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.solr.SolrAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.ServletComponentScan;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.transaction.annotation.EnableTransactionManagement;

/**
 * 程序启动入口
 * @author 二哥很猛
 */
@SpringBootApplication(exclude = SolrAutoConfiguration.class)
@EnableTransactionManagement
@EnableAsync
@EnableAspectJAutoProxy
@MapperScan("com.fanyin.mapper")
@ServletComponentScan(basePackages = "com.fanyin.filter")
public class Application {

    public static void main(String[] args) {
        ConfigurableApplicationContext applicationContext = new SpringApplicationBuilder(Application.class).bannerMode(Banner.Mode.OFF).run(args);
        SpringContextUtil.setApplicationContext(applicationContext);
    }
}
