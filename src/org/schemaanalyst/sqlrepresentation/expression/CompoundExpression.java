package org.schemaanalyst.sqlrepresentation.expression;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public abstract class CompoundExpression extends ExpressionTree {

    protected List<Expression> subexpressions;

    public CompoundExpression(List<Expression> subexpressions) {
        this.subexpressions = new ArrayList<>(subexpressions);
    }

    public CompoundExpression(Expression... subexpressions) {
        this.subexpressions = Arrays.asList(subexpressions);
    }

    @Override
    public List<Expression> getSubexpressions() {
        return Collections.unmodifiableList(subexpressions);
    }

    @Override
    public int getNumSubexpressions() {
        return subexpressions.size();
    }

    @Override
    public Expression getSubexpression(int index) {
        if (index < getNumSubexpressions()) {
            return subexpressions.get(index);
        }
        throw new NonExistentSubexpressionException(this, index);
    }

    @Override
    public abstract void accept(ExpressionVisitor visitor);
}
