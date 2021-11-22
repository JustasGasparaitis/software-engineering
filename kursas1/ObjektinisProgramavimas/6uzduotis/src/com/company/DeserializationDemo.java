package com.company;

import java.io.IOException;

public class DeserializationDemo {
    public void demonstrate() {
        String fileName = "dataSerialization.txt";
        Deserialization deserialization;
        Farmer dFarmer = new Farmer("failure");
        WebProgrammer dWebProgrammer = new WebProgrammer("failure");
        AndroidProgrammer dAndroidProgrammer = new AndroidProgrammer("failure");
        ConstructionWorker dConstructionWorker = new ConstructionWorker("failure");
        try {
            deserialization = new Deserialization(fileName);
            dAndroidProgrammer = deserialization.deserializeAndroidProgrammer();
            dFarmer = deserialization.deserializeFarmer();
            dConstructionWorker = deserialization.deserializeConstructionWorker();
            dWebProgrammer = deserialization.deserializeWebProgrammer();
            deserialization.closeStream();
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        System.out.println(dAndroidProgrammer.name);
        System.out.println(dFarmer.name);
        System.out.println(dConstructionWorker.name);
        System.out.println(dWebProgrammer.name);
    }
}
