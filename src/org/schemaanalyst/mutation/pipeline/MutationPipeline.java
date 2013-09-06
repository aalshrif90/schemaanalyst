package org.schemaanalyst.mutation.pipeline;

import java.util.ArrayList;
import java.util.List;

import org.schemaanalyst.mutation.Mutant;
import org.schemaanalyst.mutation.MutantProducer;

/**
 * A {@link MutationPipeline} is something capable of using
 * a series of mutation operators to produce a series of mutants,
 * and then remove mutants by invoking
 * {@link org.schemaanalyst.mutation.pipeline.MutantRemover}s.
 * 
 * @author Phil McMinn
 *
 * @param <A> The class of the artefact to be mutated by the pipeline.
 */
public class MutationPipeline<A> implements MutantProducer<A> {

	private List<MutantProducer<A>> producers;
	private List<MutantRemover<A>> remover;
	
	public MutationPipeline() {
		this.producers = new ArrayList<>();
		this.remover = new ArrayList<>();
	}
	
	public void addProducer(MutantProducer<A> producer) {
		producers.add(producer);
	}
	
	public void addRemover(MutantRemover<A> reducer) {
		remover.add(reducer);
	}
		
	@Override
	public List<Mutant<A>> mutate() {
		List<Mutant<A>> mutants = new ArrayList<>();
		for (MutantProducer<A> producer : producers) {
			mutants.addAll(producer.mutate());
		}		
		for (MutantRemover<A> reducer : remover) {
			mutants = reducer.removeMutants(mutants);
		}				
		return mutants;
	}
}
