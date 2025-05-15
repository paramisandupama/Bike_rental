package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.UserService;

import java.io.IOException;

@WebServlet(urlPatterns = {"/profile", "/profile/edit", "/profile/delete"})
public class UserProfileServlet extends HttpServlet {
    private UserService userService;
    
    @Override
    public void init() {
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String path = request.getServletPath();
        
        if (path.equals("/profile")) {
            // Get success and error messages from session
            String successMessage = (String) session.getAttribute("success");
            String errorMessage = (String) session.getAttribute("error");
            
            if (successMessage != null) {
                request.setAttribute("success", successMessage);
                session.removeAttribute("success");
            }
            
            if (errorMessage != null) {
                request.setAttribute("error", errorMessage);
                session.removeAttribute("error");
            }
            
            // Forward to profile page
            request.getRequestDispatcher("/userProfile.jsp").forward(request, response);
        } else if (path.equals("/profile/delete")) {
            // Delete user account
            boolean deleted = userService.deleteUser(user.getId());
            
            if (deleted) {
                // Invalidate session
                session.invalidate();
                
                // Redirect to login page with message
                response.sendRedirect(request.getContextPath() + "/login?message=Account deleted successfully");
            } else {
                // Set error message
                session.setAttribute("error", "Failed to delete account");
                
                // Redirect back to profile page
                response.sendRedirect(request.getContextPath() + "/profile");
            }
        } else {
            // Invalid path, redirect to profile page
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        String path = request.getServletPath();
        
        if (path.equals("/profile/edit")) {
            // Get form data
            String name = request.getParameter("name");
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Validate form data
            if (name == null || name.trim().isEmpty()) {
                session.setAttribute("error", "Name cannot be empty");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }
            
            // Update user name
            user.setName(name);
            
            // Update password if provided
            if (currentPassword != null && !currentPassword.isEmpty() &&
                newPassword != null && !newPassword.isEmpty() &&
                confirmPassword != null && !confirmPassword.isEmpty()) {
                
                // Verify current password
                if (!currentPassword.equals(user.getPassword())) {
                    session.setAttribute("error", "Current password is incorrect");
                    response.sendRedirect(request.getContextPath() + "/profile");
                    return;
                }
                
                // Verify new password matches confirmation
                if (!newPassword.equals(confirmPassword)) {
                    session.setAttribute("error", "New password and confirmation do not match");
                    response.sendRedirect(request.getContextPath() + "/profile");
                    return;
                }
                
                // Update password
                user.setPassword(newPassword);
            }
            
            // Save changes
            boolean updated = userService.updateUser(user);
            
            if (updated) {
                // Update session with updated user
                session.setAttribute("user", user);
                
                // Set success message
                session.setAttribute("success", "Profile updated successfully");
            } else {
                // Set error message
                session.setAttribute("error", "Failed to update profile");
            }
            
            // Redirect back to profile page
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            // Invalid path, redirect to profile page
            response.sendRedirect(request.getContextPath() + "/profile");
        }
    }
}
