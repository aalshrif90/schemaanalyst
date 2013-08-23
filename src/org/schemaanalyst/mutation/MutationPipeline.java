package org.schemaanalyst.mutation;

import java.util.List;

public abstract class MutationPipeline<A> {
	
	public abstract List<Mutant<A>> mutate();	
}
