package com.company;

import java.io.Serializable;

/**
 * Represents a farmer.
 *
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
public class Farmer extends Worker implements Serializable {

    /**
     * Farmer's current time waited.
     */
    private int waitTime = 0;

    /**
     * Crop's growth time.
     */
    private final int growthTime = 90; // crop growth time: 90 days

    /**
     * Farmer's current time waited.
     */
    private boolean cropPlanted = false;

    /**
     * Creates a farmer with the specified name.
     *
     * @param workerName The farmer’s name.
     */
    Farmer(String workerName) {
        super(workerName);
        job = "Farmer";
    }

    /**
     * Farmer plants a crop, waits for it to grow and harvests it.
     *
     */
    @Override
    public void work() {
        plantCrop();
        waitCrop(growthTime);
        harvestCrop();
    }

    /**
     * Farmer plants a crop.
     * @return true, if crop has been planted
     */
    public boolean plantCrop() {
        cropPlanted = true;
        return true;
    }

    /**
     * Farmer harvests a crop.
     * @return
     * 0 - success
     * 1 - failure, hasn't planted a crop yet
     * 2 - failure, crop hasn't grown yet
     */
    public int harvestCrop() {
        if (!cropPlanted) {
            return 1;
        } else if (waitTime < growthTime) {
            return 2;
        } else {
            waitTime = 0;
            cropPlanted = false;
            return 0;
        }
    }

    /**
     * Farmer waits some time for a crop to grow.
     *
     * @param time Time for a crop to grow.
     */
    public void waitCrop(int time) {
        waitTime += time;
    }

    public int getWaitTime() {
        return waitTime;
    }

    public void setWaitTime(int waitTime) {
        this.waitTime = waitTime;
    }

    public boolean isCropPlanted() {
        return cropPlanted;
    }

    public void setCropPlanted(boolean cropPlanted) {
        this.cropPlanted = cropPlanted;
    }

    public int getGrowthTime() {
        return growthTime;
    }
}
