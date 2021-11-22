package com.company;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectOutputStream;

public class Serialization {
    private final ObjectOutputStream objectOutputStream;

    public Serialization(String fileOutputName) throws IOException {
        FileOutputStream fileOutputStream = new FileOutputStream(fileOutputName);
        objectOutputStream = new ObjectOutputStream(fileOutputStream);
    }

    public void serializeAndroidProgrammer(AndroidProgrammer androidProgrammer)
            throws IOException {
        objectOutputStream.writeObject(androidProgrammer);
        objectOutputStream.flush();
    }

    public void serializeWebProgrammer(WebProgrammer webProgrammer)
            throws IOException {
        objectOutputStream.writeObject(webProgrammer);
        objectOutputStream.flush();
    }

    public void serializeConstructionWorker(ConstructionWorker constructionWorker)
            throws IOException {
        objectOutputStream.writeObject(constructionWorker);
        objectOutputStream.flush();
    }

    public void serializeFarmer(Farmer farmer)
            throws IOException {
        objectOutputStream.writeObject(farmer);
        objectOutputStream.flush();
    }

    public void closeStream() throws IOException {
        objectOutputStream.close();
    }
}
