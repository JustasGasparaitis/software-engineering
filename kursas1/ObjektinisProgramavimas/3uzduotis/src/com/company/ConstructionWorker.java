package com.company;

/**
 * Represents a construction worker.
 *
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
public class ConstructionWorker extends Worker {

    /**
     * Construction worker's current brick count.
     */
    private int brickCount = 0;

    /**
     * Creates a construction worker with the specified name.
     *
     * @param workerName The construction worker’s name.
     */
    ConstructionWorker(String workerName) {
        super(workerName);
        job = "Construction Worker";
    }

    @Override
    public void work() {
        giveBricks(8000);
        buildHouse();
    }

    /**
     * Construction worker builds a house.
     * @return
     * 0 - success
     * 1 - failure, not enough bricks
     */
    public int buildHouse() {
        if (brickCount >= 8000) {
            brickCount -= 8000;
            return 0;
        }
        else {
            return 1;
        }
    }

    /**
     * Construction worker takes bricks.
     *
     * @param bricks Amount of bricks taken.
     */
    public void giveBricks(int bricks) {
        brickCount += bricks;
    }
}
