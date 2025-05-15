package dao;

import model.Bike;
import java.util.List;

/**
 * Interface for Bike data access operations.
 */
public interface BikeDAO {
    /**
     * Get all bikes.
     * 
     * @return List of all bikes
     */
    List<Bike> getAllBikes();
    
    /**
     * Get a bike by its ID.
     * 
     * @param id The bike ID
     * @return The bike with the specified ID, or null if not found
     */
    Bike getBikeById(int id);
    
    /**
     * Get all available bikes.
     * 
     * @return List of all available bikes
     */
    List<Bike> getAvailableBikes();
    
    /**
     * Get bikes by type.
     * 
     * @param type The bike type
     * @return List of bikes of the specified type
     */
    List<Bike> getBikesByType(String type);
    
    /**
     * Add a new bike.
     * 
     * @param bike The bike to add
     * @return true if the bike was added successfully, false otherwise
     */
    boolean addBike(Bike bike);
    
    /**
     * Update an existing bike.
     * 
     * @param bike The bike to update
     * @return true if the bike was updated successfully, false otherwise
     */
    boolean updateBike(Bike bike);
    
    /**
     * Delete a bike by its ID.
     * 
     * @param id The ID of the bike to delete
     * @return true if the bike was deleted successfully, false otherwise
     */
    boolean deleteBike(int id);
}
