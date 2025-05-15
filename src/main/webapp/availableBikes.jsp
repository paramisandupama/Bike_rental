<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Bike" %>
<%@ page import="model.RentalRequest" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Bikes - Bike Rental</title>
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
        List<Bike> bikes = (List<Bike>) request.getAttribute("bikes");
        List<String> bikeTypes = (List<String>) request.getAttribute("bikeTypes");
        List<Double> bikeRatings = (List<Double>) request.getAttribute("bikeRatings");
        Map<Integer, Boolean> pendingRentals = (Map<Integer, Boolean>) request.getAttribute("pendingRentals");
        String selectedType = (String) request.getAttribute("selectedType");
        String selectedSort = (String) request.getAttribute("selectedSort");

        // Get success and error messages
        String successMessage = (String) request.getAttribute("success");
        String errorMessage = (String) request.getAttribute("error");

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
                        <a href="<%= request.getContextPath() %>/userDashboard.jsp" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-green-700">
                            <i class="fas fa-tachometer-alt mr-3"></i>
                            Dashboard
                        </a>
                        <!-- Bikes -->
                        <a href="<%= request.getContextPath() %>/bikes" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg bg-green-700 text-white">
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
                        <h1 class="text-lg font-semibold text-gray-900">Available Bikes</h1>
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

                    <!-- Filter and Sort Section -->
                    <div class="bg-white rounded-lg shadow p-6 mb-6">
                        <form action="<%= request.getContextPath() %>/bikes" method="get" class="flex flex-col md:flex-row md:items-end space-y-4 md:space-y-0 md:space-x-4">
                            <!-- Type Filter -->
                            <div class="flex-1">
                                <label for="type" class="block text-sm font-medium text-gray-700 mb-1">Bike Type</label>
                                <select id="type" name="type" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                    <option value="all" <%= "all".equals(selectedType) ? "selected" : "" %>>All Types</option>
                                    <% for (String type : bikeTypes) { %>
                                        <option value="<%= type %>" <%= type.equals(selectedType) ? "selected" : "" %>><%= type %></option>
                                    <% } %>
                                </select>
                            </div>

                            <!-- Sort By -->
                            <div class="flex-1">
                                <label for="sortBy" class="block text-sm font-medium text-gray-700 mb-1">Sort By</label>
                                <select id="sortBy" name="sortBy" class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                    <option value="" <%= "".equals(selectedSort) ? "selected" : "" %>>Default</option>
                                    <option value="priceAsc" <%= "priceAsc".equals(selectedSort) ? "selected" : "" %>>Price: Low to High</option>
                                    <option value="priceDesc" <%= "priceDesc".equals(selectedSort) ? "selected" : "" %>>Price: High to Low</option>
                                    <option value="nameAsc" <%= "nameAsc".equals(selectedSort) ? "selected" : "" %>>Name: A to Z</option>
                                    <option value="nameDesc" <%= "nameDesc".equals(selectedSort) ? "selected" : "" %>>Name: Z to A</option>
                                </select>
                            </div>

                            <!-- Apply Button -->
                            <div>
                                <button type="submit" class="w-full md:w-auto px-4 py-2 border border-transparent rounded-md shadow-sm text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                                    Apply Filters
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Bikes Grid -->
                    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <% if (bikes != null && !bikes.isEmpty()) {
                            for (int i = 0; i < bikes.size(); i++) {
                                Bike bike = bikes.get(i);
                                double rating = bikeRatings.get(i);
                        %>
                            <div class="bg-white rounded-lg shadow overflow-hidden">
                                <img src="<%= bike.getImageUrl() %>" alt="<%= bike.getName() %>" class="w-full h-48 object-cover">
                                <div class="p-6">
                                    <div class="flex justify-between items-start">
                                        <h3 class="text-lg font-medium text-gray-900"><%= bike.getName() %></h3>
                                        <span class="px-2 py-1 bg-green-50 text-green-600 text-xs font-semibold rounded-full"><%= bike.getType() %></span>
                                    </div>
                                    <p class="mt-2 text-sm text-gray-500"><%= bike.getDescription() %></p>

                                    <!-- Rating -->
                                    <div class="mt-2 flex items-center">
                                        <div class="flex text-yellow-400">
                                            <% for (int star = 1; star <= 5; star++) { %>
                                                <% if (star <= Math.round(rating)) { %>
                                                    <i class="fas fa-star"></i>
                                                <% } else { %>
                                                    <i class="far fa-star"></i>
                                                <% } %>
                                            <% } %>
                                        </div>
                                        <span class="ml-1 text-sm text-gray-500">
                                            <%= rating > 0 ? df.format(rating) + " / 5" : "No ratings yet" %>
                                        </span>
                                    </div>

                                    <!-- Pricing -->
                                    <div class="mt-4 flex justify-between items-center">
                                        <div>
                                            <p class="text-sm text-gray-500">Hourly Rate</p>
                                            <p class="text-lg font-semibold text-green-600">$<%= df.format(bike.getHourlyRate()) %></p>
                                        </div>
                                        <div>
                                            <p class="text-sm text-gray-500">Daily Rate</p>
                                            <p class="text-lg font-semibold text-green-600">$<%= df.format(bike.getDailyRate()) %></p>
                                        </div>
                                    </div>

                                    <!-- Rent Buttons -->
                                    <div class="mt-6">
                                        <% if (pendingRentals != null && pendingRentals.containsKey(bike.getId()) && pendingRentals.get(bike.getId())) { %>
                                            <!-- Show message if bike is already requested or rented by this user -->
                                            <div class="bg-yellow-100 border border-yellow-400 text-yellow-700 px-4 py-3 rounded text-center">
                                                <span class="font-medium">Rental Request Pending or Approved</span>
                                                <p class="text-sm">You have already requested or rented this bike.</p>
                                            </div>
                                        <% } else if (!bike.isAvailable()) { %>
                                            <!-- Show message if bike is not available -->
                                            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded text-center">
                                                <span class="font-medium">Not Available</span>
                                                <p class="text-sm">This bike is currently <%= bike.getStatus() %>.</p>
                                            </div>
                                        <% } else { %>
                                            <!-- Show rent buttons if bike is available -->
                                            <div class="flex space-x-2">
                                                <form action="<%= request.getContextPath() %>/rent" method="post" class="flex-1">
                                                    <input type="hidden" name="bikeId" value="<%= bike.getId() %>">
                                                    <input type="hidden" name="rentalType" value="Hourly">
                                                    <button type="submit" class="w-full px-4 py-2 border border-transparent rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                                                        Rent Hourly
                                                    </button>
                                                </form>
                                                <form action="<%= request.getContextPath() %>/rent" method="post" class="flex-1">
                                                    <input type="hidden" name="bikeId" value="<%= bike.getId() %>">
                                                    <input type="hidden" name="rentalType" value="Daily">
                                                    <button type="submit" class="w-full px-4 py-2 border border-transparent rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                                                        Rent Daily
                                                    </button>
                                                </form>
                                            </div>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        <% }
                        } else { %>
                            <div class="col-span-3 bg-white rounded-lg shadow p-6 text-center">
                                <p class="text-gray-500">No bikes available matching your criteria.</p>
                            </div>
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
