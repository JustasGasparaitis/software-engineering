package com.company;

/**
 * Represents an Android programmer.
 *
 * @author Justas Gasparaitis, 1 kursas, 5 grupe
 */
public class AndroidProgrammer extends Programmer {

    /**
     * Creates an Android programmer with the specified name.
     *
     * @param workerName The Android programmer’s name.
     */
    AndroidProgrammer(String workerName) {
        super(workerName);
        job = "Android Programmer";
    }
    private AndroidApp androidApp;

    /**
     * Creates an android app.
     * @return Created Android app
     */
    public AndroidApp createAndroidApp() {
        return new AndroidApp();
    }

    /**
     * Android programmer creates an android app.
     */
    @Override
    public void work() {
        androidApp = createAndroidApp();
    }

    public AndroidApp getAndroidApp() {
        return androidApp;
    }

    public void setAndroidApp(AndroidApp androidApp) {
        this.androidApp = androidApp;
    }


}
