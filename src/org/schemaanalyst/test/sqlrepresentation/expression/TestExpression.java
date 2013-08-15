package org.schemaanalyst.test.sqlrepresentation.expression;

import org.junit.Test;
import org.schemaanalyst.data.NumericValue;
import org.schemaanalyst.logic.RelationalOperator;
import org.schemaanalyst.sqlrepresentation.Column;
import org.schemaanalyst.sqlrepresentation.SQLRepresentationException;
import org.schemaanalyst.sqlrepresentation.Table;
import org.schemaanalyst.sqlrepresentation.datatype.IntDataType;
import org.schemaanalyst.sqlrepresentation.datatype.RealDataType;
import org.schemaanalyst.sqlrepresentation.expression.AndExpression;
import org.schemaanalyst.sqlrepresentation.expression.ColumnExpression;
import org.schemaanalyst.sqlrepresentation.expression.ConstantExpression;
import org.schemaanalyst.sqlrepresentation.expression.RelationalExpression;

import static org.junit.Assert.*;

public class TestExpression {
    
    Table table1 = new Table("table");
    Column table1Column1 = table1.createColumn("column1", new IntDataType());
    Column table1Column2 = table1.createColumn("column2", new IntDataType());
    Column table1Column3 = table1.createColumn("column3", new IntDataType());
    Column table1Column4 = table1.createColumn("column4", new IntDataType());
    
    Table table2 = new Table("table");
    Column table2Column1 = table2.createColumn("column1", new IntDataType());
    Column table2Column2 = table2.createColumn("column2", new IntDataType());
    Column table2Column3 = table2.createColumn("column3", new RealDataType());
    
    Table table3 = new Table("__table__");
    Column table3Column1 = table3.createColumn("column1", new IntDataType());    
    Column table3Column2 = table3.createColumn("column2", new IntDataType());
    
    @Test
    public void testColumnsInvolvedOneColumn() {
        RelationalExpression expression = 
                new RelationalExpression(
                        new ColumnExpression(table1, table1Column1),
                        RelationalOperator.EQUALS, 
                        new ConstantExpression(new NumericValue(1)));
     
        assertEquals(expression.getColumnsInvolved().size(), 1);
        assertEquals(expression.getColumnsInvolved().get(0), table1Column1);
    }
    
    @Test
    public void testColumnsInvolvedOneColumnRepeated() {
        RelationalExpression expression = 
                new RelationalExpression(
                        new ColumnExpression(table1, table1Column1),
                        RelationalOperator.EQUALS, 
                        new ColumnExpression(table1, table1Column1));
        
        assertEquals(expression.getColumnsInvolved().size(), 1);
        assertEquals(expression.getColumnsInvolved().get(0), table1Column1);
    } 
    
    @Test
    public void testColumnsInvolvedMultipleExpressions() {
        RelationalExpression relationalExpression1 = 
                new RelationalExpression(
                        new ColumnExpression(table1, table1Column1),
                        RelationalOperator.EQUALS, 
                        new ColumnExpression(table1, table1Column2));
        
        RelationalExpression relationalExpression2 = 
                new RelationalExpression(
                        new ColumnExpression(table1, table1Column3),
                        RelationalOperator.EQUALS, 
                        new ColumnExpression(table1, table1Column4));
        
        AndExpression andExpression = 
                new AndExpression(relationalExpression1, relationalExpression2);
        
        assertEquals(andExpression.getColumnsInvolved().size(), 4);
        assertTrue(andExpression.getColumnsInvolved().contains(table1Column1));
        assertTrue(andExpression.getColumnsInvolved().contains(table1Column2));
        assertTrue(andExpression.getColumnsInvolved().contains(table1Column3));
        assertTrue(andExpression.getColumnsInvolved().contains(table1Column4));
    }    
    
    @Test
    public void testColumnsInvolvedMultipleExpressionsColumnsRepeated() {
        RelationalExpression relationalExpression1 = 
                new RelationalExpression(
                        new ColumnExpression(table1, table1Column1),
                        RelationalOperator.EQUALS, 
                        new ColumnExpression(table1, table1Column2));
        
        RelationalExpression relationalExpression2 = 
                new RelationalExpression(
                        new ColumnExpression(table1, table1Column1),
                        RelationalOperator.EQUALS, 
                        new ColumnExpression(table1, table1Column4));
        
        AndExpression andExpression = 
                new AndExpression(relationalExpression1, relationalExpression2);
        
        assertEquals(andExpression.getColumnsInvolved().size(), 3);
        assertTrue(andExpression.getColumnsInvolved().contains(table1Column1));
        assertTrue(andExpression.getColumnsInvolved().contains(table1Column2));
        assertTrue(andExpression.getColumnsInvolved().contains(table1Column4));
    }      
    
    @Test
    public void testRemap() {
        ColumnExpression exp1 = new ColumnExpression(table1, table1Column1);
        ColumnExpression exp2 = new ColumnExpression(table1, table1Column2);
        
        RelationalExpression relationalExpression = 
                new RelationalExpression(
                        exp1, RelationalOperator.EQUALS, exp2);
        
        relationalExpression.remap(table2);
        
        assertSame(
                "The table of exp1 should be remapped to table2",
                exp1.getTable(), table2);
        
        assertSame(
                "The table of exp2 should be remapped to table2",
                exp2.getTable(), table2);
        
        assertSame(
                "The column of exp1 should be remapped to table2Column1",
                exp1.getColumn(), table2Column1);
        
        assertSame(
                "The column of exp2 should be remapped to table2Column2",
                exp2.getColumn(), table2Column2);        
    }
    
    @Test
    public void testPartialRemap() {
        ColumnExpression exp1 = new ColumnExpression(table1, table1Column1);
        ColumnExpression exp2 = new ColumnExpression(table3, table3Column2);
        
        RelationalExpression relationalExpression = 
                new RelationalExpression(
                        exp1, RelationalOperator.EQUALS, exp2);
        
        // table1 has the same name as table2 but not table3
        relationalExpression.remap(table2);
        
        assertSame(
                "The table of exp1 should be remapped to table2",
                exp1.getTable(), table2);
        
        assertNotSame(
                "The table of exp2 should not be remapped to table2",
                exp2.getTable(), table2);
        
        assertSame(
                "The column of exp1 should be remapped to table2Column1",
                exp1.getColumn(), table2Column1);
        
        assertNotSame(
                "The column of exp2 should not be remapped to table2Column2",
                exp2.getColumn(), table2Column2);        
    }    
    
    // table2 has no column named "column4"
    @Test(expected=SQLRepresentationException.class)
    public void testRemapFailNoColumn() {
        ColumnExpression exp1 = new ColumnExpression(table1, table1Column1);
        ColumnExpression exp2 = new ColumnExpression(table1, table1Column4);
        
        RelationalExpression relationalExpression = 
                new RelationalExpression(
                        exp1, RelationalOperator.EQUALS, exp2);
        
        relationalExpression.remap(table2);                
    } 
    
    // table1Column3 has a different data type to table2Column3
    @Test(expected=SQLRepresentationException.class)
    public void testRemapFailMismatchedColumnDataType() {
        ColumnExpression exp1 = new ColumnExpression(table1, table1Column1);
        ColumnExpression exp2 = new ColumnExpression(table1, table1Column3);
        
        RelationalExpression relationalExpression = 
                new RelationalExpression(
                        exp1, RelationalOperator.EQUALS, exp2);
        
        relationalExpression.remap(table2);                
    }     
}
