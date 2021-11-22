package testas;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.FileWriter;
import java.io.IOException;

public class WeatherRunnable implements Runnable {
    private final FileWriter fileWriter;
    private final Object lock;

    public WeatherRunnable(FileWriter fileWriter, Object lock) {
        this.fileWriter = fileWriter;
        this.lock = lock;
    }

    /**
     * Writes current weather in Vilnius and time taken to do it in a file.
     */
    @Override
    public void run() {
        long startTime = System.nanoTime();
        Document weatherDocument;
        try {
            weatherDocument = Jsoup.connect("https://www.gismeteo.lt/weather-vilnius-4230/now/").get();
            Elements weatherBody = weatherDocument.select(".tab-weather__value > span:nth-child(1) > span:nth-child(1)");
            synchronized (lock) {
                fileWriter.write(weatherDocument.title() + "\n");
                for (Element e : weatherBody) {
                    fileWriter.write(e.text() + "\n");
                }
                long endTime = System.nanoTime();
                fileWriter.write("Time taken: " + ((endTime - startTime) / 1000000) + "ms\n");
                fileWriter.write("------------------------------------------------------------\n");
                fileWriter.flush();
                System.out.println("\nWeatherRunnable Thread successfully completed! (" + ((endTime - startTime) / 1000000) + " ms)");
            }
        } catch (IOException e) {
            System.out.println("\nWeatherRunnable Thread failed!");
            e.printStackTrace();
        }
    }
}
