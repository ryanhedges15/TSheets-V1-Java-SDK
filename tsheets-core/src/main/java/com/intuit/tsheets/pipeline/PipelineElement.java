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
