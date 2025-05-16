package config;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Database initializer that runs when the application starts.
 * This class ensures that all database files exist.
 */
@WebListener
public class DatabaseInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Initializing database...");

        // Ensure base directory exists
        DatabaseConfig.ensureDirectoriesExist();

        // Ensure all database files exist
        DatabaseConfig.ensureFileExists(DatabaseConfig.USERS_FILE);
        DatabaseConfig.ensureFileExists(DatabaseConfig.ADVERTISEMENTS_FILE);
        DatabaseConfig.ensureFileExists(DatabaseConfig.BIKES_FILE);
        DatabaseConfig.ensureFileExists(DatabaseConfig.RENTALS_FILE);
        DatabaseConfig.ensureFileExists(DatabaseConfig.PAYMENTS_FILE);
        DatabaseConfig.ensureFileExists(DatabaseConfig.REVIEWS_FILE);
        DatabaseConfig.ensureFileExists(DatabaseConfig.RENTAL_REQUESTS_FILE);

        System.out.println("Database initialization complete.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Nothing to do when the application shuts down
    }
}
