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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserService userService;
    
    @Override
    public void init() {
        userService = new UserService();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectBasedOnRole(user, request, response);
            return;
        }
        
        // Forward to login page
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        
        // Validate input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        
        // Authenticate user
        User user = userService.authenticateUser(email, password);
        
        if (user != null) {
            // Create session and store user
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            
            // Redirect based on role
            redirectBasedOnRole(user, request, response);
        } else {
            // Authentication failed
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    private void redirectBasedOnRole(User user, HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        if (user.isAdmin() || user.getEmail().toLowerCase().endsWith("@admin.com")) {
            // Redirect to admin dashboard
            response.sendRedirect(request.getContextPath() + "/advertisements");
        } else {
            // Redirect to user dashboard
            response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
        }
    }
}
