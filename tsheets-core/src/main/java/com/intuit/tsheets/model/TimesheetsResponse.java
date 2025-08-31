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

