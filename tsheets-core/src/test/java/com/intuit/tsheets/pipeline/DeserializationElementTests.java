package com.intuit.tsheets.pipeline;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.intuit.tsheets.client.EndpointName;
import com.intuit.tsheets.model.UsersResponse;
import com.intuit.tsheets.pipeline.elements.DeserializationElement;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpMethod;

class DeserializationElementTests {

    @Test
    void deserializesUsersResponse() {
        String json = "{\"users\":[{\"id\":1,\"first_name\":\"Alice\",\"last_name\":\"Smith\",\"username\":\"asmith\"}]}";
        PipelineContext<UsersResponse> ctx = new PipelineContext<>(EndpointName.USERS, HttpMethod.GET, UsersResponse.class);
        ctx.setResponseBody(json);

        new DeserializationElement().process(ctx);

        UsersResponse resp = ctx.getResult();
        assertEquals(1, resp.getUsers().size());
        assertEquals("Alice", resp.getUsers().get(0).getFirstName());
    }
}
