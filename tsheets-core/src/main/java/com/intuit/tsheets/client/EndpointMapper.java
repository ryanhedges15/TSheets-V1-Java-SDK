package com.intuit.tsheets.client;

import java.util.EnumMap;
import java.util.Map;
import org.springframework.stereotype.Component;

@Component
public class EndpointMapper {

    private final Map<EndpointName, String> mapping = new EnumMap<>(EndpointName.class);

    public EndpointMapper() {
        mapping.put(EndpointName.USERS, "/users");
        mapping.put(EndpointName.TIMESHEETS, "/timesheets");
    }

    public String map(EndpointName name) {
        return mapping.get(name);
    }
}
