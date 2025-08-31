package com.intuit.tsheets.pipeline.elements;

import com.intuit.tsheets.client.EndpointMapper;
import com.intuit.tsheets.client.ResilientRestClient;
import com.intuit.tsheets.pipeline.PipelineContext;
import com.intuit.tsheets.pipeline.PipelineElement;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

public class HttpExecutionElement implements PipelineElement {

    private final ResilientRestClient restClient;
    private final EndpointMapper endpointMapper;

    public HttpExecutionElement(ResilientRestClient restClient, EndpointMapper endpointMapper) {
        this.restClient = restClient;
        this.endpointMapper = endpointMapper;
    }

    @Override
    public void process(PipelineContext<?> context) {
        String path = endpointMapper.map(context.getEndpoint());
        ResponseEntity<String> response;
        HttpMethod method = context.getMethod();
        if (method == HttpMethod.POST) {
            response = restClient.post(path, context.getSerializedRequest());
        } else if (method == HttpMethod.PUT) {
            response = restClient.put(path, context.getSerializedRequest());
        } else if (method == HttpMethod.DELETE) {
            response = restClient.delete(path);
        } else {
            response = restClient.get(path);
        }
        context.setResponseBody(response.getBody());
        context.setStatus(response.getStatusCode());
    }
}
