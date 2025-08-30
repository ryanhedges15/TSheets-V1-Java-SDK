package com.intuit.tsheets.client;

import java.util.Collections;
import org.springframework.http.ResponseEntity;
import org.springframework.retry.backoff.ExponentialBackOffPolicy;
import org.springframework.retry.policy.SimpleRetryPolicy;
import org.springframework.retry.support.RetryTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;

@Component
public class ResilientRestClient {

    private final RestClient restClient;
    private final RetryTemplate retryTemplate;

    public ResilientRestClient(RestClient restClient) {
        this.restClient = restClient;
        this.retryTemplate = buildRetryTemplate();
    }

    private RetryTemplate buildRetryTemplate() {
        RetryTemplate template = new RetryTemplate();
        ExponentialBackOffPolicy backOff = new ExponentialBackOffPolicy();
        backOff.setInitialInterval(200L);
        backOff.setMultiplier(2.0);
        backOff.setMaxInterval(2000L);
        template.setBackOffPolicy(backOff);

        SimpleRetryPolicy retryPolicy = new SimpleRetryPolicy(3,
            Collections.singletonMap(RestClientException.class, true));
        template.setRetryPolicy(retryPolicy);
        return template;
    }

    public ResponseEntity<String> get(String path) {
        return retryTemplate.execute(context -> restClient.get(path));
    }

    public ResponseEntity<String> post(String path, Object body) {
        return retryTemplate.execute(context -> restClient.post(path, body));
    }

    public ResponseEntity<String> put(String path, Object body) {
        return retryTemplate.execute(context -> restClient.put(path, body));
    }

    public ResponseEntity<String> delete(String path) {
        return retryTemplate.execute(context -> restClient.delete(path));
    }
}
