package com.intuit.tsheets.client;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class EndpointMapperTests {

    @Test
    void mapsUsersEndpoint() {
        EndpointMapper mapper = new EndpointMapper();
        assertEquals("/users", mapper.map(EndpointName.USERS));
    }
}
