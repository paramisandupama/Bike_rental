package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Inquiry;
import model.User;
import service.InquiryService;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/inquiries", "/admin/inquiries/update/*", "/admin/inquiries/delete/*"})
public class AdminInquiryServlet extends HttpServlet {
    private InquiryService inquiryService;

    @Override
    public void init() {
        inquiryService = new InquiryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
            return;
        }

        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        if (path.equals("/admin/inquiries") && pathInfo == null) {
            // Get all inquiries
            List<Inquiry> allInquiries = inquiryService.getAllInquiries();

            // Set attributes for the JSP
            request.setAttribute("allInquiries", allInquiries);

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
            request.getRequestDispatcher("/Admin_ADVER/manageInquiries.jsp").forward(request, response);
        } else if (path.equals("/admin/inquiries/delete") && pathInfo != null) {
            try {
                // Extract inquiry ID from path
                int inquiryId = Integer.parseInt(pathInfo.substring(1));

                // Delete the inquiry
                boolean deleted = inquiryService.deleteInquiry(inquiryId);

                if (deleted) {
                    session.setAttribute("success", "Inquiry deleted successfully");
                } else {
                    session.setAttribute("error", "Failed to delete inquiry");
                }

                // Redirect back to inquiries page
                response.sendRedirect(request.getContextPath() + "/admin/inquiries");
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid inquiry ID");
                response.sendRedirect(request.getContextPath() + "/admin/inquiries");
            }
        } else {
            // Invalid path, redirect to inquiries page
            response.sendRedirect(request.getContextPath() + "/admin/inquiries");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is logged in and is an admin
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
            return;
        }

        String path = request.getServletPath();
        String pathInfo = request.getPathInfo();

        if (path.equals("/admin/inquiries/update") && pathInfo != null) {
            try {
                // Extract inquiry ID from path
                int inquiryId = Integer.parseInt(pathInfo.substring(1));

                // Get status from form
                String status = request.getParameter("status");

                // Validate status
                if (status == null || status.trim().isEmpty() ||
                    (!status.equals("New") && !status.equals("In Progress") && !status.equals("Resolved"))) {
                    session.setAttribute("error", "Invalid status");
                    response.sendRedirect(request.getContextPath() + "/admin/inquiries");
                    return;
                }

                // Update inquiry status
                boolean updated = inquiryService.updateInquiryStatus(inquiryId, status);

                if (updated) {
                    session.setAttribute("success", "Inquiry status updated successfully");
                } else {
                    session.setAttribute("error", "Failed to update inquiry status");
                }

                // Redirect back to inquiries page
                response.sendRedirect(request.getContextPath() + "/admin/inquiries");
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid inquiry ID");
                response.sendRedirect(request.getContextPath() + "/admin/inquiries");
            }
        } else {
            // Invalid path, redirect to inquiries page
            response.sendRedirect(request.getContextPath() + "/admin/inquiries");
        }
    }
}
