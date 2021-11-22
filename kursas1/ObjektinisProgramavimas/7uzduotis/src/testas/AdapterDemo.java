package testas;

public class AdapterDemo {

    public static void main(String[] args) {
        AppleTreeImpl appleTree = new AppleTreeImpl();
        BirchTreeImpl birchTreeImpl = new BirchTreeImpl();
        AppleTree birchTree = new BirchTreeToAppleTreeAdapter(birchTreeImpl);

        appleTree.growFruit();
        birchTree.growFruit();
    }
}
