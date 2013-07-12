package org.schemaanalyst.data;

import org.schemaanalyst.sqlrepresentation.datatype.BigIntDataType;
import org.schemaanalyst.sqlrepresentation.datatype.BooleanDataType;
import org.schemaanalyst.sqlrepresentation.datatype.CharDataType;
import org.schemaanalyst.sqlrepresentation.datatype.DataType;
import org.schemaanalyst.sqlrepresentation.datatype.DataTypeVisitor;
import org.schemaanalyst.sqlrepresentation.datatype.DateDataType;
import org.schemaanalyst.sqlrepresentation.datatype.DateTimeDataType;
import org.schemaanalyst.sqlrepresentation.datatype.DecimalDataType;
import org.schemaanalyst.sqlrepresentation.datatype.DoubleDataType;
import org.schemaanalyst.sqlrepresentation.datatype.FloatDataType;
import org.schemaanalyst.sqlrepresentation.datatype.IntDataType;
import org.schemaanalyst.sqlrepresentation.datatype.MediumIntDataType;
import org.schemaanalyst.sqlrepresentation.datatype.NumericDataType;
import org.schemaanalyst.sqlrepresentation.datatype.RealDataType;
import org.schemaanalyst.sqlrepresentation.datatype.SmallIntDataType;
import org.schemaanalyst.sqlrepresentation.datatype.TextDataType;
import org.schemaanalyst.sqlrepresentation.datatype.TimeDataType;
import org.schemaanalyst.sqlrepresentation.datatype.TimestampDataType;
import org.schemaanalyst.sqlrepresentation.datatype.TinyIntDataType;
import org.schemaanalyst.sqlrepresentation.datatype.VarCharDataType;

public class ValueFactory {

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

    public Value createTextDataTypeValue(TextDataType type) {
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