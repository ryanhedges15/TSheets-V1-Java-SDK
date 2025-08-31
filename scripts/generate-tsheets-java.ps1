Param(
  [string]$Target = "."
)

$ErrorActionPreference = "Stop"

function Write-File($Path, $Content) {
  $full = Join-Path -Path (Resolve-Path $Target) -ChildPath $Path
  $dir = Split-Path -Path $full -Parent
  if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
  [System.IO.File]::WriteAllText($full, $Content, [System.Text.Encoding]::UTF8)
  Write-Host "Wrote" $Path
}

$files = @()

$files += [pscustomobject]@{ Path = "pom.xml"; Content = @'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.7.18</version>
        <relativePath/>
    </parent>

    <groupId>com.intuit.tsheets</groupId>
    <artifactId>tsheets-parent</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>pom</packaging>
    <name>TSheets Parent</name>
    <description>Parent for the TSheets Spring Boot multi-module project</description>

    <modules>
        <module>tsheets-core</module>
        <module>tsheets-examples</module>
        <module>tsheets-tests</module>
    </modules>

    <properties>
        <java.version>11</java.version>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>com.fasterxml.jackson.datatype</groupId>
                <artifactId>jackson-datatype-jsr310</artifactId>
                <version>2.17.2</version>
            </dependency>
        </dependencies>
    </dependencyManagement>
</project>
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/pom.xml"; Content = @'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>com.intuit.tsheets</groupId>
        <artifactId>tsheets-parent</artifactId>
        <version>0.0.1-SNAPSHOT</version>
    </parent>

    <artifactId>tsheets-core</artifactId>
    <name>TSheets Core</name>
    <description>Core library for TSheets Spring Boot SDK</description>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-configuration-processor</artifactId>
            <optional>true</optional>
        </dependency>

        <dependency>
            <groupId>com.fasterxml.jackson.datatype</groupId>
            <artifactId>jackson-datatype-jsr310</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.retry</groupId>
            <artifactId>spring-retry</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

</project>
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/config/DataServiceProperties.java"; Content = @'
package com.intuit.tsheets.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties("tsheets")
public class DataServiceProperties {

    private String baseUrl;
    private String authToken;
    private Long managedClientId;

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public String getAuthToken() {
        return authToken;
    }

    public void setAuthToken(String authToken) {
        this.authToken = authToken;
    }

    public Long getManagedClientId() {
        return managedClientId;
    }

    public void setManagedClientId(Long managedClientId) {
        this.managedClientId = managedClientId;
    }
}
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/config/TSheetsAutoConfiguration.java"; Content = @'
package com.intuit.tsheets.config;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@ComponentScan("com.intuit.tsheets")
@EnableConfigurationProperties(DataServiceProperties.class)
public class TSheetsAutoConfiguration {
}

'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/resources/META-INF/spring.factories"; Content = @'
org.springframework.boot.autoconfigure.EnableAutoConfiguration=\
com.intuit.tsheets.config.TSheetsAutoConfiguration
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/client/RestClient.java"; Content = @'
package com.intuit.tsheets.client;

import com.intuit.tsheets.config.DataServiceProperties;
import java.util.Collections;
import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class RestClient {

    private final RestTemplate restTemplate;
    private final DataServiceProperties properties;

    public RestClient(RestTemplateBuilder builder, DataServiceProperties properties) {
        this.restTemplate = builder.build();
        this.properties = properties;
    }

    private HttpHeaders defaultHeaders() {
        HttpHeaders headers = new HttpHeaders();
        headers.set(HttpHeaders.USER_AGENT, "TSheets Java SDK");
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));
        headers.set(HttpHeaders.AUTHORIZATION, "Bearer " + properties.getAuthToken());
        if (properties.getManagedClientId() != null) {
            headers.set("X-Managed-Client-Id", properties.getManagedClientId().toString());
        }
        return headers;
    }

    private String url(String path) {
        return properties.getBaseUrl() + path;
    }

    public ResponseEntity<String> get(String path) {
        return restTemplate.exchange(url(path), HttpMethod.GET, new HttpEntity<>(defaultHeaders()), String.class);
    }

    public ResponseEntity<String> post(String path, Object body) {
        return restTemplate.exchange(url(path), HttpMethod.POST, new HttpEntity<>(body, defaultHeaders()), String.class);
    }

    public ResponseEntity<String> put(String path, Object body) {
        return restTemplate.exchange(url(path), HttpMethod.PUT, new HttpEntity<>(body, defaultHeaders()), String.class);
    }

    public ResponseEntity<String> delete(String path) {
        return restTemplate.exchange(url(path), HttpMethod.DELETE, new HttpEntity<>(defaultHeaders()), String.class);
    }
}
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/client/ResilientRestClient.java"; Content = @'
package com.intuit.tsheets.client;

