package com.company;

import java.util.Random;

/**
 * Class representing a website.
 *
 */
public class Website implements Application {
    private final Random random = new Random();
    private int bugCount = random.nextInt(5);
    @Override
    public int compile() {
        return bugCount;
    }

    @Override
    public boolean fixBug() {
        if (bugCount == 0) return false;
        if (random.nextInt(3) < 2) {
            bugCount--;
            return true;
        }
        else {
            return false;
        }
    }
}
