package com.skillhive.servlet;

import com.skillhive.dao.DataStub;
import com.skillhive.model.ReportData;
import com.skillhive.model.Service;
import com.skillhive.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * Servlet to handle admin reports generation and display
 */
public class AdminReportsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in and is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get filter parameters
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String category = request.getParameter("category");
        String sellerIdStr = request.getParameter("sellerId");
        
        Date startDate = null;
        Date endDate = null;
        Integer sellerId = null;
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        
        try {
            if (startDateStr != null && !startDateStr.isEmpty()) {
                startDate = dateFormat.parse(startDateStr);
            }
            
            if (endDateStr != null && !endDateStr.isEmpty()) {
                endDate = dateFormat.parse(endDateStr);
            }
            
            if (sellerIdStr != null && !sellerIdStr.isEmpty()) {
                sellerId = Integer.parseInt(sellerIdStr);
            }
        } catch (ParseException e) {
            // Handle date parsing errors
            request.setAttribute("error", "Formato data non valido");
        }
        
        // Generate report data
        ReportData reportData = DataStub.generateReportData(startDate, endDate, category, sellerId);
        
        // Get categories for filter dropdown
        List<Service> services = DataStub.getAllServices();
        Set<String> categories = services.stream()
                .map(Service::getCategory)
                .collect(Collectors.toSet());
        
        // Get sellers for filter dropdown
        List<User> sellers = DataStub.getAllUsers().stream()
                .filter(u -> !u.isAdmin())
                .collect(Collectors.toList());
        
        // Set attributes for JSP
        request.setAttribute("reportData", reportData);
        request.setAttribute("categories", categories);
        request.setAttribute("sellers", sellers);
        request.setAttribute("startDate", startDateStr);
        request.setAttribute("endDate", endDateStr);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedSellerId", sellerIdStr);
        
        // Forward to the reports JSP page
        request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Simply forward POST requests to doGet
        doGet(request, response);
    }
}
