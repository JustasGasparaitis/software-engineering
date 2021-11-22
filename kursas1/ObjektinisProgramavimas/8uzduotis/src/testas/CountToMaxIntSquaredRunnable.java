package testas;

import java.io.FileWriter;
import java.io.IOException;

public class CountToMaxIntSquaredRunnable implements Runnable {
    private final int times;
    private final FileWriter fileWriter;
    private final Object lock;

    public CountToMaxIntSquaredRunnable(int times, FileWriter fileWriter, Object lock) {
        this.times = times;
        this.fileWriter = fileWriter;
        this.lock = lock;
    }

    /**
     * Writes how many times it counted to Integer.MAX_VALUE squared and the time taken to do it to a file.
     */
    @Override
    public void run() {
        long startTime = System.nanoTime();
        try {
            synchronized (lock) {
                for (int i = 0; i < times; i++) {
                    for (int j = 0; j < Integer.MAX_VALUE; j++) {
                        for (int k = 0; k < Integer.MAX_VALUE; k++) {
                            // do nothing
                        }
//                        if (j % 10000000 == 0) {
//                            fileWriter.write("Counting...\n");
//                        }
                    }
                }
                long endTime = System.nanoTime();
                fileWriter.write("Counted " + times + " times to 2,147,483,647 squared!\n");
                fileWriter.write("Time taken: " + ((endTime - startTime) / 1000000) + "ms\n");
                fileWriter.write("------------------------------------------------------------\n");
                fileWriter.flush();
                System.out.println("\nCountToMaxIntRunnable Thread successfully completed! (" + ((endTime - startTime) / 1000000) + " ms)");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
