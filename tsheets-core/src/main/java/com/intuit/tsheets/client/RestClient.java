package com.intuit.tsheets.client;

import com.intuit.tsheets.config.DataServiceProperties;
import java.util.Collections;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class RestClient {

    private final RestTemplate restTemplate;
    private final DataServiceProperties properties;

    public RestClient(RestTemplateBuilder builder, DataServiceProperties properties) {
        this.restTemplate = builder.build();
        this.properties = properties;
    }

    private HttpHeaders defaultHeaders() {
        HttpHeaders headers = new HttpHeaders();
        headers.set(HttpHeaders.USER_AGENT, "TSheets Java SDK");
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        headers.set(HttpHeaders.AUTHORIZATION, "Bearer " + properties.getAuthToken());
        if (properties.getManagedClientId() != null) {
            headers.set("X-Managed-Client-Id", properties.getManagedClientId().toString());
        }
        return headers;
    }

    private String url(String path) {
        return properties.getBaseUrl() + path;
    }

    public ResponseEntity<String> get(String path) {
        return restTemplate.exchange(url(path), HttpMethod.GET, new HttpEntity<>(defaultHeaders()), String.class);
    }

    public ResponseEntity<String> post(String path, Object body) {
        return restTemplate.exchange(url(path), HttpMethod.POST, new HttpEntity<>(body, defaultHeaders()), String.class);
    }

    public ResponseEntity<String> put(String path, Object body) {
        return restTemplate.exchange(url(path), HttpMethod.PUT, new HttpEntity<>(body, defaultHeaders()), String.class);
    }

    public ResponseEntity<String> delete(String path) {
        return restTemplate.exchange(url(path), HttpMethod.DELETE, new HttpEntity<>(defaultHeaders()), String.class);
    }
}
