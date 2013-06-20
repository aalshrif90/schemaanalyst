package org.schemaanalyst.data;

import org.schemaanalyst.representation.datatype.BigIntDataType;
import org.schemaanalyst.representation.datatype.BooleanDataType;
import org.schemaanalyst.representation.datatype.CharDataType;
import org.schemaanalyst.representation.datatype.DataType;
import org.schemaanalyst.representation.datatype.DataTypeVisitor;
import org.schemaanalyst.representation.datatype.DateDataType;
import org.schemaanalyst.representation.datatype.DateTimeDataType;
import org.schemaanalyst.representation.datatype.DecimalDataType;
import org.schemaanalyst.representation.datatype.DoubleDataType;
import org.schemaanalyst.representation.datatype.FloatDataType;
import org.schemaanalyst.representation.datatype.IntDataType;
import org.schemaanalyst.representation.datatype.MediumIntDataType;
import org.schemaanalyst.representation.datatype.NumericDataType;
import org.schemaanalyst.representation.datatype.RealDataType;
import org.schemaanalyst.representation.datatype.SmallIntDataType;
import org.schemaanalyst.representation.datatype.TextDataType;
import org.schemaanalyst.representation.datatype.TimeDataType;
import org.schemaanalyst.representation.datatype.TimestampDataType;
import org.schemaanalyst.representation.datatype.TinyIntDataType;
import org.schemaanalyst.representation.datatype.VarCharDataType;

public class ValueFactory  {
		
	public Value createValue(DataType type) {

		class ValueFactoryVisitor implements DataTypeVisitor {
 
			Value value;
			
			public Value createValue(DataType type) {
				value = null;
				type.accept(this);
				return value;
			}			
			
			public void visit(BigIntDataType type) {
				value = createBigIntDataTypeValue(type);
			}
 
			public void visit(BooleanDataType type) {
				value = createBooleanDataTypeValue(type);
			}
 
			public void visit(CharDataType type) {
				value = createCharDataTypeValue(type);
			}
 
			public void visit(DateDataType type) {
				value = createDateDataTypeValue(type);
			}
 
			public void visit(DateTimeDataType type) {
				value = createDateTimeDataTypeValue(type);
			}
 
			public void visit(DecimalDataType type) {
				value = createDecimalDataTypeValue(type);
			}
 
			public void visit(DoubleDataType type) {
				value = createDoubleDataTypeValue(type);
			}
 
			public void visit(FloatDataType type) {
				value = createFloatDataTypeValue(type);
			}
 
			public void visit(IntDataType type) {
				value = createIntDataTypeValue(type);
			}
 
			public void visit(MediumIntDataType type) {
				value = createMediumIntDataTypeValue(type);
			}
 
			public void visit(NumericDataType type) {
				value = createNumericDataTypeValue(type);
			}
 
			public void visit(RealDataType type) {
				value = createRealDataTypeValue(type);
			}
 
			public void visit(SmallIntDataType type) {
				value = createSmallIntDataTypeValue(type);
			}
 
			public void visit(TextDataType type) {
				value = createTextDataTypeValue(type);
			}
 
			public void visit(TimeDataType type) {
				value = createTimeDataTypeValue(type);
			}
 
			public void visit(TimestampDataType type) {
				value = createTimestampDataTypeValue(type);
			}
 
			public void visit(TinyIntDataType type) {
				value = createTinyIntDataTypeValue(type);
			}
 
			public void visit(VarCharDataType type) {
				value = createVarCharDataTypeValue(type);
			}
		}
	
		return (new ValueFactoryVisitor()).createValue(type);
	}	
	
	public Value createBigIntDataTypeValue(BigIntDataType type) {
		if (type.isSigned()) {
			return new NumericValue("-9223372036854775808", "9223372036854775807");
		} else {
			return new NumericValue("0", "18446744073709551615"); 
		}
	}
	
	public Value createBooleanDataTypeValue(BooleanDataType type) {
		return new BooleanValue();
	}

	public Value createCharDataTypeValue(CharDataType type) {
		return new StringValue(type.getLength());
	}	
	
	public Value createDateDataTypeValue(DateDataType type) {
		return new DateValue();
	}

	public Value createDateTimeDataTypeValue(DateTimeDataType type) {
		return new DateTimeValue();
	}
	
	public Value createDecimalDataTypeValue(DecimalDataType type) {
		return new NumericValue();
		// TODO: set ranges
	}
	
	public Value createDoubleDataTypeValue(DoubleDataType type) {
		return new NumericValue();
		// TODO: set ranges
	}
	
	public Value createFloatDataTypeValue(FloatDataType type) {
		return new NumericValue();
		// TODO: set ranges
	}	
	
	public Value createIntDataTypeValue(IntDataType type) {
		if (type.isSigned()) {
			return new NumericValue("-2147483648", "2147483647");
		} else {
			return new NumericValue("0", "4294967295");
		}
	}
	
	public Value createMediumIntDataTypeValue(MediumIntDataType type) {
		if (type.isSigned()) {
			return new NumericValue(-8388608, 8388607);
		} else {
			return new NumericValue(0, 16777215);
		}
	}		
	
	public Value createNumericDataTypeValue(NumericDataType type) {
		return new NumericValue();
		// TODO: set ranges
	}	
	
	public Value createRealDataTypeValue(RealDataType type) {
		return new NumericValue();
		// TODO: set ranges
	}	
	
	public Value createSmallIntDataTypeValue(SmallIntDataType type) {
		if (type.isSigned()) {
			return new NumericValue(-32768, 32767);
		} else {
			return new NumericValue(0, 65535);
		}
	}
	
	public Value createTextDataTypeValue(TextDataType type)  {
		return new StringValue();
	}
	
	public Value createTimeDataTypeValue(TimeDataType type) {
		return new TimeValue();
	}
	
	public Value createTimestampDataTypeValue(TimestampDataType type) {
		return new TimestampValue();
	}
	
	public Value createTinyIntDataTypeValue(TinyIntDataType type) {
		if (type.isSigned()) {
			return new NumericValue(-128, 127);
		} else {
			return new NumericValue(0, 255);
		}
	}
	
	public Value createVarCharDataTypeValue(VarCharDataType type) {
		return new StringValue(type.getLength());
	}	
}