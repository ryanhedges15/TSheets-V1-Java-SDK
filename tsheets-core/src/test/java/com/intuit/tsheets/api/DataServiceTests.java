package com.intuit.tsheets.api;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.intuit.tsheets.client.EndpointMapper;
import com.intuit.tsheets.client.ResilientRestClient;
import com.intuit.tsheets.client.RestClient;
import com.intuit.tsheets.config.DataServiceProperties;
import com.intuit.tsheets.model.User;
import java.lang.reflect.Field;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.test.web.client.match.MockRestRequestMatchers;
import org.springframework.test.web.client.response.MockRestResponseCreators;
import org.springframework.web.client.RestTemplate;

class DataServiceTests {

    private MockRestServiceServer server;
    private DataService dataService;

    @BeforeEach
    void setup() throws Exception {
        DataServiceProperties properties = new DataServiceProperties();
        properties.setBaseUrl("https://api.example.com");
        properties.setAuthToken("token");

        RestClient restClient = new RestClient(new RestTemplateBuilder(), properties);
        ResilientRestClient resilient = new ResilientRestClient(restClient);
        EndpointMapper mapper = new EndpointMapper();
        dataService = new DataService(resilient, properties, mapper);

        Field field = RestClient.class.getDeclaredField("restTemplate");
        field.setAccessible(true);
        RestTemplate template = (RestTemplate) field.get(restClient);
        server = MockRestServiceServer.bindTo(template).build();
    }

    @Test
    void getUsersRequestsCorrectEndpoint() {
        server.expect(MockRestRequestMatchers.requestTo("https://api.example.com/users"))
            .andExpect(MockRestRequestMatchers.method(HttpMethod.GET))
            .andRespond(MockRestResponseCreators.withSuccess("{\\"users\\":[{\\"id\\":1,\\"first_name\\":\\"Alice\\",\\"last_name\\":\\"Smith\\",\\"username\\":\\"asmith\\"}]}", MediaType.APPLICATION_JSON));

        List<User> users = dataService.getUsers();
        assertEquals(1, users.size());
        assertEquals("Alice", users.get(0).getFirstName());
        server.verify();
    }
}
