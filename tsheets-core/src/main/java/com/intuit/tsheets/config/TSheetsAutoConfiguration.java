package com.intuit.tsheets.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan("com.intuit.tsheets")
@EnableConfigurationProperties(DataServiceProperties.class)
public class TSheetsAutoConfiguration {
}

