package com.company;

/** Main class.
 */
public class Main {

    /** Main method.
     */
    public static void main(String[] args) {
        Farmer farmer = WorkerFactory.createFarmer("Jurgis");
        WebProgrammer webProgrammer = WorkerFactory.createWebProgrammer("Antanas");
        AndroidProgrammer androidProgrammer = WorkerFactory.createAndroidProgrammer("Aloyzas");
        ConstructionWorker constructionWorker = WorkerFactory.createConstructionWorker("Martynas");
        webProgrammer.work();
        androidProgrammer.work();
        constructionWorker.work();
        farmer.work();
    }
}
