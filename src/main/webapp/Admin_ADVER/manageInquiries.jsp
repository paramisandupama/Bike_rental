<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.User" %>
<%@ page import="model.Inquiry" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Inquiries - Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-gray-100 font-sans">
    <%
        // Check if user is logged in and is an admin
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Get data from request attributes
        List<Inquiry> allInquiries = (List<Inquiry>) request.getAttribute("allInquiries");

        // Format for dates and times
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        // Get success and error messages
        String successMessage = (String) request.getAttribute("success");
        String errorMessage = (String) request.getAttribute("error");
    %>

    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <div class="hidden md:flex md:flex-shrink-0">
            <div class="flex flex-col w-64 bg-gray-800 text-white">
                <div class="flex items-center justify-center h-16 px-4 bg-gray-900">
                    <span class="text-xl font-bold">Admin Dashboard</span>
                </div>
                <div class="flex flex-col flex-grow px-4 py-4 overflow-y-auto">
                    <nav class="flex-1 space-y-2">
                        <!-- Dashboard -->
                        <a href="<%= request.getContextPath() %>/Admin_ADVER/adminDashboard.jsp" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-gray-700">
                            <i class="fas fa-tachometer-alt mr-3"></i>
                            Dashboard
                        </a>
                        <!-- Manage Bikes -->
                        <a href="<%= request.getContextPath() %>/admin/bikes" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-gray-700">
                            <i class="fas fa-bicycle mr-3"></i>
                            Manage Bikes
                        </a>
                        <!-- Manage Rental Requests -->
                        <a href="<%= request.getContextPath() %>/admin/rental-requests" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-gray-700">
                            <i class="fas fa-clipboard-list mr-3"></i>
                            Rental Requests
                        </a>
                        <!-- Manage Inquiries -->
                        <a href="<%= request.getContextPath() %>/admin/inquiries" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg bg-gray-700 text-white">
                            <i class="fas fa-question-circle mr-3"></i>
                            Manage Inquiries
                        </a>
                        <!-- Logout -->
                        <a href="<%= request.getContextPath() %>/logout" class="flex items-center px-4 py-2 text-sm font-medium rounded-lg text-white hover:bg-gray-700">
                            <i class="fas fa-sign-out-alt mr-3"></i>
                            Logout
                        </a>
                    </nav>
                </div>
                <div class="p-4 border-t border-gray-700">
                    <div class="flex items-center">
                        <div class="w-10 h-10 rounded-full bg-gray-300 text-gray-800 flex items-center justify-center font-medium">
                            <%= user.getName().substring(0, 1).toUpperCase() %>
                        </div>
                        <div class="ml-3">
                            <p class="text-sm font-medium"><%= user.getName() %></p>
                            <p class="text-xs text-gray-300"><%= user.getEmail() %></p>
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
                        <h1 class="text-lg font-semibold text-gray-900">Manage Inquiries</h1>
                    </div>
                    <div class="flex items-center space-x-4">
                        <button class="p-1 text-gray-400 rounded-full hover:text-gray-500 focus:outline-none">
                            <i class="fas fa-bell"></i>
                        </button>
                        <div class="relative">
                            <button class="flex items-center focus:outline-none">
                                <span class="hidden md:block mr-2 text-sm font-medium"><%= user.getName() %></span>
                                <div class="w-8 h-8 rounded-full bg-gray-300 text-gray-800 flex items-center justify-center font-medium">
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

                    <!-- Inquiries Table -->
                    <div class="bg-white rounded-lg shadow overflow-hidden">
                        <div class="px-4 py-5 sm:px-6 border-b border-gray-200">
                            <h3 class="text-lg leading-6 font-medium text-gray-900">
                                User Inquiries
                            </h3>
                            <p class="mt-1 max-w-2xl text-sm text-gray-500">
                                Manage and respond to user inquiries
                            </p>
                        </div>

                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            ID
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            User
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Subject
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Message
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Date
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Status
                                        </th>
                                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                            Actions
                                        </th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <% if (allInquiries != null && !allInquiries.isEmpty()) {
                                        for (Inquiry inquiry : allInquiries) {
                                    %>
                                        <tr>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                <%= inquiry.getId() %>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="flex items-center">
                                                    <div class="flex-shrink-0 h-10 w-10 rounded-full bg-gray-300 text-gray-800 flex items-center justify-center font-medium">
                                                        <%= inquiry.getUserName().substring(0, 1).toUpperCase() %>
                                                    </div>
                                                    <div class="ml-4">
                                                        <div class="text-sm font-medium text-gray-900">
                                                            <%= inquiry.getUserName() %>
                                                        </div>
                                                        <div class="text-sm text-gray-500">
                                                            <%= inquiry.getUserEmail() %>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                                                <%= inquiry.getSubject() %>
                                            </td>
                                            <td class="px-6 py-4 text-sm text-gray-500 max-w-xs truncate">
                                                <%= inquiry.getMessage() %>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                                <%= inquiry.getInquiryTime().format(dateTimeFormatter) %>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <% if ("New".equals(inquiry.getStatus())) { %>
                                                    <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-50 text-green-600">
                                                        <%= inquiry.getStatus() %>
                                                    </span>
                                                <% } else if ("In Progress".equals(inquiry.getStatus())) { %>
                                                    <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-yellow-100 text-yellow-800">
                                                        <%= inquiry.getStatus() %>
                                                    </span>
                                                <% } else if ("Resolved".equals(inquiry.getStatus())) { %>
                                                    <span class="px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-50 text-green-600">
                                                        <%= inquiry.getStatus() %>
                                                    </span>
                                                <% } %>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium">
                                                <div class="flex items-center">
                                                    <form action="<%= request.getContextPath() %>/admin/inquiries/update/<%= inquiry.getId() %>" method="post" class="inline-block mr-4">
                                                        <select name="status" class="mr-2 text-sm border-gray-300 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                                                            <option value="New" <%= "New".equals(inquiry.getStatus()) ? "selected" : "" %>>New</option>
                                                            <option value="In Progress" <%= "In Progress".equals(inquiry.getStatus()) ? "selected" : "" %>>In Progress</option>
                                                            <option value="Resolved" <%= "Resolved".equals(inquiry.getStatus()) ? "selected" : "" %>>Resolved</option>
                                                        </select>
                                                        <button type="submit" class="text-indigo-600 hover:text-indigo-900">
                                                            <i class="fas fa-save"></i> Save
                                                        </button>
                                                    </form>
                                                    <a href="#" onclick="confirmDelete(<%= inquiry.getId() %>)" class="text-red-600 hover:text-red-900">
                                                        <i class="fas fa-trash-alt"></i> Delete
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    <%
                                        }
                                    } else {
                                    %>
                                        <tr>
                                            <td colspan="7" class="px-6 py-4 text-center text-gray-500">
                                                No inquiries found.
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
        function confirmDelete(inquiryId) {
            if (confirm('Are you sure you want to delete this inquiry? This action cannot be undone.')) {
                window.location.href = '<%= request.getContextPath() %>/admin/inquiries/delete/' + inquiryId;
            }
        }
    </script>
</body>
</html>
