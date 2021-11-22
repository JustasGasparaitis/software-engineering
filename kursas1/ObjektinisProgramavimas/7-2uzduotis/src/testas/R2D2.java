package testas;

public class R2D2 implements Robot {
    @Override
    public Robot makeCopy() {
        Robot robotCopy = null;
        try {
            robotCopy = (Robot) super.clone();
        } catch (CloneNotSupportedException e) {
            System.out.println("Copy unsuccessful.");
            e.printStackTrace();
        }
        return robotCopy;
    }

    @Override
    public String toString() {
        return "Beep boop.";
    }
}
