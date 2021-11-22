package com.company;

import java.io.Serializable;

/**
 * Represents a web programmer.
 *
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
public class WebProgrammer extends Programmer implements Serializable {

    /**
     * Creates a web programmer with the specified name.
     *
     * @param workerName The web programmer’s name.
     */
    WebProgrammer(String workerName) {
        super(workerName);
        job = "Web Programmer";
    }

    private Website website;

    /**
     * Creates an website.
     * @return Created website
     */
    public Website createWebsite() {
        return new Website();
    }

    /**
     * Web programmer creates a website.
     */
    @Override
    public void work() {
        website = createWebsite();
    }

    public Website getWebsite() {
        return website;
    }

    public void setWebsite(Website website) {
        this.website = website;
    }


}
