package testas;

import java.util.Random;

public class AppleTreeImpl implements AppleTree {
    private Random random = new Random();

    @Override
    public void growFruit() {
        System.out.println("Apple tree has grown " + random.nextInt(5) + " apples.");
    }
}
