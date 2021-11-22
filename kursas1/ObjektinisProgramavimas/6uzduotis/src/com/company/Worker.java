package com.company;

import java.io.Serializable;
import java.util.Objects;

/**
 * Represents a worker class hierarchy.
 *
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
abstract public class Worker implements Serializable {
    /**
     * Worker's job title.
     */
    public String job = "Worker";

    /**
     * Worker's name.
     */
    public String name;

    /**
     * Creates a worker with the specified name.
     *
     * @param workerName The worker’s name.
     */
    public Worker(String workerName) {
        name = workerName;
    }


    public abstract void work();

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Worker worker = (Worker) o;
        return Objects.equals(name, worker.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }
}
