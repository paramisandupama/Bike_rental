package config;

import java.io.File;

/**
 * Centralized configuration for database file paths.
 * This class provides a single point of control for all database file paths.
 */
public class DatabaseConfig {
    // Base directory for all database files
    private static final String BASE_DIR = "C:\\SLIIT\\BikeRental\\BikeRental\\src\\main\\webapp\\database";

    // File paths for different entities
    public static final String USERS_FILE = BASE_DIR + File.separator + "Users.txt";
    public static final String ADVERTISEMENTS_FILE = BASE_DIR + File.separator + "Add.txt";
    public static final String BIKES_FILE = BASE_DIR + File.separator + "Bikes.txt";
    public static final String RENTALS_FILE = BASE_DIR + File.separator + "Rentals.txt";
    public static final String PAYMENTS_FILE = BASE_DIR + File.separator + "Payments.txt";
    public static final String REVIEWS_FILE = BASE_DIR + File.separator + "Reviews.txt";
    public static final String RENTAL_REQUESTS_FILE = BASE_DIR + File.separator + "RentalRequests.txt";
    public static final String INQUIRIES_FILE = BASE_DIR + File.separator + "Inquiries.txt";

    /**
     * Ensures that all database directories exist.
     * This method should be called during application startup.
     */
    public static void ensureDirectoriesExist() {
        File baseDir = new File(BASE_DIR);
        if (!baseDir.exists()) {
            boolean created = baseDir.mkdirs();
            if (!created) {
                System.err.println("Failed to create database directory: " + BASE_DIR);
            }
        }
    }

    /**
     * Ensures that a specific file exists.
     * If the file doesn't exist, it creates an empty file.
     *
     * @param filePath The path of the file to check/create
     * @return true if the file exists or was created successfully, false otherwise
     */
    public static boolean ensureFileExists(String filePath) {
        File file = new File(filePath);
        if (!file.exists()) {
            try {
                File parent = file.getParentFile();
                if (!parent.exists()) {
                    parent.mkdirs();
                }
                return file.createNewFile();
            } catch (Exception e) {
                System.err.println("Failed to create file: " + filePath);
                e.printStackTrace();
                return false;
            }
        }
        return true;
    }
}
