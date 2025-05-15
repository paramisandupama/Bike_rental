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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserService userService;
    
    @Override
    public void init() {
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to registration page
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        
        // Validate input
        if (name == null || name.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        if (userService.getUserByEmail(email) != null) {
            request.setAttribute("error", "Email already exists");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }
        
        // Register user
        boolean registered = userService.registerUser(name, email, password);
        
        if (registered) {
            // Auto-login the user
            User user = userService.getUserByEmail(email);
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            
            // Redirect based on role
            if (email.toLowerCase().endsWith("@admin.com")) {
                // Redirect to admin dashboard
                response.sendRedirect(request.getContextPath() + "/advertisements");
            } else {
                // Redirect to user dashboard
                response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
            }
        } else {
            // Registration failed
            request.setAttribute("error", "Registration failed");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
