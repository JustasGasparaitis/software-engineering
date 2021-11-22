package com.company;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Main {

    public static void main(String[] args) {
        // GUI
        JFrame mainFrame = new JFrame("Database");
        JPanel mainMenuPanel = new JPanel();
        JPanel driverMenuPanel = new JPanel();
        JPanel transportMenuPanel = new JPanel();
        JPanel carDriverPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        JPanel motorcycleDriverPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        JPanel groundTransportPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        JPanel waterTransportPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));


        // Main menu panel
        JButton driverButton = new JButton("Drivers");
        driverButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                mainMenuPanel.setVisible(false);
                driverMenuPanel.setVisible(true);
            }
        });
        mainMenuPanel.add(driverButton);

        JButton transportButton = new JButton("Transport");
        transportButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                mainMenuPanel.setVisible(false);
                transportMenuPanel.setVisible(true);
            }
        });
        mainMenuPanel.add(transportButton);

        // Driver menu panel
        JButton driverMenuBackButton = new JButton("Back");
        driverMenuBackButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                driverMenuPanel.setVisible(false);
                mainMenuPanel.setVisible(true);
            }
        });
        driverMenuPanel.add(driverMenuBackButton);

        JButton carButton = new JButton("Car");
        carButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                driverMenuPanel.setVisible(false);
                carDriverPanel.setVisible(true);
            }
        });
        driverMenuPanel.add(carButton);

        JButton motorcycleButton = new JButton("Motorcycle");
        motorcycleButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                driverMenuPanel.setVisible(false);
                motorcycleDriverPanel.setVisible(true);
            }
        });
        driverMenuPanel.add(motorcycleButton);

        // Transport menu panel
        JButton transportMenuBackButton = new JButton("Back");
        transportMenuBackButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                transportMenuPanel.setVisible(false);
                mainMenuPanel.setVisible(true);
            }
        });
        transportMenuPanel.add(transportMenuBackButton);

        JButton groundTransportButton = new JButton("Ground");
        groundTransportButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                transportMenuPanel.setVisible(false);
                groundTransportPanel.setVisible(true);
            }
        });
        transportMenuPanel.add(groundTransportButton);

        JButton waterTransportButton = new JButton("Water");
        waterTransportButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                transportMenuPanel.setVisible(false);
                waterTransportPanel.setVisible(true);
            }
        });
        transportMenuPanel.add(waterTransportButton);

        // Car driver panel
        JButton carDriverBackButton = new JButton("Back");
        carDriverBackButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                carDriverPanel.setVisible(false);
                driverMenuPanel.setVisible(true);
            }
        });
        carDriverPanel.add(carDriverBackButton);
        carDriverPanel.add(PanelCreator.createCarDriverObjectPanel("Maiklas", 5, 6));
        carDriverPanel.add(PanelCreator.createCarDriverObjectPanel("Sandra", 20, 1));

        // Motorcycle driver panel
        JButton motorcycleDriverBackButton = new JButton("Back");
        motorcycleDriverBackButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                motorcycleDriverPanel.setVisible(false);
                driverMenuPanel.setVisible(true);
            }
        });
        motorcycleDriverPanel.add(motorcycleDriverBackButton);
        motorcycleDriverPanel.add(PanelCreator.createMotorcycleDriverObjectPanel("Andrelis", 10, "Small"));
        motorcycleDriverPanel.add(PanelCreator.createMotorcycleDriverObjectPanel("Aloyzas", 10, "Large"));
        motorcycleDriverPanel.add(PanelCreator.createMotorcycleDriverObjectPanel("Virgis", 10, "Standard"));
        motorcycleDriverPanel.add(PanelCreator.createMotorcycleDriverObjectPanel("Antanis", 10, "Very large"));
        motorcycleDriverPanel.add(PanelCreator.createMotorcycleDriverObjectPanel("Lina", 10, "Big"));

        // Ground transport panel
        JButton groundTransportBackButton = new JButton("Back");
        groundTransportBackButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                groundTransportPanel.setVisible(false);
                transportMenuPanel.setVisible(true);
            }
        });
        groundTransportPanel.add(groundTransportBackButton);
        groundTransportPanel.add(PanelCreator.createMotorcycleObjectPanel(346, 5, "Petrol",
                "Izh-56", 2, 2, "Quiet"));
        groundTransportPanel.add(PanelCreator.createMotorcycleObjectPanel(350, 4, "Petrol",
                "Jawa 637", 2, 2, "Quiet"));
        groundTransportPanel.add(PanelCreator.createCarObjectPanel(8, "Diesel",
                "Audi 80", 4, 5, "Standard"));
        groundTransportPanel.add(PanelCreator.createCarObjectPanel(7, "Petrol",
                "Opel Vectra", 4, 6, "None"));
        groundTransportPanel.add(PanelCreator.createTrainObjectPanel("Vaguon-31", 24, 300,
                "Moscow", 150));
        groundTransportPanel.add(PanelCreator.createTrainObjectPanel("Wagon-49", 49, 349,
                "Berlin", 149));

        // Water transport panel
        JButton waterTransportBackButton = new JButton("Back");
        waterTransportBackButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                waterTransportPanel.setVisible(false);
                transportMenuPanel.setVisible(true);
            }
        });
        waterTransportPanel.add(waterTransportBackButton);
        waterTransportPanel.add(PanelCreator.createShipObjectPanel(100, "Marine gas oil", "Evergreen", 20,
                "Container", 1000, "Suez Canal"));
        waterTransportPanel.add(PanelCreator.createShipObjectPanel(154, "Marine gas oil", "Everblue", 15,
                "Cargo", 4765, "Panama Canal"));
        waterTransportPanel.add(PanelCreator.createShipObjectPanel(154, "Marine diesel oil", "Royal Caribbean", 580,
                "Cruise", 1000, "Bahamas"));

        // Panels
        carDriverPanel.setVisible(false);
        driverMenuPanel.setVisible(false);
        groundTransportPanel.setVisible(false);
        transportMenuPanel.setVisible(false);
        motorcycleDriverPanel.setVisible(false);
        waterTransportPanel.setVisible(false);

        mainFrame.add(carDriverPanel);
        mainFrame.add(mainMenuPanel);
        mainFrame.add(driverMenuPanel);
        mainFrame.add(motorcycleDriverPanel);
        mainFrame.add(transportMenuPanel);
        mainFrame.add(groundTransportPanel);
        mainFrame.add(waterTransportPanel);

        mainFrame.setSize(600,600);
        mainFrame.setLayout(new BoxLayout(mainFrame.getContentPane(), BoxLayout.Y_AXIS));
        mainFrame.setVisible(true);
    }
}
