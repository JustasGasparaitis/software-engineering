package com.company;

/** Represents a worker class hierarchy.
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
class Worker {
    /** Worker's job title.
     */
    String job = "Worker";

    /** Worker's name.
     */
    String name;

    /** Creates a worker with the specified name.
     * @param workerName The worker’s name.
     */
    Worker(String workerName) {
        name = workerName;
    }

    /** Worker greets the user by introducing themselves.
     */
    void greet() {
        System.out.println("Hello, my name is " + name + " and my job is " + job + ".");
    }
}

/** Represents a programmer.
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
class Programmer extends Worker {

    /** Identifier for computer power status.
     */
    private boolean hasComputerOn = false;

    /** Identifier for programmer's coding status.
     */
    boolean hasCoded = false;

    /** Creates a programmer with the specified name.
     * @param workerName The programmer’s name.
     */
    Programmer(String workerName) {
        super(workerName);
        job = "Programmer";
    }

    /** Programmer turns on their computer.
     */
    void turnOnComputer() {
        hasComputerOn = true;
        System.out.println(name + " just turned on their computer.");
    }

    /** Programmer codes.
     */
    void code() {
        if (hasComputerOn) {
            hasCoded = true;
            System.out.println(name + " is coding.");
        }
        else {
            System.out.println(name + " can't code - hasn't turned on their computer!");
        }
    }
}

/** Represents a web programmer.
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
class WebProgrammer extends Programmer {

    /** Creates a web programmer with the specified name.
     * @param workerName The web programmer’s name.
     */
    WebProgrammer(String workerName) {
        super(workerName);
        job = "Web Programmer";
    }

    /** Web programmer creates Facebook.
     */
    void createFacebook() {
        if (hasCoded) {
            System.out.println(name + " just created Facebook.");
        }
        else {
            System.out.println(name + " can't create Facebook - hasn't coded anything yet.");
        }
    }
}

/** Represents an Android programmer.
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
class AndroidProgrammer extends Programmer {

    /** Creates an Android programmer with the specified name.
     * @param workerName The Android programmer’s name.
     */
    AndroidProgrammer(String workerName) {
        super(workerName);
        job = "Android Programmer";
    }

    /** Android programmer creates Bolt.
     */
    void createBolt() {
        if (hasCoded) {
            System.out.println(name + " just created Bolt.");
        }
        else {
            System.out.println(name + " can't create Bolt - hasn't coded anything yet.");
        }
    }
}

/** Represents a game programmer.
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
class GameProgrammer extends Programmer {

    /** Creates a game programmer with the specified name.
     * @param workerName The game programmer’s name.
     */
    GameProgrammer(String workerName) {
        super(workerName);
        job = "Game Programmer";
    }

    /** Game programmer creates Counter-Strike.
     */
    void createCounterStrike() {
        if (hasCoded) {
            System.out.println(name + " just created Counter-Strike.");
        }
        else {
            System.out.println(name + " can't create Counter-Strike - hasn't coded anything yet.");
        }
    }
}

/** Represents a construction worker.
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
class ConstructionWorker extends Worker {

    /** Construction worker's current brick count.
     */
    private int brickCount = 0;

    /** Creates a construction worker with the specified name.
     * @param workerName The construction worker’s name.
     */
    ConstructionWorker(String workerName) {
        super(workerName);
        job = "Construction Worker";
    }

    /** Construction worker builds a house.
     */
    void buildHouse() {
        if (brickCount >= 8000) {
            brickCount -= 8000;
            System.out.println(name + " just built a house.");
        }
        else {
            if (brickCount == 7999) {
                System.out.println(name + " can't build a house - needs " + (8000 - brickCount) + " more brick.");
            }
            else {
                System.out.println(name + " can't build a house - needs " + (8000 - brickCount) + " more bricks.");
            }
        }
    }

    /** Construction worker takes bricks.
     * @param bricks Amount of bricks taken.
     */
    void takeBricks(int bricks) {
        brickCount += bricks;
        if (bricks == 1) {
            System.out.println(name + " just took " + bricks + " brick.");
        }
        else {
            System.out.println(name + " just took " + bricks + " bricks.");
        }
    }
}

/** Represents a farmer.
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
class Farmer extends Worker {

    /** Farmer's current time waited.
     */
    private int waitTime = 0;

    /** Crop's growth time.
     */
    private final int growthTime = 90; // crop growth time: 90 days

    /** Farmer's current time waited.
     */
    private boolean cropPlanted = false;

    /** Creates a farmer with the specified name.
     * @param workerName The farmer’s name.
     */
    Farmer(String workerName) {
        super(workerName);
        job = "Farmer";
    }

    /** Farmer plants a crop.
     */
    void plantCrop() {
        cropPlanted = true;
        System.out.println(name + " just planted a crop.");
    }

    /** Farmer harvests a crop.
     */
    void harvestCrop() {
        if (!cropPlanted) {
            System.out.println(name + " can't harvest their crop - hasn't planted a crop yet.");
        }
        else if (waitTime < growthTime) {
            System.out.println(name + " can't harvest their crop - crop hasn't grown yet.");
        }
        else {
            waitTime = 0;
            cropPlanted = false;
            System.out.println(name + " just harvested a crop.");
        }
    }

    /** Farmer waits some time for a crop to grow.
     * @param time Time for a crop to grow.
     */
    void waitCrop(int time) {
        waitTime += time;
        System.out.println(name + " waited for " + time + " days.");
    }
}

/** Main class.
 */
public class Main {

    /** Main method.
     */
    public static void main(String[] args) {

        // Web programmer example.
        WebProgrammer webProgrammer = new WebProgrammer("Jurgis");
        webProgrammer.greet();
        webProgrammer.createFacebook();
        webProgrammer.code();
        webProgrammer.turnOnComputer();
        webProgrammer.code();
        webProgrammer.createFacebook();

        // Android programmer example.
        AndroidProgrammer androidProgrammer = new AndroidProgrammer("Antanas");
        androidProgrammer.greet();
        androidProgrammer.turnOnComputer();
        androidProgrammer.code();
        androidProgrammer.createBolt();

        // Game programmer example.
        GameProgrammer gameProgrammer = new GameProgrammer("Aloyzas");
        gameProgrammer.greet();
        gameProgrammer.turnOnComputer();
        gameProgrammer.code();
        gameProgrammer.createCounterStrike();

        // Construction worker example.
        ConstructionWorker constructionWorker = new ConstructionWorker("Martynas");
        constructionWorker.greet();
        constructionWorker.buildHouse();
        constructionWorker.takeBricks(7999);
        constructionWorker.buildHouse();
        constructionWorker.takeBricks(100);
        constructionWorker.buildHouse();
        constructionWorker.buildHouse();

        // Farmer example.
        Farmer farmer = new Farmer("Virgis");
        farmer.greet();
        farmer.harvestCrop();
        farmer.plantCrop();
        farmer.harvestCrop();
        farmer.waitCrop(200);
        farmer.harvestCrop();
    }
}
