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
