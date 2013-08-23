package org.schemaanalyst.test.datageneration.search;

import java.math.BigDecimal;

import org.junit.Test;
import org.schemaanalyst.datageneration.search.Search;
import org.schemaanalyst.datageneration.search.objective.ObjectiveFunction;
import org.schemaanalyst.datageneration.search.objective.ObjectiveValue;
import org.schemaanalyst.util.Duplicator;

import static org.junit.Assert.*;

public class TestSearchEvaluation {

      class MockObjectiveFunction extends ObjectiveFunction<Double> {

        @Override
        public ObjectiveValue evaluate(Double value) {
            ObjectiveValue objVal = new ObjectiveValue();
            objVal.setValue(value);
            return objVal;
        }
    }

    class MockSearch extends Search<Double> {

        public MockSearch() {
            super(new Duplicator<Double>() {
                @Override
                public Double duplicate(Double value) {
                    return new Double(value.doubleValue());
                }
            });
        }

        @Override
        public void search(Double d) {
        }

        @Override
        public ObjectiveValue evaluate(Double d) {
            return super.evaluate(d);
        }
    }

    @Test
    public void test() {
        MockSearch s = new MockSearch();

        s.setObjectiveFunction(new MockObjectiveFunction());
        s.evaluate(0.6);
        s.evaluate(0.2);
        s.evaluate(0.5);

        assertEquals(3, s.getEvaluationsCounter().getValue());
        assertEquals(new BigDecimal(0.2), s.getBestObjectiveValue().getValue());
    }
}
