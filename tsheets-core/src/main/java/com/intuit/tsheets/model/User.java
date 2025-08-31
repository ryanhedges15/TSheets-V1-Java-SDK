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