import java.util.Collections;
import org.springframework.http.ResponseEntity;
import org.springframework.retry.backoff.ExponentialBackOffPolicy;
import org.springframework.retry.policy.SimpleRetryPolicy;
import org.springframework.retry.support.RetryTemplate;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClientException;

@Component
public class ResilientRestClient {

    private final RestClient restClient;
    private final RetryTemplate retryTemplate;

    public ResilientRestClient(RestClient restClient) {
        this.restClient = restClient;
        this.retryTemplate = buildRetryTemplate();
    }

    private RetryTemplate buildRetryTemplate() {
        RetryTemplate template = new RetryTemplate();
        ExponentialBackOffPolicy backOff = new ExponentialBackOffPolicy();
        backOff.setInitialInterval(200L);
        backOff.setMultiplier(2.0);
        backOff.setMaxInterval(2000L);
        template.setBackOffPolicy(backOff);

        SimpleRetryPolicy retryPolicy = new SimpleRetryPolicy(3,
            Collections.singletonMap(RestClientException.class, true));
        template.setRetryPolicy(retryPolicy);
        return template;
    }

    public ResponseEntity<String> get(String path) {
        return retryTemplate.execute(context -> restClient.get(path));
    }

    public ResponseEntity<String> post(String path, Object body) {
        return retryTemplate.execute(context -> restClient.post(path, body));
    }

    public ResponseEntity<String> put(String path, Object body) {
        return retryTemplate.execute(context -> restClient.put(path, body));
    }

    public ResponseEntity<String> delete(String path) {
        return retryTemplate.execute(context -> restClient.delete(path));
    }
}
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/client/EndpointName.java"; Content = @'
package com.intuit.tsheets.client;

public enum EndpointName {
    USERS,
    TIMESHEETS;
}
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/client/EndpointMapper.java"; Content = @'
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
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/pipeline/PipelineElement.java"; Content = @'
package com.intuit.tsheets.pipeline;

/**
 * Element in a request pipeline that can operate on a {@link PipelineContext}.
 */
public interface PipelineElement {

    /**
     * Process the given context, potentially mutating it for the next element in the chain.
     *
     * @param context the request/response context
     */
    void process(PipelineContext<?> context);
}

'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/pipeline/RequestPipeline.java"; Content = @'
package com.intuit.tsheets.pipeline;

import java.util.List;

public class RequestPipeline {

    private final List<PipelineElement> elements;

    public RequestPipeline(List<PipelineElement> elements) {
        this.elements = elements;
    }

    /**
     * Execute the pipeline against the provided context.
     *
     * @param context the context carrying request and response information
     */
    public void execute(PipelineContext<?> context) {
        for (PipelineElement element : elements) {
            element.process(context);
        }
    }
}
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/pipeline/PipelineContext.java"; Content = @'
package com.intuit.tsheets.pipeline;

import com.intuit.tsheets.client.EndpointName;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;

/**
 * Carries state through the request pipeline.
 */
public class PipelineContext<T> {

    private final EndpointName endpoint;
    private final HttpMethod method;
    private final Class<T> responseType;

    private Object requestBody;
    private String serializedRequest;
    private String responseBody;
    private T result;
    private HttpStatus status;

    public PipelineContext(EndpointName endpoint, HttpMethod method, Class<T> responseType) {
        this.endpoint = endpoint;
        this.method = method;
        this.responseType = responseType;
    }

    public EndpointName getEndpoint() {
        return endpoint;
    }

    public HttpMethod getMethod() {
        return method;
    }

    public Class<T> getResponseType() {
        return responseType;
    }

    public Object getRequestBody() {
        return requestBody;
    }

    public void setRequestBody(Object requestBody) {
        this.requestBody = requestBody;
    }

    public String getSerializedRequest() {
        return serializedRequest;
    }

