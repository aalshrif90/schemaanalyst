package org.schemaanalyst.datageneration.search.termination;

import org.schemaanalyst.logic.RelationalOperator;
import org.schemaanalyst.datageneration.search.Counter;
import org.schemaanalyst.datageneration.search.SearchException;

public class CounterTerminationCriterion implements TerminationCriterion {

    protected Counter counter;
    protected int max;
    protected RelationalOperator op;

    public CounterTerminationCriterion(Counter counter, int max) {
        this(counter, RelationalOperator.GREATER_OR_EQUALS, max);
    }

    public CounterTerminationCriterion(Counter counter, String op, int max) {
        this(counter, RelationalOperator.getRelationalOperator(op), max);
    }

    public CounterTerminationCriterion(Counter counter, RelationalOperator op, int max) {
        this.counter = counter;
        this.max = max;
        this.op = op;
    }

    public boolean satisfied() {
        int value = counter.getValue();
        if (op == RelationalOperator.EQUALS) {
            return value == max;
        } else if (op == RelationalOperator.NOT_EQUALS) {
            return value != max;
        } else if (op == RelationalOperator.GREATER) {
            return value > max;
        } else if (op == RelationalOperator.GREATER_OR_EQUALS) {
            return value >= max;
        } else if (op == RelationalOperator.LESS) {
            return value < max;
        } else if (op == RelationalOperator.LESS_OR_EQUALS) {
            return value <= max;
        } else {
            throw new SearchException("Unknown relational operator in counter termination criterion " + op);
        }
    }
}
