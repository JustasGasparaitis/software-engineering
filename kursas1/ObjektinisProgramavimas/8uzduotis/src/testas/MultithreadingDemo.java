package testas;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Scanner;

public class MultithreadingDemo {

    public static void main(String[] args) throws IOException {
        FileWriter fileWriter = new FileWriter("output.txt");
        Object lock = new Object();
        Scanner scanner = new Scanner(System.in);
        boolean isClosed = false;
        int selection;

        while (!isClosed) {
            System.out.println("Select option: (1 - wikipedia thread, 2 - weather thread, 3 - counting thread, 4 - close demo): ");
            try {
                selection = Integer.parseInt(scanner.nextLine());
            } catch (NumberFormatException e) {
                System.out.println("Incorrect input, try again!");
                System.out.println("Select option: (1 - wikipedia thread, 2 - weather thread, 3 - counting thread, 4 - close demo): ");
                selection = Integer.parseInt(scanner.nextLine());
            }
            switch (selection) {
                case 1:
                    //System.out.println("Enter a Wikipedia article title: ");
                    //String wikipediaArticle = scanner.nextLine();
                    new Thread(new WikipediaRunnable("Hello", fileWriter, lock)).start();
                    break;
                case 2:
                    new Thread(new WeatherRunnable(fileWriter, lock)).start();
                    break;
                case 3:
                    //System.out.println("Enter how many times to count to max int squared: ");
                    //int times = Integer.parseInt(scanner.nextLine());
                    new Thread(new CountToMaxIntSquaredRunnable(3, fileWriter, lock)).start();
                    break;
                case 4:
                    fileWriter.close();
                    scanner.close();
                    isClosed = true;
                    break;
                default:
                    break;
            }
        }
    }
}
