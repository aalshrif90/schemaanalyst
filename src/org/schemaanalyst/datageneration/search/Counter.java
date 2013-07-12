package org.schemaanalyst.datageneration.search;

public class Counter {

    protected String name;
    protected int counter;

    public Counter(String name) {
        this.name = name;
        reset();
    }

    public void reset() {
        counter = 0;
    }

    public void decrement() {
        counter--;
    }

    public void increment() {
        counter++;
    }

    public int getValue() {
        return counter;
    }

    public String toString() {
        return name + ": " + counter;
    }
}
