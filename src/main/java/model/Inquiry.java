package model;

import java.time.LocalDateTime;

/**
 * Represents a user inquiry in the system.
 */
public class Inquiry {
    private int id;
    private int userId;
    private String userName;
    private String userEmail;
    private String subject;
    private String message;
    private LocalDateTime inquiryTime;
    private String status; // New, In Progress, Resolved
    
    /**
     * Constructor for Inquiry.
     */
    public Inquiry(int id, int userId, String userName, String userEmail, String subject, String message, 
                  LocalDateTime inquiryTime, String status) {
        this.id = id;
        this.userId = userId;
        this.userName = userName;
        this.userEmail = userEmail;
        this.subject = subject;
        this.message = message;
        this.inquiryTime = inquiryTime;
        this.status = status;
    }
    
    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    
    public String getUserEmail() { return userEmail; }
    public void setUserEmail(String userEmail) { this.userEmail = userEmail; }
    
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public LocalDateTime getInquiryTime() { return inquiryTime; }
    public void setInquiryTime(LocalDateTime inquiryTime) { this.inquiryTime = inquiryTime; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
