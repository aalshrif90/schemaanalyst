package originalcasestudy;

import org.schemaanalyst.sqlrepresentation.Column;
import org.schemaanalyst.sqlrepresentation.Schema;
import org.schemaanalyst.sqlrepresentation.Table;
import org.schemaanalyst.sqlrepresentation.datatype.IntDataType;

public class NistDML183IntsNotNulls extends Schema {

    static final long serialVersionUID = -8495866472648525553L;

    public NistDML183IntsNotNulls() {
        super("NistDML183IntsNotNulls");

        /*
		  
         CREATE TABLE T 
         (
         A CHAR, B CHAR, C CHAR,
         CONSTRAINT UniqueOnColsAandB UNIQUE (A, B)
         );

         NOTE: Add NOT NULLs for everyone.
		  
         NOTE: Uses INTs instead of CHAR for everyone.

         NOTE: for Postgres, a CHAR is the same as CHAR(1)!

         */

        Table tTable = createTable("T");

        Column a = tTable.addColumn("A", new IntDataType());
        Column b = tTable.addColumn("B", new IntDataType());
        Column c = tTable.addColumn("C", new IntDataType());

        a.setNotNull();
        b.setNotNull();
        c.setNotNull();

        tTable.addUniqueConstraint(a, b);

        /*

         CREATE TABLE S 
         (
         X CHAR, Y CHAR, Z CHAR,
         CONSTRAINT RefToColsAandB FOREIGN KEY (X, Y)
         REFERENCES T (A, B)
         );

         Change everthing to INTs.

         Add NOT NULLs for everyone.

         */

        Table sTable = createTable("S");

        Column x = sTable.addColumn("X", new IntDataType());
        Column y = sTable.addColumn("Y", new IntDataType());
        Column z = sTable.addColumn("Z", new IntDataType());

        x.setNotNull();
        y.setNotNull();
        z.setNotNull();
        sTable.addForeignKeyConstraint(x, y, tTable, a, b);
    }
}