    public void setSerializedRequest(String serializedRequest) {
        this.serializedRequest = serializedRequest;
    }

    public String getResponseBody() {
        return responseBody;
    }

    public void setResponseBody(String responseBody) {
        this.responseBody = responseBody;
    }

    public T getResult() {
        return result;
    }

    public void setResult(T result) {
        this.result = result;
    }

    public HttpStatus getStatus() {
        return status;
    }

    public void setStatus(HttpStatus status) {
        this.status = status;
    }
}
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/pipeline/elements/ValidationElement.java"; Content = @'
package com.intuit.tsheets.pipeline.elements;

import com.intuit.tsheets.pipeline.PipelineContext;
import com.intuit.tsheets.pipeline.PipelineElement;

public class ValidationElement implements PipelineElement {

    @Override
    public void process(PipelineContext<?> context) {
        // Placeholder for request validation
    }
}

'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/pipeline/elements/SerializationElement.java"; Content = @'
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
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/pipeline/elements/HttpExecutionElement.java"; Content = @'
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
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/pipeline/elements/DeserializationElement.java"; Content = @'
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
'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/model/User.java"; Content = @'
package com.intuit.tsheets.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.OffsetDateTime;
import javax.validation.constraints.NotBlank;

/**
 * Represents a TSheets user.
 */
public class User {

    @JsonProperty(value = "id", access = JsonProperty.Access.READ_ONLY)
    private Long id;

    @NotBlank
    @JsonProperty("first_name")
    private String firstName;

    @NotBlank
    @JsonProperty("last_name")
    private String lastName;

    @JsonProperty("display_name")
    private String displayName;

    @JsonProperty("pronouns")
    private String pronouns;

    @JsonProperty("group_id")
    private Long groupId;

    @JsonProperty("active")
    private Boolean active;

    @JsonProperty("employee_number")
    private Long employeeNumber;

    @JsonProperty("salaried")
    private Boolean salaried;

    @JsonProperty("exempt")
    private Boolean exempt;

    @NotBlank
    @JsonProperty("username")
    private String username;

    @JsonProperty("email")
    private String email;

    @JsonProperty(value = "email_verified", access = JsonProperty.Access.READ_ONLY)
    private Boolean emailVerified;

    @JsonProperty("payroll_id")
    private String payrollId;

    @JsonProperty("mobile_number")
    private String mobileNumber;

    @JsonProperty("hire_date")
    private OffsetDateTime hireDate;

    @JsonProperty("term_date")
    private OffsetDateTime termDate;

    @JsonProperty(value = "last_modified", access = JsonProperty.Access.READ_ONLY)
    private OffsetDateTime lastModified;

    @JsonProperty(value = "last_active", access = JsonProperty.Access.READ_ONLY)
    private OffsetDateTime lastActive;

    @JsonProperty(value = "created", access = JsonProperty.Access.READ_ONLY)
    private OffsetDateTime created;

    @JsonProperty(value = "client_url", access = JsonProperty.Access.READ_ONLY)
    private String clientUrl;

    @JsonProperty(value = "company_name", access = JsonProperty.Access.READ_ONLY)
    private String companyName;

