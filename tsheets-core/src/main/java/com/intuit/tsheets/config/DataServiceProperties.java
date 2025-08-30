package com.intuit.tsheets.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties("tsheets")
public class DataServiceProperties {

    private String baseUrl;
    private String authToken;
    private Long managedClientId;

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public String getAuthToken() {
        return authToken;
    }

    public void setAuthToken(String authToken) {
        this.authToken = authToken;
    }

    public Long getManagedClientId() {
        return managedClientId;
    }

    public void setManagedClientId(Long managedClientId) {
        this.managedClientId = managedClientId;
    }
}

