package com.company;

import java.io.Serializable;
import java.util.Random;

/**
 * Class representing an Android app.
 *
 */

public class AndroidApp implements Application, Serializable {
    private final Random random = new Random();
    private int bugCount = random.nextInt(10);

    /**
     * Compiles the app.
     * @return Bug count
     */
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
