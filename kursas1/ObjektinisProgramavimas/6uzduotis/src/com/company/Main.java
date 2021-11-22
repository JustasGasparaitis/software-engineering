package com.company;

/** Main class.
 */
public class Main {

    /** Main method.
     */
    public static void main(String[] args) {
        SerializationDemo serializationDemo = new SerializationDemo();
        serializationDemo.serialize();
        serializationDemo.deserialize();

        DeserializationDemo deserializationDemo = new DeserializationDemo();
        deserializationDemo.demonstrate();

        CSVDemo csvDemo = new CSVDemo();
        csvDemo.writeData();
        csvDemo.readData();
    }
}
