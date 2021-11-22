package com.company;

import java.io.IOException;

public class SerializationDemo {
    public void serialize() {
        // Set data
        Farmer farmer = WorkerFactory.createFarmer("Jurgis");
        farmer.plantCrop();
        WebProgrammer webProgrammer = WorkerFactory.createWebProgrammer("Antanas");
        webProgrammer.setWebsite(webProgrammer.createWebsite());
        AndroidProgrammer androidProgrammer = WorkerFactory.createAndroidProgrammer("Aloyzas");
        androidProgrammer.setAndroidApp(androidProgrammer.createAndroidApp());
        ConstructionWorker constructionWorker = WorkerFactory.createConstructionWorker("Martynas");
        constructionWorker.giveBricks(100);

        String fileName = "dataSerialization.txt";

        // Serialize
        Serialization serialization;
        try {
            serialization = new Serialization(fileName);
            serialization.serializeAndroidProgrammer(androidProgrammer);
            serialization.serializeFarmer(farmer);
            serialization.serializeConstructionWorker(constructionWorker);
            serialization.serializeWebProgrammer(webProgrammer);
            serialization.closeStream();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void deserialize() {
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