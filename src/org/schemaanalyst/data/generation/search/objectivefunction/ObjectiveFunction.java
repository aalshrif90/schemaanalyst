package org.schemaanalyst.data.generation.search.objectivefunction;

/**
 * Created by phil on 14/03/2014.
 */
public abstract class ObjectiveFunction<T> {

    public abstract ObjectiveValue evaluate(T candidateSolution);
}
