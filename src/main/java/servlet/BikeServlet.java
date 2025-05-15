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
import service.RentalRequestService;
import model.RentalRequest;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/bikes")
public class BikeServlet extends HttpServlet {
    private BikeService bikeService;
    private ReviewService reviewService;
    private RentalRequestService rentalRequestService;

    @Override
    public void init() {
        bikeService = new BikeService();
        reviewService = new ReviewService();
        rentalRequestService = new RentalRequestService();
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

        // Get filter parameters
        String typeFilter = request.getParameter("type");
        String sortBy = request.getParameter("sortBy");

        // Get available bikes
        List<Bike> availableBikes = bikeService.getAvailableBikes();

        // Apply type filter if specified
        if (typeFilter != null && !typeFilter.isEmpty() && !typeFilter.equals("all")) {
            availableBikes = availableBikes.stream()
                    .filter(bike -> bike.getType().equalsIgnoreCase(typeFilter))
                    .collect(Collectors.toList());
        }

        // Apply sorting if specified
        if (sortBy != null && !sortBy.isEmpty()) {
            switch (sortBy) {
                case "priceAsc":
                    availableBikes.sort(Comparator.comparing(Bike::getHourlyRate));
                    break;
                case "priceDesc":
                    availableBikes.sort(Comparator.comparing(Bike::getHourlyRate).reversed());
                    break;
                case "nameAsc":
                    availableBikes.sort(Comparator.comparing(Bike::getName));
                    break;
                case "nameDesc":
                    availableBikes.sort(Comparator.comparing(Bike::getName).reversed());
                    break;
                default:
                    // No sorting
                    break;
            }
        }

        // Get all unique bike types for the filter dropdown
        List<String> bikeTypes = bikeService.getAllBikes().stream()
                .map(Bike::getType)
                .distinct()
                .sorted()
                .collect(Collectors.toList());

        // Get average ratings for each bike
        List<Double> bikeRatings = new ArrayList<>();
        for (Bike bike : availableBikes) {
            double rating = reviewService.getAverageRatingForBike(bike.getId());
            bikeRatings.add(rating);
        }

        // Get user ID
        User currentUser = (User) session.getAttribute("user");
        int userId = currentUser.getId();

        // Check for pending rental requests for each bike
        Map<Integer, Boolean> pendingRentals = new HashMap<>();
        List<RentalRequest> userRequests = rentalRequestService.getRentalRequestsByUserId(userId);

        for (Bike bike : availableBikes) {
            boolean hasPendingRequest = userRequests.stream()
                .anyMatch(req -> req.getBikeId() == bike.getId() &&
                          (req.isPending() || req.isApproved()));
            pendingRentals.put(bike.getId(), hasPendingRequest);
        }

        // Set attributes for the JSP
        request.setAttribute("bikes", availableBikes);
        request.setAttribute("bikeTypes", bikeTypes);
        request.setAttribute("bikeRatings", bikeRatings);
        request.setAttribute("pendingRentals", pendingRentals);
        request.setAttribute("selectedType", typeFilter != null ? typeFilter : "all");
        request.setAttribute("selectedSort", sortBy != null ? sortBy : "");

        // Forward to the JSP
        request.getRequestDispatcher("/availableBikes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // This method would handle bike rental requests
        // For now, we'll just redirect to the GET method
        doGet(request, response);
    }
}
