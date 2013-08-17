package org.schemaanalyst.mutation.mutator;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.schemaanalyst.mutation.Mutant;
import org.schemaanalyst.mutation.artefactsupplier.ArtefactSupplier;
import org.schemaanalyst.util.Duplicable;
import org.schemaanalyst.util.Pair;

public class ListMutator<A extends Duplicable<A>, E> extends Mutator<A, Pair<List<E>>> {
	
	public ListMutator(ArtefactSupplier<A, Pair<List<E>>> artefactSupplier) {
		super(artefactSupplier);
	}

	@Override
	public Set<Mutant<A>> mutate() {
		Set<Mutant<A>> mutants = new HashSet<>();
		
		Pair<List<E>> nextComponent = artefactSupplier.getNextComponent();
		while (nextComponent != null) {
			
			List<E> elements = nextComponent.getFirst();
			List<E> alternatives = nextComponent.getSecond();
			
			for (E element : elements) {
				mutants.add(makeRemoveElementMutant(element));
			}
			
			for (E alternative : alternatives) {
				mutants.add(makeAddElementMutant(alternative));
			}
			
			for (E element : elements) {
				for (E alternative : alternatives) {
					mutants.add(makeReplaceElementMutant(element, alternative));
				}
			}
			
			nextComponent = artefactSupplier.getNextComponent();
		}
		
		return mutants;
	}
	
	private Mutant<A> makeRemoveElementMutant(E element) {
		A artefactCopy = artefactSupplier.getArtefactCopy();
		
		List<E> copiedElements = artefactSupplier.getComponentCopy().getFirst();
		List<E> mutatedElements = new ArrayList<>();
		
		for (E copiedElement : copiedElements) {
			if (!element.equals(copiedElement)) {
				mutatedElements.add(copiedElement);
			}
		}
		
		artefactSupplier.putComponentBack(new Pair<>(mutatedElements, null));
		return new Mutant<>(artefactCopy, toString(), "Removed " + element);		
	}
	
	private Mutant<A> makeAddElementMutant(E alternative) {
		A artefactCopy = artefactSupplier.getArtefactCopy();
		
		List<E> copiedElements = artefactSupplier.getComponentCopy().getFirst();
		List<E> copiedAlternatives = artefactSupplier.getComponentCopy().getSecond();
		
		List<E> mutatedElements = new ArrayList<>();			
		mutatedElements.addAll(copiedElements);
		for (E copiedAlternative : copiedAlternatives) {
			if (alternative.equals(copiedAlternative)) {
				mutatedElements.add(copiedAlternative);
			}
		}		
		
		artefactSupplier.putComponentBack(new Pair<>(mutatedElements, null));
		return new Mutant<>(artefactCopy, toString(), "Added " + alternative);
	}
	
	private Mutant<A> makeReplaceElementMutant(E element, E alternative) {
		A artefactCopy = artefactSupplier.getArtefactCopy();

		List<E> copiedElements = artefactSupplier.getComponentCopy().getFirst();
		List<E> copiedAlternatives = artefactSupplier.getComponentCopy().getSecond();
		List<E> mutatedElements = new ArrayList<>();

		for (E copiedElement : copiedElements) {
			if (!element.equals(copiedElement)) {
				mutatedElements.add(copiedElement);
			}
			for (E copiedAlternative : copiedAlternatives) {
				if (alternative.equals(copiedAlternative)) {
					mutatedElements.add(copiedAlternative);
				}
			}	
		}

		artefactSupplier.putComponentBack(new Pair<>(mutatedElements, null));
		return new Mutant<>(artefactCopy, toString(), "Replaced " + element + " with " + alternative);
	}
}