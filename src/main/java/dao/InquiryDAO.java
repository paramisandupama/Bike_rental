package dao;

import model.Inquiry;
import java.util.List;

/**
 * Interface for Inquiry data access operations.
 */
public interface InquiryDAO {
    /**
     * Get all inquiries.
     * 
     * @return List of all inquiries
     */
    List<Inquiry> getAllInquiries();
    
    /**
     * Get an inquiry by its ID.
     * 
     * @param id The inquiry ID
     * @return The inquiry with the specified ID, or null if not found
     */
    Inquiry getInquiryById(int id);
    
    /**
     * Get all inquiries for a specific user.
     * 
     * @param userId The user ID
     * @return List of inquiries for the specified user
     */
    List<Inquiry> getInquiriesByUserId(int userId);
    
    /**
     * Add a new inquiry.
     * 
     * @param inquiry The inquiry to add
     * @return true if the inquiry was added successfully, false otherwise
     */
    boolean addInquiry(Inquiry inquiry);
    
    /**
     * Update an existing inquiry.
     * 
     * @param inquiry The inquiry to update
     * @return true if the inquiry was updated successfully, false otherwise
     */
    boolean updateInquiry(Inquiry inquiry);
    
    /**
     * Delete an inquiry by its ID.
     * 
     * @param id The ID of the inquiry to delete
     * @return true if the inquiry was deleted successfully, false otherwise
     */
    boolean deleteInquiry(int id);
}
