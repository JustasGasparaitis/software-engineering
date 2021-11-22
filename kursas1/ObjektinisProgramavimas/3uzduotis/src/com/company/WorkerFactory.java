package com.company;

public final class WorkerFactory {
    public static AndroidProgrammer createAndroidProgrammer(String name) {
        return new AndroidProgrammer(name);
    }
    public static WebProgrammer createWebProgrammer(String name) {
        return new WebProgrammer(name);
    }
    public static ConstructionWorker createConstructionWorker(String name) {
        return new ConstructionWorker(name);
    }
    public static Farmer createFarmer(String name) {
        return new Farmer(name);
    }
}
