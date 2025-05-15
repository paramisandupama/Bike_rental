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

@WebServlet(urlPatterns = {"/inquiries", "/inquiries/submit", "/inquiries/edit/*", "/inquiries/delete/*"})
public class InquiryServlet extends HttpServlet {
    private InquiryService inquiryService;

    @Override
    public void init() {
        inquiryService = new InquiryService();
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

        if (path.equals("/inquiries")) {
            // Get user's inquiries
            List<Inquiry> userInquiries = inquiryService.getInquiriesByUserId(user.getId());

            // Set attributes for the JSP
            request.setAttribute("userInquiries", userInquiries);

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
            request.getRequestDispatcher("/userInquiries.jsp").forward(request, response);
        } else if (path.equals("/inquiries/delete") && pathInfo != null) {
            try {
                // Extract inquiry ID from path
                int inquiryId = Integer.parseInt(pathInfo.substring(1));

                // Get the inquiry
                Inquiry inquiry = inquiryService.getInquiryById(inquiryId);

                // Check if the inquiry belongs to the user
                if (inquiry != null && inquiry.getUserId() == user.getId()) {
                    // Delete the inquiry
                    boolean deleted = inquiryService.deleteInquiry(inquiryId);

                    if (deleted) {
                        session.setAttribute("success", "Inquiry deleted successfully");
                    } else {
                        session.setAttribute("error", "Failed to delete inquiry");
                    }
                } else {
                    session.setAttribute("error", "Invalid inquiry ID or you don't have permission to delete this inquiry");
                }

                // Redirect back to inquiries page
                response.sendRedirect(request.getContextPath() + "/inquiries");
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid inquiry ID");
                response.sendRedirect(request.getContextPath() + "/inquiries");
            }
        } else if (path.equals("/inquiries/edit") && pathInfo != null) {
            try {
                // Extract inquiry ID from path
                int inquiryId = Integer.parseInt(pathInfo.substring(1));

                // Get the inquiry
                Inquiry inquiry = inquiryService.getInquiryById(inquiryId);

                // Check if the inquiry belongs to the user
                if (inquiry != null && inquiry.getUserId() == user.getId()) {
                    // Set the inquiry as an attribute
                    request.setAttribute("inquiry", inquiry);

                    // Forward to the edit page
                    request.getRequestDispatcher("/editInquiry.jsp").forward(request, response);
                    return;
                } else {
                    session.setAttribute("error", "Invalid inquiry ID or you don't have permission to edit this inquiry");
                }

                // Redirect back to inquiries page
                response.sendRedirect(request.getContextPath() + "/inquiries");
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid inquiry ID");
                response.sendRedirect(request.getContextPath() + "/inquiries");
            }
        } else {
            // Invalid path, redirect to inquiries page
            response.sendRedirect(request.getContextPath() + "/inquiries");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        if (path.equals("/inquiries/submit")) {
            // Get form data
            String subject = request.getParameter("subject");
            String message = request.getParameter("message");
            String returnUrl = request.getParameter("returnUrl");

            // Validate form data
            if (subject == null || subject.trim().isEmpty() || message == null || message.trim().isEmpty()) {
                session.setAttribute("error", "Subject and message are required");

                // Redirect back to the page the user was on
                if (returnUrl != null && !returnUrl.isEmpty()) {
                    response.sendRedirect(returnUrl);
                } else {
                    response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
                }
                return;
            }

            // Create inquiry
            Inquiry inquiry = inquiryService.createInquiry(user, subject, message);

            if (inquiry != null) {
                // Set success message
                session.setAttribute("success", "Your inquiry has been submitted successfully");
            } else {
                // Set error message
                session.setAttribute("error", "Failed to submit inquiry");
            }

            // Redirect back to the page the user was on
            if (returnUrl != null && !returnUrl.isEmpty()) {
                response.sendRedirect(returnUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/userDashboard.jsp");
            }
        } else if (path.equals("/inquiries/edit") && pathInfo != null) {
            try {
                // Extract inquiry ID from path
                int inquiryId = Integer.parseInt(pathInfo.substring(1));

                // Get form data
                String subject = request.getParameter("subject");
                String message = request.getParameter("message");

                // Validate form data
                if (subject == null || subject.trim().isEmpty() || message == null || message.trim().isEmpty()) {
                    session.setAttribute("error", "Subject and message are required");
                    response.sendRedirect(request.getContextPath() + "/inquiries/edit/" + inquiryId);
                    return;
                }

                // Get the inquiry
                Inquiry inquiry = inquiryService.getInquiryById(inquiryId);

                // Check if the inquiry belongs to the user
                if (inquiry != null && inquiry.getUserId() == user.getId()) {
                    // Update the inquiry
                    inquiry.setSubject(subject);
                    inquiry.setMessage(message);

                    boolean updated = inquiryService.updateInquiry(inquiry);

                    if (updated) {
                        session.setAttribute("success", "Inquiry updated successfully");
                    } else {
                        session.setAttribute("error", "Failed to update inquiry");
                    }
                } else {
                    session.setAttribute("error", "Invalid inquiry ID or you don't have permission to edit this inquiry");
                }

                // Redirect back to inquiries page
                response.sendRedirect(request.getContextPath() + "/inquiries");
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid inquiry ID");
                response.sendRedirect(request.getContextPath() + "/inquiries");
            }
        } else {
            // Invalid path, redirect to inquiries page
            response.sendRedirect(request.getContextPath() + "/inquiries");
        }
    }
}
