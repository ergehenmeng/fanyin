package com.fanyin.configuration;

import com.fanyin.controller.AbstractUploadController;
import com.fanyin.controller.ErrorPageController;
import org.apache.catalina.connector.Connector;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.web.ErrorAttributes;
import org.springframework.boot.autoconfigure.web.ErrorViewResolver;
import org.springframework.boot.autoconfigure.web.ServerProperties;
import org.springframework.boot.context.embedded.EmbeddedServletContainerFactory;
import org.springframework.boot.context.embedded.tomcat.TomcatEmbeddedServletContainerFactory;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;

import java.util.List;

/**
 * mvc配置信息
 * @author 二哥很猛
 * @date 2018/1/18 18:35
 */
@Configuration
@EnableConfigurationProperties({ApplicationProperties.class,ServerProperties.class})
public class ManageWebMvcConfiguration extends WebMvcConfiguration {

    @Autowired
    private ApplicationProperties applicationProperties;

    @Autowired
    private ServerProperties serverProperties;


    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/upload/**").addResourceLocations(applicationProperties.getUploadDir() + AbstractUploadController.DEFAULT_DIR);
        super.addResourceHandlers(registry);
    }



    @Bean
    public EmbeddedServletContainerFactory servletContainerFactory(){
        TomcatEmbeddedServletContainerFactory factory = new TomcatEmbeddedServletContainerFactory();
        factory.addAdditionalTomcatConnectors(connector());
        return factory;
    }

    @Bean
    public ErrorPageController errorPageController(ErrorAttributes errorAttributes,ObjectProvider<List<ErrorViewResolver>> errorViewResolversProvider){
        return new ErrorPageController(errorAttributes,errorViewResolversProvider.getIfAvailable(),serverProperties.getError());
    }

    /**
     * 将所有的链接由8081 转到 8080
     * @return 连接器
     */
    @Bean
    public Connector connector(){
        Connector connector = new Connector("org.apache.coyote.http11.Http11NioProtocol");
        connector.setScheme("http");
        connector.setPort(8081);
        connector.setSecure(false);
        connector.setRedirectPort(8080);
        return connector;
    }
}
