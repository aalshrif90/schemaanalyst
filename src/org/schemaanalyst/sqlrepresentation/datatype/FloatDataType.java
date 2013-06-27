package org.schemaanalyst.sqlrepresentation.datatype;

public class FloatDataType extends DataType {
	
	private static final long serialVersionUID = -1350006344393093990L;

	public void accept(DataTypeVisitor typeVisitor) {
		typeVisitor.visit(this);
	}
	
	public void accept(DataTypeCategoryVisitor categoryVisitor) {
		categoryVisitor.visit(this);
	}		
}