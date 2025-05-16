<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Bike" %>
<%@ page import="model.Rental" %>
<%@ page import="model.RentalRequest" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Rentals - Bike Rental</title>
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

        // Get data from request attributes
        List<Rental> userRentals = (List<Rental>) request.getAttribute("userRentals");
        List<RentalRequest> userRentalRequests = (List<RentalRequest>) request.getAttribute("userRentalRequests");
        Map<Integer, Bike> bikeMap = (Map<Integer, Bike>) request.getAttribute("bikeMap");
        int activeRentalsCount = (Integer) request.getAttribute("activeRentalsCount");
        int completedRentalsCount = (Integer) request.getAttribute("completedRentalsCount");
        int pendingRequestsCount = (Integer) request.getAttribute("pendingRequestsCount");

        // Format for dates and times
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        // Format for prices
        DecimalFormat df = new DecimalFormat("0.00");

        // Get success and error messages
        String successMessage = (String) request.getAttribute("success");
        String errorMessage = (String) request.getAttribute("error");
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
                        <a href="<%= request.getContextPath() %>/userDashboard.jsp" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-green-700">
                            <i class="fas fa-tachometer-alt mr-3"></i>
                            Dashboard
                        </a>
                        <!-- Bikes -->
                        <a href="<%= request.getContextPath() %>/bikes" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-green-700">
                            <i class="fas fa-bicycle mr-3"></i>
                            Available Bikes
                        </a>
                        <!-- Rentals -->
                        <a href="<%= request.getContextPath() %>/my-rentals" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg bg-green-700 text-white">
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
                        <h1 class="text-lg font-semibold text-gray-900">My Rentals</h1>
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
                    <!-- Success/Error Messages -->
                    <% if (successMessage != null && !successMessage.isEmpty()) { %>
                        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4" role="alert">
                            <span class="block sm:inline"><%= successMessage %></span>
                        </div>
                    <% } %>
                    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
                        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4" role="alert">
                            <span class="block sm:inline"><%= errorMessage %></span>
                        </div>
                    <% } %>

                    <!-- Rental Stats -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
                        <div class="bg-white rounded-lg shadow p-6">
                            <div class="flex items-center">
                                <div class="p-3 rounded-full bg-green-50 text-green-600">
                                    <i class="fas fa-bicycle text-xl"></i>
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
                                    <i class="fas fa-clock text-xl"></i>
                                </div>
                                <div class="ml-4">
                                    <p class="text-sm font-medium text-gray-500">Pending Requests</p>
                                    <p class="text-2xl font-semibold text-gray-900"><%= pendingRequestsCount %></p>
                                </div>
                            </div>
                        </div>
                        <div class="bg-white rounded-lg shadow p-6">
                            <div class="flex items-center">
                                <div class="p-3 rounded-full bg-green-50 text-green-600">
                                    <i class="fas fa-history text-xl"></i>
                                </div>
                                <div class="ml-4">
                                    <p class="text-sm font-medium text-gray-500">Completed Rentals</p>
                                    <p class="text-2xl font-semibold text-gray-900"><%= completedRentalsCount %></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Pending Rental Requests Section -->
                    <div class="bg-white rounded-lg shadow p-6 mb-6">
                        <h2 class="text-xl font-semibold text-gray-800 mb-4">Pending Rental Requests</h2>

                        <% if (userRentalRequests != null && !userRentalRequests.isEmpty()) {
                            boolean hasPendingRequests = false;
                            for (RentalRequest rentalRequest : userRentalRequests) {
                                if ("Pending".equals(rentalRequest.getStatus())) {
                                    hasPendingRequests = true;
                                    Bike bike = bikeMap.get(rentalRequest.getBikeId());
                                    if (bike == null) continue;
                        %>
                            <div class="border-b border-gray-200 py-4 last:border-b-0">
                                <div class="flex flex-col md:flex-row md:items-center md:justify-between">
                                    <div class="flex items-center mb-2 md:mb-0">
                                        <img src="<%= bike.getImageUrl() %>" alt="<%= bike.getName() %>" class="h-16 w-20 object-cover rounded mr-4">
                                        <div>
                                            <h3 class="text-lg font-medium text-gray-900"><%= bike.getName() %></h3>
                                            <p class="text-sm text-gray-500"><%= bike.getType() %></p>
                                            <div class="flex items-center mt-1">
                                                <span class="text-sm text-gray-500 mr-2">Request ID: <%= rentalRequest.getId() %></span>
                                                <span class="text-sm text-gray-500 mr-2">•</span>
                                                <span class="text-sm text-gray-500"><%= rentalRequest.getRentalType() %> Rental</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="flex flex-col items-end">
                                        <span class="px-2 py-1 bg-yellow-100 text-yellow-800 text-xs font-semibold rounded-full mb-2">
                                            Pending Approval
                                        </span>
                                        <span class="text-sm text-gray-500">
                                            Requested on <%= rentalRequest.getRequestTime().format(dateTimeFormatter) %>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        <%
                                }
                            }
                            if (!hasPendingRequests) {
                        %>
                            <p class="text-gray-500 text-center py-4">No pending rental requests.</p>
                        <%
                            }
                        } else {
                        %>
                            <p class="text-gray-500 text-center py-4">No pending rental requests.</p>
                        <% } %>
                    </div>

                    <!-- Active Rentals Section -->
                    <div class="bg-white rounded-lg shadow p-6 mb-6">
                        <h2 class="text-xl font-semibold text-gray-800 mb-4">Active Rentals</h2>

                        <% if (userRentals != null && !userRentals.isEmpty()) {
                            boolean hasActiveRentals = false;
                            for (Rental rental : userRentals) {
                                if (rental.isActive()) {
                                    hasActiveRentals = true;
                                    Bike bike = bikeMap.get(rental.getBikeId());
                                    if (bike == null) continue;
                        %>
                            <div class="border-b border-gray-200 py-4 last:border-b-0">
                                <div class="flex flex-col md:flex-row md:items-center md:justify-between">
                                    <div class="flex items-center mb-2 md:mb-0">
                                        <img src="<%= bike.getImageUrl() %>" alt="<%= bike.getName() %>" class="h-16 w-20 object-cover rounded mr-4">
                                        <div>
                                            <h3 class="text-lg font-medium text-gray-900"><%= bike.getName() %></h3>
                                            <p class="text-sm text-gray-500"><%= bike.getType() %></p>
                                            <div class="flex items-center mt-1">
                                                <span class="text-sm text-gray-500 mr-2">Rental ID: <%= rental.getId() %></span>
                                                <span class="text-sm text-gray-500 mr-2">•</span>
                                                <span class="text-sm text-gray-500"><%= rental.getRentalType() %> Rental</span>
                                                <span class="text-sm text-gray-500 mr-2">•</span>
                                                <span class="text-sm text-gray-500">
                                                    <% if ("Hourly".equals(rental.getRentalType())) { %>
                                                        $<%= df.format(bike.getHourlyRate()) %>/hour
                                                    <% } else { %>
                                                        $<%= df.format(bike.getDailyRate()) %>/day
                                                    <% } %>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="flex flex-col items-end">
                                        <span class="px-2 py-1 bg-green-50 text-green-600 text-xs font-semibold rounded-full mb-2">
                                            Active
                                        </span>
                                        <span class="text-sm text-gray-500 mb-2">
                                            Started on <%= rental.getStartTime().format(dateTimeFormatter) %>
                                        </span>
                                        <a href="<%= request.getContextPath() %>/my-rentals/cancel/<%= rental.getId() %>"
                                           onclick="return confirm('Are you sure you want to cancel this rental?')"
                                           class="text-red-600 hover:text-red-800 text-sm">
                                            <i class="fas fa-times mr-1"></i> Cancel Rental
                                        </a>
                                    </div>
                                </div>
                            </div>
                        <%
                                }
                            }
                            if (!hasActiveRentals) {
                        %>
                            <p class="text-gray-500 text-center py-4">No active rentals.</p>
                        <%
                            }
                        } else {
                        %>
                            <p class="text-gray-500 text-center py-4">No active rentals.</p>
                        <% } %>
                    </div>

                    <!-- Rental History Section -->
                    <div class="bg-white rounded-lg shadow p-6">
                        <h2 class="text-xl font-semibold text-gray-800 mb-4">Rental History</h2>

                        <% if (userRentals != null && !userRentals.isEmpty()) {
                            boolean hasCompletedRentals = false;
                            for (Rental rental : userRentals) {
                                if ("Completed".equals(rental.getStatus()) || "Cancelled".equals(rental.getStatus())) {
                                    hasCompletedRentals = true;
                                    Bike bike = bikeMap.get(rental.getBikeId());
                                    if (bike == null) continue;
                        %>
                            <div class="border-b border-gray-200 py-4 last:border-b-0">
                                <div class="flex flex-col md:flex-row md:items-center md:justify-between">
                                    <div class="flex items-center mb-2 md:mb-0">
                                        <img src="<%= bike.getImageUrl() %>" alt="<%= bike.getName() %>" class="h-16 w-20 object-cover rounded mr-4">
                                        <div>
                                            <h3 class="text-lg font-medium text-gray-900"><%= bike.getName() %></h3>
                                            <p class="text-sm text-gray-500"><%= bike.getType() %></p>
                                            <div class="flex items-center mt-1">
                                                <span class="text-sm text-gray-500 mr-2">Rental ID: <%= rental.getId() %></span>
                                                <span class="text-sm text-gray-500 mr-2">•</span>
                                                <span class="text-sm text-gray-500"><%= rental.getRentalType() %> Rental</span>
                                                <% if (rental.getTotalCost() > 0) { %>
                                                    <span class="text-sm text-gray-500 mr-2">•</span>
                                                    <span class="text-sm text-gray-500">Total: $<%= df.format(rental.getTotalCost()) %></span>
                                                <% } %>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="flex flex-col items-end">
                                        <% if ("Completed".equals(rental.getStatus())) { %>
                                            <span class="px-2 py-1 bg-green-50 text-green-600 text-xs font-semibold rounded-full mb-2">
                                                Completed
                                            </span>
                                        <% } else { %>
                                            <span class="px-2 py-1 bg-red-100 text-red-800 text-xs font-semibold rounded-full mb-2">
                                                Cancelled
                                            </span>
                                        <% } %>
                                        <span class="text-sm text-gray-500 mb-2">
                                            <%= rental.getStartTime().format(dateTimeFormatter) %> to
                                            <%= rental.getEndTime() != null ? rental.getEndTime().format(dateTimeFormatter) : "N/A" %>
                                        </span>
                                        <a href="<%= request.getContextPath() %>/my-rentals/delete/<%= rental.getId() %>"
                                           onclick="return confirm('Are you sure you want to delete this rental record? This action cannot be undone.')"
                                           class="text-red-600 hover:text-red-800 text-sm">
                                            <i class="fas fa-trash-alt mr-1"></i> Delete Record
                                        </a>
                                    </div>
                                </div>
                            </div>
                        <%
                                }
                            }
                            if (!hasCompletedRentals) {
                        %>
                            <p class="text-gray-500 text-center py-4">No rental history.</p>
                        <%
                            }
                        } else {
                        %>
                            <p class="text-gray-500 text-center py-4">No rental history.</p>
                        <% } %>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Include the floating inquiry button -->
    <%@ include file="components/inquiryButton.jsp" %>
</body>
</html>
