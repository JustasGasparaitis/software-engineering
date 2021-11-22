package com.company;

/**
 * Represents a programmer.
 *
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
abstract public class Programmer extends Worker {

    /**
     * Creates a programmer with the specified name.
     *
     * @param workerName The programmer’s name.
     */
    Programmer(String workerName) {
        super(workerName);
        job = "Programmer";
    }
}
