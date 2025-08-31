package com.intuit.tsheets.pipeline.elements;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.intuit.tsheets.pipeline.PipelineContext;
import com.intuit.tsheets.pipeline.PipelineElement;

/**
 * Serializes the request body using Jackson.
 */
public class SerializationElement implements PipelineElement {

    private final ObjectMapper objectMapper = new ObjectMapper().findAndRegisterModules();

    @Override
    public void process(PipelineContext<?> context) {
        Object body = context.getRequestBody();
        if (body != null) {
            try {
                context.setSerializedRequest(objectMapper.writeValueAsString(body));
            } catch (JsonProcessingException e) {
                throw new RuntimeException("Failed to serialize request", e);
            }
        }
    }
}
