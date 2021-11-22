package com.company;

import transport.*;

import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class PanelCreator {
    public static JPanel createCarDriverObjectPanel(String name, int experience, int amountOfCrashes) {
        JPanel carDriverObjectPanel = new JPanel();
        BoxLayout layout = new BoxLayout(carDriverObjectPanel, BoxLayout.Y_AXIS);
        carDriverObjectPanel.setLayout(layout);

        CarDriver carDriver = DriverFactory.createCarDriver(name, experience, amountOfCrashes);

        JLabel carDriverName = new JLabel();
        carDriverName.setText(carDriver.name);
        carDriverObjectPanel.add(carDriverName);

        JLabel carDriverAmountOfCrashes = new JLabel();
        carDriverAmountOfCrashes.setText("Amount of crashes: " + carDriver.getAmountOfCrashes());
        carDriverObjectPanel.add(carDriverAmountOfCrashes);

        JLabel carDriverVehiclesOwned = new JLabel();
        carDriverVehiclesOwned.setText("Vehicles owned: " + carDriver.getVehiclesOwned());
        carDriverObjectPanel.add(carDriverVehiclesOwned);

        JLabel carDriverExperience = new JLabel();
        carDriverExperience.setText("Driving experience: " + carDriver.getDrivingExperience());
        carDriverObjectPanel.add(carDriverExperience);

        JButton carDriverCrashButton = new JButton("Crash");
        carDriverCrashButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                carDriver.crash();
                carDriverAmountOfCrashes.setText("Amount of crashes: " + carDriver.getAmountOfCrashes());
            }
        });
        carDriverObjectPanel.add(carDriverCrashButton);

        JButton carDriverBuyVehicleButton = new JButton("Buy vehicle");
        carDriverBuyVehicleButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                carDriver.buyVehicle();
                carDriverVehiclesOwned.setText("Vehicles owned: " + carDriver.getVehiclesOwned());
            }
        });
        carDriverObjectPanel.add(carDriverBuyVehicleButton);
        return carDriverObjectPanel;
    }

    public static JPanel createMotorcycleDriverObjectPanel(String name, int experience, String sizeOfHelmet) {
        JPanel motorcycleDriverObjectPanel = new JPanel();
        BoxLayout layout = new BoxLayout(motorcycleDriverObjectPanel, BoxLayout.Y_AXIS);
        motorcycleDriverObjectPanel.setLayout(layout);

        MotorcycleDriver motorcycleDriver = DriverFactory.createMotorcycleDriver(name, experience, 0);
        motorcycleDriver.setSizeOfHelmet(sizeOfHelmet);

        JLabel motorcycleDriverName = new JLabel();
        motorcycleDriverName.setText(motorcycleDriver.name);
        motorcycleDriverObjectPanel.add(motorcycleDriverName);

        JLabel motorcycleDriverHelmetSize = new JLabel();
        motorcycleDriverHelmetSize.setText("Helmet size: " + motorcycleDriver.getSizeOfHelmet());
        motorcycleDriverObjectPanel.add(motorcycleDriverHelmetSize);

        JLabel motorcycleDriverVehiclesOwned = new JLabel();
        motorcycleDriverVehiclesOwned.setText("Vehicles owned: " + motorcycleDriver.getVehiclesOwned());
        motorcycleDriverObjectPanel.add(motorcycleDriverVehiclesOwned);

        JLabel motorcycleDriverExperience = new JLabel();
        motorcycleDriverExperience.setText("Driving experience: " + motorcycleDriver.getDrivingExperience());
        motorcycleDriverObjectPanel.add(motorcycleDriverExperience);

        JButton motorcycleDriverBuyVehicleButton = new JButton("Buy vehicle");
        motorcycleDriverBuyVehicleButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                motorcycleDriver.buyVehicle();
                motorcycleDriverVehiclesOwned.setText("Vehicles owned: " + motorcycleDriver.getVehiclesOwned());
            }
        });
        motorcycleDriverObjectPanel.add(motorcycleDriverBuyVehicleButton);

        JButton motorcycleDriverWearHelmetButton = new JButton("Wear helmet");
        motorcycleDriverBuyVehicleButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                motorcycleDriver.wearHelmet();
            }
        });
        motorcycleDriverObjectPanel.add(motorcycleDriverWearHelmetButton);
        return motorcycleDriverObjectPanel;
    }

    public static JPanel createMotorcycleObjectPanel(int engineSize, int fuelConsumption, String fuelType, String brand,
                                                     int numOfWheels, int numOfSeats, String loudness) {
        JPanel motorcycleObjectPanel = new JPanel();
        BoxLayout layout = new BoxLayout(motorcycleObjectPanel, BoxLayout.Y_AXIS);
        motorcycleObjectPanel.setLayout(layout);

        Motorcycle motorcycle = new Motorcycle(numOfWheels, null, numOfSeats, null, brand, null);
        motorcycle.setEngineSize(engineSize);
        motorcycle.setFuelConsumption(fuelConsumption);
        motorcycle.setFuelType(fuelType);
        motorcycle.setLoudness(loudness);
        //motorcycle.distance
        //motorcycle.getBrand();
        //motorcycle.getNumOfSeats();
        //motorcycle.getNumOfWheels();
        //motorcycle.getDrivesOn();
        //motorcycle.getLoudness();

        JLabel motorcycleBrand = new JLabel();
        motorcycleBrand.setText(motorcycle.getBrand());
        motorcycleObjectPanel.add(motorcycleBrand);

        JLabel motorcycleDistance = new JLabel();
        motorcycleDistance.setText("Distance driven: " + motorcycle.distance + " km");
        motorcycleObjectPanel.add(motorcycleDistance);

        JLabel motorcycleEngineSize = new JLabel();
        motorcycleEngineSize.setText("Engine size: " + motorcycle.getEngineSize() + " cc");
        motorcycleObjectPanel.add(motorcycleEngineSize);

        JLabel motorcycleFuelConsumption = new JLabel();
        motorcycleFuelConsumption.setText("Fuel consumption: " + motorcycle.getFuelConsumption() + " l/100km");
        motorcycleObjectPanel.add(motorcycleFuelConsumption);

        JLabel motorcycleFuelType = new JLabel();
        motorcycleFuelType.setText("Fuel type: " + motorcycle.getFuelType());
        motorcycleObjectPanel.add(motorcycleFuelType);

        JLabel motorcycleNumOfWheels = new JLabel();
        motorcycleNumOfWheels.setText("Number of wheels: " + motorcycle.getNumOfWheels());
        motorcycleObjectPanel.add(motorcycleNumOfWheels);

        JLabel motorcycleNumOfSeats = new JLabel();
        motorcycleNumOfSeats.setText("Number of seats: " + motorcycle.getNumOfSeats());
        motorcycleObjectPanel.add(motorcycleNumOfSeats);

        JLabel motorcycleLoudness = new JLabel();
        motorcycleLoudness.setText("Loudness: " + motorcycle.getLoudness());
        motorcycleObjectPanel.add(motorcycleLoudness);

        JTextField motorcycleDistanceToDrive = new JTextField();
        motorcycleObjectPanel.add(motorcycleDistanceToDrive);

        JButton motorcycleDriveButton = new JButton("Drive");
        motorcycleDriveButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String distanceText = motorcycleDistanceToDrive.getText();
                double distanceDouble= motorcycle.distance;
                try {
                    distanceDouble = Double.parseDouble(distanceText);
                } catch (NullPointerException | NumberFormatException ignored) {}
                motorcycle.drive(distanceDouble);
                motorcycleDistance.setText("Distance driven: " + motorcycle.distance + " km");
            }
        });
        motorcycleObjectPanel.add(motorcycleDriveButton);
        return motorcycleObjectPanel;
    }

    public static JPanel createCarObjectPanel(int fuelConsumption, String fuelType, String brand,
                                              int numOfWheels, int numOfSeats, String loudness) {
        JPanel carObjectPanel = new JPanel();
        BoxLayout layout = new BoxLayout(carObjectPanel, BoxLayout.Y_AXIS);
        carObjectPanel.setLayout(layout);

        Car car = new Car(numOfWheels, null, numOfSeats, null, brand, null);
        car.setFuelConsumption(fuelConsumption);
        car.setFuelType(fuelType);
        car.setLoudness(loudness);

        JLabel carBrand = new JLabel();
        carBrand.setText(car.getBrand());
        carObjectPanel.add(carBrand);

        JLabel carDistance = new JLabel();
        carDistance.setText("Distance driven: " + car.distance + " km");
        carObjectPanel.add(carDistance);

        JLabel carFuelConsumption = new JLabel();
        carFuelConsumption.setText("Fuel consumption: " + car.getFuelConsumption() + " l/100km");
        carObjectPanel.add(carFuelConsumption);

        JLabel carFuelType = new JLabel();
        carFuelType.setText("Fuel type: " + car.getFuelType());
        carObjectPanel.add(carFuelType);

        JLabel carNumOfWheels = new JLabel();
        carNumOfWheels.setText("Number of wheels: " + car.getNumOfWheels());
        carObjectPanel.add(carNumOfWheels);

        JLabel carNumOfSeats = new JLabel();
        carNumOfSeats.setText("Number of seats: " + car.getNumOfSeats());
        carObjectPanel.add(carNumOfSeats);

        JLabel carLoudness = new JLabel();
        carLoudness.setText("Loudness: " + car.getLoudness());
        carObjectPanel.add(carLoudness);

        JTextField carDistanceToDrive = new JTextField();
        carObjectPanel.add(carDistanceToDrive);

        JButton carDriveButton = new JButton("Drive");
        carDriveButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String distanceText = carDistanceToDrive.getText();
                double distanceDouble= car.distance;
                try {
                    distanceDouble = Double.parseDouble(distanceText);
                } catch (NullPointerException | NumberFormatException ignored) {}
                car.drive(distanceDouble);
                carDistance.setText("Distance driven: " + car.distance + " km");
            }
        });
        carObjectPanel.add(carDriveButton);
        return carObjectPanel;
    }

    public static JPanel createTrainObjectPanel(String brand, int numOfWheels, int numOfSeats,
                                                String startingPoint, int maxSpeed) {
        JPanel trainObjectPanel = new JPanel();
        BoxLayout layout = new BoxLayout(trainObjectPanel, BoxLayout.Y_AXIS);
        trainObjectPanel.setLayout(layout);

        Train train = new Train(numOfWheels, null, numOfSeats, null, brand, null);
        train.setStartingPoint(startingPoint);
        train.setMaxSpeed(maxSpeed);

        JLabel trainBrand = new JLabel();
        trainBrand.setText(train.getBrand());
        trainObjectPanel.add(trainBrand);

        JLabel trainMaxSpeed = new JLabel();
        trainMaxSpeed.setText("Max speed: " + train.getMaxSpeed() + " km/h");
        trainObjectPanel.add(trainMaxSpeed);

        JLabel trainDistance = new JLabel();
        trainDistance.setText("Distance driven: " + train.distance + " km");
        trainObjectPanel.add(trainDistance);

        JLabel trainNumOfWheels = new JLabel();
        trainNumOfWheels.setText("Number of wheels: " + train.getNumOfWheels());
        trainObjectPanel.add(trainNumOfWheels);

        JLabel trainNumOfSeats = new JLabel();
        trainNumOfSeats.setText("Number of seats: " + train.getNumOfSeats());
        trainObjectPanel.add(trainNumOfSeats);

        JLabel trainDrivesOn = new JLabel();
        trainDrivesOn.setText("Drives on: " + train.getDrivesOn());
        trainObjectPanel.add(trainDrivesOn);

        JLabel trainStartingPoint = new JLabel();
        trainStartingPoint.setText("Starting point: " + train.getStartingPoint());
        trainObjectPanel.add(trainStartingPoint);

        JTextField trainDistanceToDrive = new JTextField();
        trainObjectPanel.add(trainDistanceToDrive);

        JButton trainDriveButton = new JButton("Drive");
        trainDriveButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String distanceText = trainDistanceToDrive.getText();
                double distanceDouble= train.distance;
                try {
                    distanceDouble = Double.parseDouble(distanceText);
                } catch (NullPointerException | NumberFormatException ignored) {}
                train.drive(distanceDouble);
                trainDistance.setText("Distance driven: " + train.distance + " km");
            }
        });
        trainObjectPanel.add(trainDriveButton);
        return trainObjectPanel;
    }

    public static JPanel createShipObjectPanel(int fuelConsumption, String fuelType, String brand, int numOfSeats,
                                               String typeOfShip, int maxDistance, String startingPoint) {
        JPanel shipObjectPanel = new JPanel();
        BoxLayout layout = new BoxLayout(shipObjectPanel, BoxLayout.Y_AXIS);
        shipObjectPanel.setLayout(layout);

        Ship ship = new Ship(0, null, numOfSeats, null, brand, null);
        ship.setFuelConsumption(fuelConsumption);
        ship.setFuelType(fuelType);
        ship.setTypeOfShip(typeOfShip);
        ship.setMaxDistance(maxDistance);

        JLabel shipBrand = new JLabel();
        shipBrand.setText(ship.getBrand());
        shipObjectPanel.add(shipBrand);

        JLabel shipTypeOfShip = new JLabel();
        shipTypeOfShip.setText("Type of ship: " + ship.getTypeOfShip());
        shipObjectPanel.add(shipTypeOfShip);

        JLabel shipDistance = new JLabel();
        shipDistance.setText("Distance driven: " + ship.distance + " km");
        shipObjectPanel.add(shipDistance);

        JLabel shipMaxDistance = new JLabel();
        shipMaxDistance.setText("Max distance: " + ship.getMaxDistance() + " km");
        shipObjectPanel.add(shipMaxDistance);

        JLabel shipFuelConsumption = new JLabel();
        shipFuelConsumption.setText("Fuel consumption: " + ship.getFuelConsumption() + " l/100km");
        shipObjectPanel.add(shipFuelConsumption);

        JLabel shipFuelType = new JLabel();
        shipFuelType.setText("Fuel type: " + ship.getFuelType());
        shipObjectPanel.add(shipFuelType);

        JLabel shipNumOfSeats = new JLabel();
        shipNumOfSeats.setText("Number of seats: " + ship.getNumOfSeats());
        shipObjectPanel.add(shipNumOfSeats);

        JTextField shipDistanceToDrive = new JTextField();
        shipObjectPanel.add(shipDistanceToDrive);

        JButton shipDriveButton = new JButton("Drive");
        shipDriveButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String distanceText = shipDistanceToDrive.getText();
                double distanceDouble= ship.distance;
                try {
                    distanceDouble = Double.parseDouble(distanceText);
                } catch (NullPointerException | NumberFormatException ignored) {}
                ship.drive(distanceDouble);
                shipDistance.setText("Distance driven: " + ship.distance + " km");
            }
        });
        shipObjectPanel.add(shipDriveButton);
        return shipObjectPanel;
    }
}
