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

