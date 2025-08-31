package com.intuit.tsheets.pipeline;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.intuit.tsheets.client.EndpointName;
import com.intuit.tsheets.model.User;
import com.intuit.tsheets.pipeline.elements.SerializationElement;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpMethod;

class SerializationElementTests {

    @Test
    void serializesUserBody() throws Exception {
        User user = new User();
        user.setFirstName("Alice");
        user.setLastName("Smith");
        user.setUsername("asmith");

        PipelineContext<Void> ctx = new PipelineContext<>(EndpointName.USERS, HttpMethod.POST, Void.class);
        ctx.setRequestBody(user);

        new SerializationElement().process(ctx);

        ObjectMapper mapper = new ObjectMapper();
        JsonNode node = mapper.readTree(ctx.getSerializedRequest());
        assertEquals("Alice", node.get("first_name").asText());
        assertEquals("Smith", node.get("last_name").asText());
        assertEquals("asmith", node.get("username").asText());
    }
}
