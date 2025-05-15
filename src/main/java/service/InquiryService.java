package service;

import dao.InquiryDAO;
import dao.FileInquiryDAO;
import model.Inquiry;
import model.User;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Service class for inquiry-related operations.
 */
public class InquiryService {
    private InquiryDAO inquiryDAO;

    /**
     * Constructor for InquiryService.
     */
    public InquiryService() {
        this.inquiryDAO = new FileInquiryDAO();
    }

    /**
     * Get all inquiries.
     *
     * @return List of all inquiries
     */
    public List<Inquiry> getAllInquiries() {
        return inquiryDAO.getAllInquiries();
    }

    /**
     * Get an inquiry by its ID.
     *
     * @param id The inquiry ID
     * @return The inquiry with the specified ID, or null if not found
     */
    public Inquiry getInquiryById(int id) {
        return inquiryDAO.getInquiryById(id);
    }

    /**
     * Get all inquiries for a specific user.
     *
     * @param userId The user ID
     * @return List of inquiries for the specified user
     */
    public List<Inquiry> getInquiriesByUserId(int userId) {
        return inquiryDAO.getInquiriesByUserId(userId);
    }

    /**
     * Create a new inquiry.
     *
     * @param user The user creating the inquiry
     * @param subject The subject of the inquiry
     * @param message The message content
     * @return The created inquiry, or null if the inquiry could not be created
     */
    public Inquiry createInquiry(User user, String subject, String message) {
        // Create a new inquiry
        Inquiry inquiry = new Inquiry(
            0, // ID will be assigned by DAO
            user.getId(),
            user.getName(),
            user.getEmail(),
            subject,
            message,
            LocalDateTime.now(),
            "New" // Initial status
        );

        // Add the inquiry
        boolean added = inquiryDAO.addInquiry(inquiry);
        if (added) {
            // Get the inquiry with the assigned ID
            List<Inquiry> userInquiries = inquiryDAO.getInquiriesByUserId(user.getId());
            return userInquiries.stream()
                    .filter(i -> i.getSubject().equals(subject) && i.getMessage().equals(message))
                    .findFirst()
                    .orElse(null);
        }

        return null;
    }

    /**
     * Update an inquiry's status.
     *
     * @param inquiryId The inquiry ID
     * @param status The new status
     * @return true if the inquiry was updated successfully, false otherwise
     */
    public boolean updateInquiryStatus(int inquiryId, String status) {
        Inquiry inquiry = inquiryDAO.getInquiryById(inquiryId);
        if (inquiry == null) {
            return false;
        }

        inquiry.setStatus(status);
        return inquiryDAO.updateInquiry(inquiry);
    }

    /**
     * Update an inquiry.
     *
     * @param inquiry The inquiry to update
     * @return true if the inquiry was updated successfully, false otherwise
     */
    public boolean updateInquiry(Inquiry inquiry) {
        if (inquiry == null) {
            return false;
        }

        return inquiryDAO.updateInquiry(inquiry);
    }

    /**
     * Delete an inquiry.
     *
     * @param inquiryId The inquiry ID
     * @return true if the inquiry was deleted successfully, false otherwise
     */
    public boolean deleteInquiry(int inquiryId) {
        return inquiryDAO.deleteInquiry(inquiryId);
    }
}
