package com.intuit.tsheets.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableConfigurationProperties(DataServiceProperties.class)
public class CoreAutoConfiguration {
}

