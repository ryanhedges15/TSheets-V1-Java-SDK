package com.intuit.tsheets.pipeline.elements;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.intuit.tsheets.pipeline.PipelineContext;
import com.intuit.tsheets.pipeline.PipelineElement;
import java.io.IOException;

/**
 * Deserializes the response body into the desired type.
 */
public class DeserializationElement implements PipelineElement {

    private final ObjectMapper objectMapper = new ObjectMapper().findAndRegisterModules();

    @Override
    public void process(PipelineContext<?> context) {
        String body = context.getResponseBody();
        Class<?> type = context.getResponseType();
        if (body != null && type != null) {
            try {
                Object result = objectMapper.readValue(body, type);
                @SuppressWarnings("unchecked")
                PipelineContext<Object> ctx = (PipelineContext<Object>) context;
                ctx.setResult(result);
            } catch (IOException e) {
                throw new RuntimeException("Failed to deserialize response", e);
            }
        }
    }
}
