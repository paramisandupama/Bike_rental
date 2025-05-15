package service;

import dao.FileUserDAO;
import dao.UserDAO;
import model.User;

import java.util.List;

public class UserService {
    private UserDAO userDAO;

    public UserService() {
        this.userDAO = new FileUserDAO();
    }

    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    public User getUserById(int id) {
        return userDAO.getUserById(id);
    }
    
    public User getUserByEmail(String email) {
        return userDAO.getUserByEmail(email);
    }

    public boolean registerUser(String name, String email, String password) {
        // Determine role based on email domain
        String role = email.toLowerCase().endsWith("@admin.com") ? "admin" : "user";
        
        // Create a new user with ID 0 (will be assigned in DAO)
        User user = new User(0, name, email, password, role);
        
        return userDAO.addUser(user);
    }
    
    public User authenticateUser(String email, String password) {
        User user = userDAO.getUserByEmail(email);
        
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        
        return null; // Authentication failed
    }

    public boolean updateUser(User user) {
        return userDAO.updateUser(user);
    }

    public boolean deleteUser(int id) {
        return userDAO.deleteUser(id);
    }
}
