package com.intuit.tsheets.api;

import com.intuit.tsheets.client.ResilientRestClient;
import com.intuit.tsheets.config.DataServiceProperties;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class DataService {

    private final ResilientRestClient restClient;
    private final DataServiceProperties properties;

    public DataService(ResilientRestClient restClient, DataServiceProperties properties) {
        this.restClient = restClient;
        this.properties = properties;
    }

    public String getUsers() {
        ResponseEntity<String> response = restClient.get("/users");
        return response.getBody();
    }
}