    public Long getId() {
        return id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getPronouns() {
        return pronouns;
    }

    public void setPronouns(String pronouns) {
        this.pronouns = pronouns;
    }

    public Long getGroupId() {
        return groupId;
    }

    public void setGroupId(Long groupId) {
        this.groupId = groupId;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public Long getEmployeeNumber() {
        return employeeNumber;
    }

    public void setEmployeeNumber(Long employeeNumber) {
        this.employeeNumber = employeeNumber;
    }

    public Boolean getSalaried() {
        return salaried;
    }

    public void setSalaried(Boolean salaried) {
        this.salaried = salaried;
    }

    public Boolean getExempt() {
        return exempt;
    }

    public void setExempt(Boolean exempt) {
        this.exempt = exempt;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Boolean getEmailVerified() {
        return emailVerified;
    }

    public String getPayrollId() {
        return payrollId;
    }

    public void setPayrollId(String payrollId) {
        this.payrollId = payrollId;
    }

    public String getMobileNumber() {
        return mobileNumber;
    }

    public void setMobileNumber(String mobileNumber) {
        this.mobileNumber = mobileNumber;
    }

    public OffsetDateTime getHireDate() {
        return hireDate;
    }

    public void setHireDate(OffsetDateTime hireDate) {
        this.hireDate = hireDate;
    }

    public OffsetDateTime getTermDate() {
        return termDate;
    }

    public void setTermDate(OffsetDateTime termDate) {
        this.termDate = termDate;
    }

    public OffsetDateTime getLastModified() {
        return lastModified;
    }

    public OffsetDateTime getLastActive() {
        return lastActive;
    }

    public OffsetDateTime getCreated() {
        return created;
    }

    public String getClientUrl() {
        return clientUrl;
    }

    public String getCompanyName() {
        return companyName;
    }
}

'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/model/UsersResponse.java"; Content = @'
package com.intuit.tsheets.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

/**
 * Wrapper for /users endpoint responses.
 */
public class UsersResponse {

    @JsonProperty("users")
    private List<User> users;

    public List<User> getUsers() {
        return users;
    }

    public void setUsers(List<User> users) {
        this.users = users;
    }
}
'
@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/model/Timesheet.java"; Content = @'
package com.intuit.tsheets.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Timesheet {

    private long id;

    @JsonProperty("user_id")
    private long userId;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getUserId() {
        return userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }
}

'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/model/TimesheetsResponse.java"; Content = @'
package com.intuit.tsheets.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

public class TimesheetsResponse {

    @JsonProperty("timesheets")
    private List<Timesheet> timesheets;

    public List<Timesheet> getTimesheets() {
        return timesheets;
    }

    public void setTimesheets(List<Timesheet> timesheets) {
        this.timesheets = timesheets;
    }
}

'@ }

$files += [pscustomobject]@{ Path = "tsheets-core/src/main/java/com/intuit/tsheets/api/DataService.java"; Content = @'
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
'@ }

$files += [pscustomobject]@{ Path = ".github/workflows/build.yml"; Content = @'
name: Build

on:
  push:
    branches: ["*"]
  pull_request:
    branches: ["*"]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Set up JDK 11
        uses: actions/setup-java@v3
        with:
          distribution: 'temurin'
          java-version: '11'
      - name: Build with Maven
        run: mvn -q -e install
'@ }

$files += [pscustomobject]@{ Path = "tsheets-examples/pom.xml"; Content = @'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>com.intuit.tsheets</groupId>
        <artifactId>tsheets-parent</artifactId>
        <version>0.0.1-SNAPSHOT</version>
    </parent>

    <artifactId>tsheets-examples</artifactId>
    <name>TSheets Examples</name>
    <description>Example application using the TSheets Core module</description>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>com.intuit.tsheets</groupId>
            <artifactId>tsheets-core</artifactId>
            <version>${project.version}</version>
        </dependency>
    </dependencies>

</project>
'@ }

$files += [pscustomobject]@{ Path = "tsheets-examples/src/main/java/com/intuit/tsheets/example/ExampleApplication.java"; Content = @'
package com.intuit.tsheets.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ExampleApplication {
    public static void main(String[] args) {
        SpringApplication.run(ExampleApplication.class, args);
    }
}
'@ }

$files += [pscustomobject]@{ Path = "tsheets-tests/pom.xml"; Content = @'
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <parent>
        <groupId>com.intuit.tsheets</groupId>
        <artifactId>tsheets-parent</artifactId>
        <version>0.0.1-SNAPSHOT</version>
    </parent>

    <artifactId>tsheets-tests</artifactId>
    <name>TSheets Tests</name>
    <description>Test module for TSheets Core</description>

    <dependencies>
        <dependency>
            <groupId>com.intuit.tsheets</groupId>
            <artifactId>tsheets-core</artifactId>
            <version>${project.version}</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <configuration>
                    <useModulePath>false</useModulePath>
                </configuration>
            </plugin>
        </plugins>
    </build>

</project>
'@ }

$files += [pscustomobject]@{ Path = "tsheets-tests/src/test/java/com/intuit/tsheets/SanityTest.java"; Content = @'
package com.intuit.tsheets;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertTrue;

class SanityTest {
    @Test
    void sanity() {
        assertTrue(true);
    }
}
'@ }

foreach ($f in $files) { Write-File -Path $f.Path -Content $f.Content }

Write-Host "All files generated in" (Resolve-Path $Target)
Write-Host "Next: mvn -q -e install"

