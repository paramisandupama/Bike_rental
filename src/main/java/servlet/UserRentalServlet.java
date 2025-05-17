package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Bike;
import model.Rental;
import model.RentalRequest;
import model.User;
import service.BikeService;
import service.RentalService;
import service.RentalRequestService;
import service.ReviewService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/my-rentals", "/my-rentals/cancel/*", "/my-rentals/delete/*"})
public class UserRentalServlet extends HttpServlet {
    private RentalService rentalService;
    private BikeService bikeService;
    private RentalRequestService rentalRequestService;
    private ReviewService reviewService;

    @Override
    public void init() {
        rentalService = new RentalService();
        bikeService = new BikeService();
        rentalRequestService = new RentalRequestService();
        reviewService = new ReviewService();
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
        String pathInfo = request.getPathInfo();

        if (path.equals("/my-rentals") && pathInfo == null) {
            // Get user's rentals
            List<Rental> userRentals = rentalService.getRentalsByUserId(user.getId());

            // Get user's rental requests
            List<RentalRequest> userRentalRequests = rentalRequestService.getRentalRequestsByUserId(user.getId());

            // Get bikes for each rental and request
            Map<Integer, Bike> bikeMap = new HashMap<>();

            // Add bikes from rentals
            for (Rental rental : userRentals) {
                if (!bikeMap.containsKey(rental.getBikeId())) {
                    Bike bike = bikeService.getBikeById(rental.getBikeId());
                    if (bike != null) {
                        bikeMap.put(bike.getId(), bike);
                    }
                }
            }

            // Add bikes from rental requests
            for (RentalRequest rentalRequest : userRentalRequests) {
                if (!bikeMap.containsKey(rentalRequest.getBikeId())) {
                    Bike bike = bikeService.getBikeById(rentalRequest.getBikeId());
                    if (bike != null) {
                        bikeMap.put(bike.getId(), bike);
                    }
                }
            }

            // Get counts for dashboard
            int activeRentalsCount = (int) userRentals.stream().filter(Rental::isActive).count();
            int completedRentalsCount = (int) userRentals.stream().filter(r -> "Completed".equals(r.getStatus())).count();
            int pendingRequestsCount = (int) userRentalRequests.stream().filter(r -> "Pending".equals(r.getStatus())).count();

            // Set attributes for the JSP
            request.setAttribute("userRentals", userRentals);
            request.setAttribute("userRentalRequests", userRentalRequests);
            request.setAttribute("bikeMap", bikeMap);
            request.setAttribute("activeRentalsCount", activeRentalsCount);
            request.setAttribute("completedRentalsCount", completedRentalsCount);
            request.setAttribute("pendingRequestsCount", pendingRequestsCount);

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

            // Forward to the JSP
            request.getRequestDispatcher("/myRentals.jsp").forward(request, response);
        } else if (path.equals("/my-rentals/cancel") && pathInfo != null) {
            // Cancel rental
            try {
                int rentalId = Integer.parseInt(pathInfo.substring(1)); // Remove the leading slash

                // Check if the rental belongs to the user
                Rental rental = rentalService.getRentalById(rentalId);
                if (rental != null && rental.getUserId() == user.getId()) {
                    boolean cancelled = rentalService.cancelRental(rentalId);

                    if (cancelled) {
                        session.setAttribute("success", "Rental cancelled successfully");
                    } else {
                        session.setAttribute("error", "Failed to cancel rental");
                    }
                } else {
                    session.setAttribute("error", "Invalid rental ID or you don't have permission to cancel this rental");
                }

                response.sendRedirect(request.getContextPath() + "/my-rentals");
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid rental ID");
                response.sendRedirect(request.getContextPath() + "/my-rentals");
            }
        } else if (path.equals("/my-rentals/delete") && pathInfo != null) {
            // Delete rental from history
            try {
                int rentalId = Integer.parseInt(pathInfo.substring(1)); // Remove the leading slash

                // Check if the rental belongs to the user and is completed or cancelled
                Rental rental = rentalService.getRentalById(rentalId);
                if (rental != null && rental.getUserId() == user.getId() &&
                    ("Completed".equals(rental.getStatus()) || "Cancelled".equals(rental.getStatus()))) {

                    // Delete the rental
                    boolean deleted = rentalService.deleteRental(rentalId);

                    if (deleted) {
                        session.setAttribute("success", "Rental record deleted successfully");
                    } else {
                        session.setAttribute("error", "Failed to delete rental record");
                    }
                } else {
                    session.setAttribute("error", "Invalid rental ID, you don't have permission, or the rental is still active");
                }

                response.sendRedirect(request.getContextPath() + "/my-rentals");
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid rental ID");
                response.sendRedirect(request.getContextPath() + "/my-rentals");
            }
        } else {
            // Invalid path
            response.sendRedirect(request.getContextPath() + "/my-rentals");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle POST requests (e.g., for submitting reviews)
        doGet(request, response);
    }
}
