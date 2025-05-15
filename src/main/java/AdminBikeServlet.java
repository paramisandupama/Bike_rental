package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Bike;
import model.User;
import service.BikeService;
import service.ReviewService;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/bikes", "/admin/bikes/add", "/admin/bikes/edit/*", "/admin/bikes/delete/*"})
public class AdminBikeServlet extends HttpServlet {
    private BikeService bikeService;
    private ReviewService reviewService;

    @Override
    public void init() {
        bikeService = new BikeService();
        reviewService = new ReviewService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isAdmin() && !user.getEmail().toLowerCase().endsWith("@admin.com")) {
            response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
            return;
        }

        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        if (path.equals("/admin/bikes") && pathInfo == null) {
            // List all bikes
            List<Bike> bikes = bikeService.getAllBikes();
            request.setAttribute("bikes", bikes);
            request.getRequestDispatcher("/Admin_ADVER/manageBikes.jsp").forward(request, response);
        } else if (path.equals("/admin/bikes/add")) {
            // Show add bike form
            request.getRequestDispatcher("/Admin_ADVER/addBike.jsp").forward(request, response);
        } else if (path.equals("/admin/bikes/edit") && pathInfo != null) {
            // Show edit bike form
            try {
                int bikeId = Integer.parseInt(pathInfo.substring(1)); // Remove the leading slash
                Bike bike = bikeService.getBikeById(bikeId);

                if (bike != null) {
                    request.setAttribute("bike", bike);
                    request.getRequestDispatcher("/Admin_ADVER/editBike.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/bikes");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/bikes");
            }
        } else if (path.equals("/admin/bikes/delete") && pathInfo != null) {
            // Delete bike
            try {
                int bikeId = Integer.parseInt(pathInfo.substring(1)); // Remove the leading slash
                boolean deleted = bikeService.deleteBike(bikeId);

                if (deleted) {
                    request.setAttribute("success", "Bike deleted successfully");
                } else {
                    request.setAttribute("error", "Failed to delete bike");
                }

                response.sendRedirect(request.getContextPath() + "/admin/bikes");
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/bikes");
            }
        } else {
            // Invalid path
            response.sendRedirect(request.getContextPath() + "/admin/bikes");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and is admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!user.isAdmin() && !user.getEmail().toLowerCase().endsWith("@admin.com")) {
            response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
            return;
        }

        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        if (path.equals("/admin/bikes/add")) {
            // Add new bike
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            String description = request.getParameter("description");
            String hourlyRateStr = request.getParameter("hourlyRate");
            String dailyRateStr = request.getParameter("dailyRate");
            String status = request.getParameter("status");
            String imageUrl = request.getParameter("imageUrl");

            // Validate input
            if (name == null || name.trim().isEmpty() ||
                type == null || type.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                hourlyRateStr == null || hourlyRateStr.trim().isEmpty() ||
                dailyRateStr == null || dailyRateStr.trim().isEmpty() ||
                status == null || status.trim().isEmpty() ||
                imageUrl == null || imageUrl.trim().isEmpty()) {

                request.setAttribute("error", "All fields are required");
                request.getRequestDispatcher("/Admin_ADVER/addBike.jsp").forward(request, response);
                return;
            }

            try {
                double hourlyRate = Double.parseDouble(hourlyRateStr);
                double dailyRate = Double.parseDouble(dailyRateStr);

                // Create and add the bike
                Bike bike = new Bike(0, name, type, description, hourlyRate, dailyRate, status, imageUrl);
                boolean added = bikeService.addBike(bike);

                if (added) {
                    request.setAttribute("success", "Bike added successfully");
                    response.sendRedirect(request.getContextPath() + "/admin/bikes");
                } else {
                    request.setAttribute("error", "Failed to add bike");
                    request.getRequestDispatcher("/Admin_ADVER/addBike.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid rate format");
                request.getRequestDispatcher("/Admin_ADVER/addBike.jsp").forward(request, response);
            }
        } else if (path.equals("/admin/bikes/edit") && pathInfo != null) {
            // Update existing bike
            try {
                int bikeId = Integer.parseInt(pathInfo.substring(1)); // Remove the leading slash
                Bike existingBike = bikeService.getBikeById(bikeId);

                if (existingBike != null) {
                    String name = request.getParameter("name");
                    String type = request.getParameter("type");
                    String description = request.getParameter("description");
                    String hourlyRateStr = request.getParameter("hourlyRate");
                    String dailyRateStr = request.getParameter("dailyRate");
                    String status = request.getParameter("status");
                    String imageUrl = request.getParameter("imageUrl");

                    // Validate input
                    if (name == null || name.trim().isEmpty() ||
                        type == null || type.trim().isEmpty() ||
                        description == null || description.trim().isEmpty() ||
                        hourlyRateStr == null || hourlyRateStr.trim().isEmpty() ||
                        dailyRateStr == null || dailyRateStr.trim().isEmpty() ||
                        status == null || status.trim().isEmpty() ||
                        imageUrl == null || imageUrl.trim().isEmpty()) {

                        request.setAttribute("error", "All fields are required");
                        request.setAttribute("bike", existingBike);
                        request.getRequestDispatcher("/Admin_ADVER/editBike.jsp").forward(request, response);
                        return;
                    }

                    try {
                        double hourlyRate = Double.parseDouble(hourlyRateStr);
                        double dailyRate = Double.parseDouble(dailyRateStr);

                        // Update the bike
                        existingBike.setName(name);
                        existingBike.setType(type);
                        existingBike.setDescription(description);
                        existingBike.setHourlyRate(hourlyRate);
                        existingBike.setDailyRate(dailyRate);
                        existingBike.setStatus(status);
                        existingBike.setImageUrl(imageUrl);

                        boolean updated = bikeService.updateBike(existingBike);

                        if (updated) {
                            request.setAttribute("success", "Bike updated successfully");
                            response.sendRedirect(request.getContextPath() + "/admin/bikes");
                        } else {
                            request.setAttribute("error", "Failed to update bike");
                            request.setAttribute("bike", existingBike);
                            request.getRequestDispatcher("/Admin_ADVER/editBike.jsp").forward(request, response);
                        }
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "Invalid rate format");
                        request.setAttribute("bike", existingBike);
                        request.getRequestDispatcher("/Admin_ADVER/editBike.jsp").forward(request, response);
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/bikes");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/bikes");
            }
        } else {
            // Invalid path
            response.sendRedirect(request.getContextPath() + "/admin/bikes");
        }
    }
}
