package com.company;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CSVDemo {
    public void writeData() {
        // Data
        Farmer farmer = WorkerFactory.createFarmer("Jurgis");
        farmer.waitCrop(10);
        WebProgrammer webProgrammer = WorkerFactory.createWebProgrammer("Antanas");
        webProgrammer.setWebsite(webProgrammer.createWebsite());
        AndroidProgrammer androidProgrammer = WorkerFactory.createAndroidProgrammer("Aloyzas");
        androidProgrammer.setAndroidApp(androidProgrammer.createAndroidApp());
        ConstructionWorker constructionWorker = WorkerFactory.createConstructionWorker("Martynas");
        constructionWorker.giveBricks(100);

        // Write data
        try {
            FileWriter csvWriter = new FileWriter("workers.csv");
            // Field names
            csvWriter.append("Name");
            csvWriter.append(",");
            csvWriter.append("Job");
            csvWriter.append(",");
            csvWriter.append("Information");
            csvWriter.append("\n");

            // Farmer data
            csvWriter.append(farmer.name);
            csvWriter.append(",");
            csvWriter.append(farmer.job);
            csvWriter.append(",");
            csvWriter.append(String.valueOf(farmer.getWaitTime()));
            csvWriter.append("\n");

            // Web programmer data
            csvWriter.append(webProgrammer.name);
            csvWriter.append(",");
            csvWriter.append(webProgrammer.job);
            csvWriter.append(",");
            csvWriter.append(String.valueOf(webProgrammer.getWebsite().compile()));
            csvWriter.append("\n");

            // Android programmer data
            csvWriter.append(androidProgrammer.name);
            csvWriter.append(",");
            csvWriter.append(androidProgrammer.job);
            csvWriter.append(",");
            csvWriter.append(String.valueOf(androidProgrammer.getAndroidApp().compile()));
            csvWriter.append("\n");

            // Construction worker data
            csvWriter.append(constructionWorker.name);
            csvWriter.append(",");
            csvWriter.append(constructionWorker.job);
            csvWriter.append(",");
            csvWriter.append(String.valueOf(constructionWorker.getBrickCount()));
            csvWriter.append("\n");

            csvWriter.flush();
            csvWriter.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void readData() {
        // Read data
        List<String> nameList = new ArrayList<>();
        List<String> jobList = new ArrayList<>();
        List<Integer> informationList = new ArrayList<>();
        try {
            BufferedReader csvReader = new BufferedReader(new FileReader("workers.csv"));
            String row = csvReader.readLine(); // ignore field names
            while ((row = csvReader.readLine()) != null) {
                String[] data = row.split(",");
                if (data[0] == null || data[1] == null || data[2] == null) {
                    throw new InvalidCSVFileException("Invalid CSV file: some fields are incorrect.");
                }
                if (data[1].equals("Farmer")
                        || data[1].equals("Web Programmer")
                        || data[1].equals("Android Programmer")
                        || data[1].equals("Construction Worker")) {
                    nameList.add(data[0]);
                    jobList.add(data[1]);
                    informationList.add(Integer.valueOf(data[2]));
                } else {
                    throw new InvalidCSVFileException("Invalid CSV file: unrecognized job title.");
                }
            }
            csvReader.close();
        } catch (IOException | InvalidCSVFileException | NumberFormatException e) {
            e.printStackTrace();
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("Invalid CSV file");
        }
        for (int i = 0; i < nameList.size(); i++) {
            System.out.println(nameList.get(i) + " " + jobList.get(i) + " " + informationList.get(i));
        }
    }
}
