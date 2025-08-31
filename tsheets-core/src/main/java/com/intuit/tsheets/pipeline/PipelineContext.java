package com.intuit.tsheets.pipeline;

import com.intuit.tsheets.client.EndpointName;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;

/**
 * Carries state through the request pipeline.
 */
public class PipelineContext<T> {

    private final EndpointName endpoint;
    private final HttpMethod method;
    private final Class<T> responseType;

    private Object requestBody;
    private String serializedRequest;
    private String responseBody;
    private T result;
    private HttpStatus status;

    public PipelineContext(EndpointName endpoint, HttpMethod method, Class<T> responseType) {
        this.endpoint = endpoint;
        this.method = method;
        this.responseType = responseType;
    }

    public EndpointName getEndpoint() {
        return endpoint;
    }

    public HttpMethod getMethod() {
        return method;
    }

    public Class<T> getResponseType() {
        return responseType;
    }

    public Object getRequestBody() {
        return requestBody;
    }

    public void setRequestBody(Object requestBody) {
        this.requestBody = requestBody;
    }

    public String getSerializedRequest() {
        return serializedRequest;
    }

    public void setSerializedRequest(String serializedRequest) {
        this.serializedRequest = serializedRequest;
    }

    public String getResponseBody() {
        return responseBody;
    }

    public void setResponseBody(String responseBody) {
        this.responseBody = responseBody;
    }

    public T getResult() {
        return result;
    }

    public void setResult(T result) {
        this.result = result;
    }

    public HttpStatus getStatus() {
        return status;
    }

    public void setStatus(HttpStatus status) {
        this.status = status;
    }
}
