package org.schemaanalyst.sqlrepresentation.expression;

import java.util.List;

import org.schemaanalyst.sqlrepresentation.Column;
import org.schemaanalyst.sqlrepresentation.Table;

public interface Expression {

    public static class Duplicator implements org.schemaanalyst.util.Duplicator<Expression> {
        @Override
        public Expression duplicate(Expression expression) {
            return expression.duplicate();
        }
    }
    
    public Expression getSubexpression(ExpressionPath expressionPath);

    public Expression getSubexpression(int index);

    public void setSubexpression(int index, Expression subexpression);
    
    public void setSubexpressions(List<Expression> subexpressions);    
    
    public int getNumSubexpressions();

    public List<Expression> getSubexpressions();

    public void accept(ExpressionVisitor visitor);
    
    public List<Column> getColumnsInvolved();
    
    public Expression duplicate();
    
    public void remap(Table table);
}
