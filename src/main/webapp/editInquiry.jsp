<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Inquiry" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Inquiry - Bike Rental</title>
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

        // Get inquiry from request attributes
        Inquiry inquiry = (Inquiry) request.getAttribute("inquiry");
        if (inquiry == null || inquiry.getUserId() != user.getId()) {
            response.sendRedirect(request.getContextPath() + "/inquiries");
            return;
        }

        // Get success and error messages
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
                        <a href="<%= request.getContextPath() %>/my-rentals" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-green-700">
                            <i class="fas fa-clipboard-list mr-3"></i>
                            My Rentals
                        </a>
                        <!-- Inquiries -->
                        <a href="<%= request.getContextPath() %>/inquiries" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg bg-green-700 text-white">
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
                        <h1 class="text-lg font-semibold text-gray-900">Edit Inquiry</h1>
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
                <div class="max-w-3xl mx-auto">
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

                    <!-- Edit Inquiry Form -->
                    <div class="bg-white rounded-lg shadow p-6">
                        <h2 class="text-xl font-semibold text-gray-800 mb-4">Edit Inquiry</h2>
                        <form action="<%= request.getContextPath() %>/inquiries/edit/<%= inquiry.getId() %>" method="post">
                            <div class="mb-4">
                                <label for="subject" class="block text-sm font-medium text-gray-700 mb-1">Subject</label>
                                <input type="text" id="subject" name="subject" value="<%= inquiry.getSubject() %>" required
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-green-500 focus:border-green-500">
                            </div>
                            <div class="mb-4">
                                <label for="message" class="block text-sm font-medium text-gray-700 mb-1">Message</label>
                                <textarea id="message" name="message" rows="6" required
                                          class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-green-500 focus:border-green-500"><%= inquiry.getMessage() %></textarea>
                            </div>
                            <div class="flex justify-between">
                                <a href="<%= request.getContextPath() %>/inquiries" class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                                    Cancel
                                </a>
                                <button type="submit" class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                                    Save Changes
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Include the floating inquiry button -->
    <%@ include file="components/inquiryButton.jsp" %>
</body>
</html>
