package testas;

public class BirchTreeToAppleTreeAdapter implements AppleTree {
    private final BirchTreeImpl birchTree;

    public BirchTreeToAppleTreeAdapter(BirchTreeImpl newBirchTree) {
        birchTree = newBirchTree;
    }

    @Override
    public void growFruit() {
        birchTree.releaseSap();
    }
}
