package com.intuit.tsheets.api;

import com.intuit.tsheets.client.EndpointMapper;
import com.intuit.tsheets.client.EndpointName;
import com.intuit.tsheets.client.ResilientRestClient;
import com.intuit.tsheets.config.DataServiceProperties;
import com.intuit.tsheets.model.User;
import com.intuit.tsheets.model.UsersResponse;
import com.intuit.tsheets.model.Timesheet;
import com.intuit.tsheets.model.TimesheetsResponse;
import com.intuit.tsheets.pipeline.PipelineContext;
import com.intuit.tsheets.pipeline.RequestPipeline;
import com.intuit.tsheets.pipeline.elements.DeserializationElement;
import com.intuit.tsheets.pipeline.elements.HttpExecutionElement;
import com.intuit.tsheets.pipeline.elements.SerializationElement;
import com.intuit.tsheets.pipeline.elements.ValidationElement;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;

@Service
public class DataService {

    private final ResilientRestClient restClient;
    private final DataServiceProperties properties;
    private final EndpointMapper endpointMapper;

    public DataService(ResilientRestClient restClient, DataServiceProperties properties, EndpointMapper endpointMapper) {
        this.restClient = restClient;
        this.properties = properties;
        this.endpointMapper = endpointMapper;
    }

    public List<User> getUsers() {
        PipelineContext<UsersResponse> context = new PipelineContext<>(EndpointName.USERS, HttpMethod.GET, UsersResponse.class);
        RequestPipeline pipeline = new RequestPipeline(Arrays.asList(
            new ValidationElement(),
            new SerializationElement(),
            new HttpExecutionElement(restClient, endpointMapper),
            new DeserializationElement()
        ));
        pipeline.execute(context);
        UsersResponse response = context.getResult();
        return response != null ? response.getUsers() : Collections.emptyList();
    }

    public List<Timesheet> getTimesheets() {
        PipelineContext<TimesheetsResponse> context = new PipelineContext<>(EndpointName.TIMESHEETS, HttpMethod.GET, TimesheetsResponse.class);
        RequestPipeline pipeline = new RequestPipeline(Arrays.asList(
            new ValidationElement(),
            new SerializationElement(),
            new HttpExecutionElement(restClient, endpointMapper),
            new DeserializationElement()
        ));
        pipeline.execute(context);
        TimesheetsResponse response = context.getResult();
        return response != null ? response.getTimesheets() : Collections.emptyList();
    }
}
