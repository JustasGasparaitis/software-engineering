package testas;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.FileWriter;
import java.io.IOException;

public class WikipediaRunnable implements Runnable {
    private final String wikipediaArticle;
    private final FileWriter fileWriter;
    private final Object lock;

    public WikipediaRunnable(String wikipediaArticle, FileWriter fileWriter, Object lock) {
        this.wikipediaArticle = wikipediaArticle;
        this.fileWriter = fileWriter;
        this.lock = lock;
    }

    /**
     * Writes a Wikipedia article body to a file and time taken to do it to a file.
     */
    @Override
    public void run() {
        long startTime = System.nanoTime();
        Document wikipediaDocument;
        try {
            wikipediaDocument = Jsoup.connect("https://en.wikipedia.org/wiki/" + wikipediaArticle).get();
            Elements wikipediaPageBody = wikipediaDocument.select("#bodyContent");
            synchronized (lock) {
                fileWriter.write(wikipediaDocument.title() + "\n");
                for (Element e : wikipediaPageBody) {
                    fileWriter.write(e.text() + "\n");
                }
                long endTime = System.nanoTime();
                fileWriter.write("Time taken: " + ((endTime - startTime) / 1000000) + "ms\n");
                fileWriter.write("------------------------------------------------------------\n");
                fileWriter.flush();
                System.out.println("\nWikipediaRunnable Thread successfully completed! (" + ((endTime - startTime) / 1000000) + " ms)");
            }
        } catch (IOException e) {
            System.out.println("\nWikipediaRunnable Thread failed!");
            e.printStackTrace();
        }
    }
}
