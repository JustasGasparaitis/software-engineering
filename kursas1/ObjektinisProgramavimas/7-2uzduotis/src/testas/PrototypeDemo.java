package testas;

public class PrototypeDemo {
    public static void main(String[] args) {
        T101 terminator = new T101();
        T101 terminatorCopy = (T101) terminator.makeCopy();
        System.out.println("Terminator says: " + terminator);
        System.out.println("Terminator Copy says: " + terminatorCopy);
        System.out.println("Terminator ID: " + System.identityHashCode(System.identityHashCode(terminator)));
        System.out.println("Terminator Copy ID: " + System.identityHashCode(System.identityHashCode(terminatorCopy)) + "\n");

        R2D2 r2D2 = new R2D2();
        R2D2 r2D2Copy = (R2D2) r2D2.makeCopy();
        System.out.println("R2D2 says: " + r2D2);
        System.out.println("R2D2 Copy says: " + r2D2Copy);
        System.out.println("R2D2 ID: " + System.identityHashCode(System.identityHashCode(r2D2)));
        System.out.println("R2D2 Copy ID: " + System.identityHashCode(System.identityHashCode(r2D2Copy)));
    }
}
