<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile - Bike Rental</title>
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
                        <a href="<%= request.getContextPath() %>/profile" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg bg-green-700 text-white">
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
                        <h1 class="text-lg font-semibold text-gray-900">User Profile</h1>
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

                    <!-- Profile Information -->
                    <div class="bg-white rounded-lg shadow p-6 mb-6">
                        <div class="flex items-center mb-6">
                            <div class="w-20 h-20 rounded-full bg-green-300 text-green-800 flex items-center justify-center text-3xl font-medium">
                                <%= user.getName().substring(0, 1).toUpperCase() %>
                            </div>
                            <div class="ml-6">
                                <h2 class="text-2xl font-bold text-gray-800"><%= user.getName() %></h2>
                                <p class="text-gray-600"><%= user.getEmail() %></p>
                                <p class="text-sm text-gray-500 mt-1">Account Type: <%= user.getRole().substring(0, 1).toUpperCase() + user.getRole().substring(1) %></p>
                            </div>
                        </div>

                        <div class="border-t border-gray-200 pt-4">
                            <h3 class="text-lg font-medium text-gray-900 mb-4">Account Information</h3>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <p class="text-sm font-medium text-gray-500">Name</p>
                                    <p class="text-base text-gray-900"><%= user.getName() %></p>
                                </div>
                                <div>
                                    <p class="text-sm font-medium text-gray-500">Email</p>
                                    <p class="text-base text-gray-900"><%= user.getEmail() %></p>
                                </div>
                                <div>
                                    <p class="text-sm font-medium text-gray-500">User ID</p>
                                    <p class="text-base text-gray-900"><%= user.getId() %></p>
                                </div>
                                <div>
                                    <p class="text-sm font-medium text-gray-500">Password</p>
                                    <p class="text-base text-gray-900">••••••••</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Edit Profile Form -->
                    <div class="bg-white rounded-lg shadow p-6 mb-6">
                        <h3 class="text-lg font-medium text-gray-900 mb-4">Edit Profile</h3>
                        <form action="<%= request.getContextPath() %>/profile/edit" method="post">
                            <div class="mb-4">
                                <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Name</label>
                                <input type="text" id="name" name="name" value="<%= user.getName() %>" required
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-green-500 focus:border-green-500">
                            </div>
                            <div class="mb-4">
                                <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email (Cannot be changed)</label>
                                <input type="email" id="email" value="<%= user.getEmail() %>" disabled
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md bg-gray-100 text-gray-500">
                            </div>
                            <div class="mb-4">
                                <label for="currentPassword" class="block text-sm font-medium text-gray-700 mb-1">Current Password (Required to change password)</label>
                                <input type="password" id="currentPassword" name="currentPassword"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-green-500 focus:border-green-500">
                            </div>
                            <div class="mb-4">
                                <label for="newPassword" class="block text-sm font-medium text-gray-700 mb-1">New Password</label>
                                <input type="password" id="newPassword" name="newPassword"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-green-500 focus:border-green-500">
                            </div>
                            <div class="mb-6">
                                <label for="confirmPassword" class="block text-sm font-medium text-gray-700 mb-1">Confirm New Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword"
                                       class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-green-500 focus:border-green-500">
                            </div>
                            <div>
                                <button type="submit" class="w-full px-4 py-2 border border-transparent rounded-md shadow-sm text-white bg-green-600 hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500">
                                    Save Changes
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Delete Account Section -->
                    <div class="bg-white rounded-lg shadow p-6">
                        <h3 class="text-lg font-medium text-red-600 mb-4">Delete Account</h3>
                        <p class="text-gray-600 mb-4">Warning: This action cannot be undone. All your data will be permanently deleted.</p>
                        <button onclick="confirmDelete()" class="px-4 py-2 border border-transparent rounded-md shadow-sm text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                            Delete Account
                        </button>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Include the floating inquiry button -->
    <%@ include file="components/inquiryButton.jsp" %>

    <script>
        function confirmDelete() {
            if (confirm('Are you sure you want to delete your account? This action cannot be undone.')) {
                window.location.href = '<%= request.getContextPath() %>/profile/delete';
            }
        }
    </script>
</body>
</html>
