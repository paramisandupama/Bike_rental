<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Bike" %>
<%@ page import="model.Rental" %>
<%@ page import="model.RentalRequest" %>
<%@ page import="service.BikeService" %>
<%@ page import="service.RentalService" %>
<%@ page import="service.RentalRequestService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - Bike Rental</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
    <%
        // Check if user is logged in
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check if user is admin, redirect if needed
        if (user.isAdmin() || user.getEmail().toLowerCase().endsWith("@admin.com")) {
            response.sendRedirect(request.getContextPath() + "/advertisements");
            return;
        }

        // Get featured bikes (3 random available bikes)
        BikeService bikeService = new BikeService();
        RentalRequestService rentalRequestService = new RentalRequestService();
        RentalService rentalService = new RentalService();

        List<Bike> availableBikes = bikeService.getAvailableBikes();
        List<Bike> featuredBikes = availableBikes.subList(0, Math.min(3, availableBikes.size()));

        // Get user's rentals and requests
        List<Rental> userRentals = rentalService.getRentalsByUserId(user.getId());
        List<RentalRequest> userRequests = rentalRequestService.getRentalRequestsByUserId(user.getId());

        // Get counts for dashboard
        int activeRentalsCount = (int) userRentals.stream().filter(Rental::isActive).count();
        int rentalHistoryCount = (int) userRentals.stream().filter(r -> "Completed".equals(r.getStatus()) || "Cancelled".equals(r.getStatus())).count();

        // Check for pending rental requests for each bike
        Map<Integer, Boolean> pendingRentals = new HashMap<>();
        for (Bike bike : featuredBikes) {
            boolean hasPendingRequest = userRequests.stream()
                .anyMatch(req -> req.getBikeId() == bike.getId() &&
                          (req.isPending() || req.isApproved()));
            pendingRentals.put(bike.getId(), hasPendingRequest);
        }

        // Format for prices
        DecimalFormat df = new DecimalFormat("0.00");
    %>

    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <div class="hidden md:flex md:flex-shrink-0">
            <div class="flex flex-col w-64 bg-green-800 text-white">
                <div class="flex items-center justify-center h-16 px-4 bg-green-900">
                    <span class="text-xl font-bold">Bike Rental</span>
                </div>
                <div class="flex flex-col flex-grow px-4 py-4 overflow-y-auto">
                    <nav class="flex-1 space-y-2">
                        <!-- Dashboard -->
                        <a href="<%= request.getContextPath() %>/userDashboard.jsp" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg bg-green-700 text-white">
                            <i class="fas fa-tachometer-alt mr-3"></i>
                            Dashboard
                        </a>
                        <!-- Bikes -->
                        <a href="<%= request.getContextPath() %>/bikes" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-green-700">
                            <i class="fas fa-bicycle mr-3"></i>
                            Available Bikes
                        </a>
                        <!-- Rentals -->
                        <a href="<%= request.getContextPath() %>/my-rentals" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-green-700">
                            <i class="fas fa-clipboard-list mr-3"></i>
                            My Rentals
                        </a>
                        <!-- Inquiries -->
                        <a href="<%= request.getContextPath() %>/inquiries" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-green-700">
                            <i class="fas fa-question-circle mr-3"></i>
                            My Inquiries
                        </a>
                        <!-- Profile -->
                        <a href="<%= request.getContextPath() %>/profile" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-green-700">
                            <i class="fas fa-user mr-3"></i>
                            Profile
                        </a>
                        <!-- Logout -->
                        <a href="<%= request.getContextPath() %>/logout" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-green-700">
                            <i class="fas fa-sign-out-alt mr-3"></i>
                            Logout
                        </a>
                    </nav>
                </div>
                <div class="p-4 border-t border-green-700">
                    <div class="flex items-center">
                        <div class="w-10 h-10 rounded-full bg-green-300 text-green-800 flex items-center justify-center font-medium">
                            <%= user.getName().substring(0, 1).toUpperCase() %>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm font-medium"><%= user.getName() %></p>
                            <p class="text-xs text-green-200"><%= user.getEmail() %></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="flex flex-col flex-1 overflow-hidden">
            <!-- Top Navigation -->
            <header class="bg-white shadow-sm z-10">
                <div class="px-4 sm:px-6 lg:px-8 py-4 flex justify-between items-center">
                    <div class="flex items-center">
                        <button class="md:hidden mr-4 text-gray-500 focus:outline-none">
                            <i class="fas fa-bars"></i>
                        </button>
                        <h1 class="text-lg font-semibold text-gray-900">User Dashboard</h1>
                    </div>
                    <div class="flex items-center space-x-4">
                        <button class="p-1 text-gray-400 rounded-full hover:text-gray-500 focus:outline-none">
                            <i class="fas fa-bell"></i>
                        </button>
                        <div class="relative">
                            <button class="flex items-center focus:outline-none">
                                <span class="hidden md:block mr-2 text-sm font-medium"><%= user.getName() %></span>
                                <div class="w-8 h-8 rounded-full bg-green-300 text-green-800 flex items-center justify-center font-medium">
                                    <%= user.getName().substring(0, 1).toUpperCase() %>
                                </div>
                            </button>
                        </div>
                        <a href="<%= request.getContextPath() %>/logout" class="px-3 py-1 bg-red-600 text-white rounded-md text-sm hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                            <i class="fas fa-sign-out-alt mr-1"></i> Logout
                        </a>
                    </div>
                </div>
            </header>

            <!-- Page Content -->
            <main class="flex-1 overflow-y-auto p-4 sm:p-6 lg:p-8 bg-gray-100">
                <div class="max-w-7xl mx-auto">
                    <!-- Welcome Section -->
                    <div class="bg-white rounded-lg shadow p-6 mb-6">
                        <h2 class="text-2xl font-bold text-gray-800 mb-2">Welcome, <%= user.getName() %>!</h2>
                        <p class="text-gray-600">This is your user dashboard. You can browse available bikes, manage your rentals, and update your profile.</p>
                    </div>

                    <!-- Quick Stats -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                        <div class="bg-white rounded-lg shadow p-6">
                            <div class="flex items-center">
                                <div class="p-3 rounded-full bg-green-50 text-green-600">
                                    <i class="fas fa-bicycle text-xl"></i>
                                </div>
                                <div class="ml-4">
                                    <p class="text-sm font-medium text-gray-500">Available Bikes</p>
                                    <p class="text-2xl font-semibold text-gray-900"><%= availableBikes.size() %></p>
                                </div>
                            </div>
                        </div>
                        <div class="bg-white rounded-lg shadow p-6">
                            <div class="flex items-center">
                                <div class="p-3 rounded-full bg-green-50 text-green-600">
                                    <i class="fas fa-clipboard-check text-xl"></i>
                                </div>
                                <div class="ml-4">
                                    <p class="text-sm font-medium text-gray-500">Active Rentals</p>
                                    <p class="text-2xl font-semibold text-gray-900"><%= activeRentalsCount %></p>
                                </div>
                            </div>
                        </div>
                        <div class="bg-white rounded-lg shadow p-6">
                            <div class="flex items-center">
                                <div class="p-3 rounded-full bg-yellow-100 text-yellow-600">
                                    <i class="fas fa-history text-xl"></i>
                                </div>
                                <div class="ml-4">
                                    <p class="text-sm font-medium text-gray-500">Rental History</p>
                                    <p class="text-2xl font-semibold text-gray-900"><%= rentalHistoryCount %></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Featured Bikes -->
                    <div class="bg-white rounded-lg shadow p-6">
                        <h3 class="text-lg font-medium text-gray-900 mb-4">Featured Bikes</h3>
                        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                            <% if (featuredBikes != null && !featuredBikes.isEmpty()) {
                                for (Bike bike : featuredBikes) { %>
                                    <div class="border rounded-lg overflow-hidden">
                                        <img src="<%= bike.getImageUrl() %>" alt="<%= bike.getName() %>" class="w-full h-48 object-cover">
                                        <div class="p-4">
                                            <div class="flex justify-between items-start mb-2">
                                                <h4 class="font-medium text-gray-900"><%= bike.getName() %></h4>
                                                <span class="px-2 py-1 bg-green-50 text-green-600 text-xs font-semibold rounded-full"><%= bike.getType() %></span>
                                            </div>
                                            <p class="text-sm text-gray-500 mb-2"><%= bike.getDescription() %></p>
                                            <div class="flex justify-between items-center">
                                                <span class="text-green-600 font-medium">$<%= df.format(bike.getDailyRate()) %>/day</span>
                                                <% if (pendingRentals != null && pendingRentals.containsKey(bike.getId()) && pendingRentals.get(bike.getId())) { %>
                                                    <span class="px-3 py-1 bg-yellow-100 text-yellow-800 rounded-md text-sm">Request Pending</span>
                                                <% } else if (!bike.isAvailable()) { %>
                                                    <span class="px-3 py-1 bg-red-100 text-red-800 rounded-md text-sm">Not Available</span>
                                                <% } else { %>
                                                    <a href="<%= request.getContextPath() %>/bikes" class="px-3 py-1 bg-green-600 text-white rounded-md text-sm hover:bg-green-700">Rent Now</a>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                <% }
                            } else { %>
                                <div class="col-span-3 text-center py-8">
                                    <p class="text-gray-500">No bikes available at the moment.</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Include the floating inquiry button -->
    <%@ include file="components/inquiryButton.jsp" %>
</body>
</html>
