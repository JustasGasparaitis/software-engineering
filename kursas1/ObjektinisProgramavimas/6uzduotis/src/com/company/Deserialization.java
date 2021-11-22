package com.company;

import java.io.*;

public class Deserialization {
    private final ObjectInputStream objectInputStream;

    public Deserialization(String fileInputName) throws IOException {
        FileInputStream fileInputStream = new FileInputStream(fileInputName);
        objectInputStream = new ObjectInputStream(fileInputStream);
    }

    public AndroidProgrammer deserializeAndroidProgrammer()
            throws IOException, ClassNotFoundException {
        return (AndroidProgrammer) objectInputStream.readObject();
    }

    public WebProgrammer deserializeWebProgrammer()
            throws IOException, ClassNotFoundException {
        return (WebProgrammer) objectInputStream.readObject();
    }

    public ConstructionWorker deserializeConstructionWorker()
            throws IOException, ClassNotFoundException {
        return (ConstructionWorker) objectInputStream.readObject();
    }

    public Farmer deserializeFarmer()
            throws IOException, ClassNotFoundException {
        return (Farmer) objectInputStream.readObject();
    }

    public void closeStream() throws IOException {
        objectInputStream.close();
    }
}
