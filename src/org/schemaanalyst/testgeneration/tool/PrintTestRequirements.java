package org.schemaanalyst.testgeneration.tool;

import org.schemaanalyst.sqlrepresentation.Schema;
import org.schemaanalyst.testgeneration.coveragecriterion.CoverageCriterionFactory;
import org.schemaanalyst.testgeneration.coveragecriterion.TestRequirement;
import org.schemaanalyst.testgeneration.coveragecriterion.TestRequirements;
import org.schemaanalyst.util.runner.Parameter;
import org.schemaanalyst.util.runner.RequiredParameters;
import org.schemaanalyst.util.runner.Runner;

/**
 * Created by phil on 24/02/2014.
 */
@RequiredParameters("schema criterion")
public class PrintTestRequirements extends Runner {

    @Parameter("The name of the schema to use.")
    protected String schema;

    @Parameter("The coverage criterion to use to generate data.")
    protected String criterion;

    @Override
    protected void task() {
        TestRequirements testRequirements =
                CoverageCriterionFactory.instantiateSchemaCriterion(criterion, instantiateSchema())
                        .generateRequirements();

        int total = testRequirements.size();

        testRequirements.reduce();

        int totalMinusDuplicates = testRequirements.size();

        for (TestRequirement testRequirement : testRequirements.getTestRequirements()) {
            boolean infeasible = testRequirement.getPredicate().reduce().isTriviallyInfeasible();
            System.out.println(testRequirement.toString(true) + "\n" + (infeasible ? "(Infeasible)\n" : "") );
        }

        testRequirements.filterInfeasible();

        int totalMinusDuplicatesMinusInfeasible = testRequirements.size();

        System.out.println("Total number of test requirements: " + total);
        System.out.println("Minus duplicates:                  " + totalMinusDuplicates);
        System.out.println("Minus duplicates and infeasible:   " + totalMinusDuplicatesMinusInfeasible);
    }

    private Schema instantiateSchema() {
        try {
            return (Schema) Class.forName(schema).newInstance();
        } catch (ClassNotFoundException | IllegalAccessException | InstantiationException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void validateParameters() {
        // no params to validate
    }

    public static void main(String... args) {
        new PrintTestRequirements().run(args);
    }

}
