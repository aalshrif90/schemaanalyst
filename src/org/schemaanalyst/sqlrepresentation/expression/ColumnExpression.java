package org.schemaanalyst.sqlrepresentation.expression;

import java.util.ArrayList;
import java.util.List;

import org.schemaanalyst.sqlrepresentation.Column;

public class ColumnExpression extends ExpressionLeaf {

    protected Column column;

    public ColumnExpression(Column column) {
        this.column = column;
    }

    public Column getColumn() {
        return column;
    }

    @Override
    public List<Column> getColumnsInvolved() {
        List<Column> columns = new ArrayList<>();
        columns.add(column);
        return columns;
    }    
    
    @Override
    public void accept(ExpressionVisitor visitor) {
        visitor.visit(this);
    }
    
    public String toString() {
        return column.toString();
    }
}
