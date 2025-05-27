package com.skillhive.servlet;

import com.skillhive.dao.DataStub;
import com.skillhive.model.Service;
import com.skillhive.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/service/edit")
public class AdminEditServiceServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Verifica che l'utente sia autenticato e sia admin
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        // Ottieni il servizio da modificare
        String serviceIdStr = request.getParameter("id");
        if (serviceIdStr != null) {
            try {
                int serviceId = Integer.parseInt(serviceIdStr);
                Service service = DataStub.getServiceById(serviceId);
                
                if (service != null) {
                    request.setAttribute("service", service);
                    request.getRequestDispatcher("/admin/edit-service.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // ID non valido, reindirizza alla lista dei servizi
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/services?error=service_not_found");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Verifica che l'utente sia autenticato e sia admin
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        // Ottieni i parametri dal form
        String serviceIdStr = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String category = request.getParameter("category");
        String deliveryTimeStr = request.getParameter("deliveryTime");
        String status = request.getParameter("status");
        
        // Verifica che tutti i parametri richiesti siano presenti
        if (serviceIdStr == null || title == null || description == null || priceStr == null || 
            category == null || deliveryTimeStr == null || status == null) {
            response.sendRedirect(request.getContextPath() + "/admin/services?error=missing_params");
            return;
        }
        
        try {
            int serviceId = Integer.parseInt(serviceIdStr);
            double price = Double.parseDouble(priceStr);
            int deliveryTime = Integer.parseInt(deliveryTimeStr);
            
            // Ottieni il servizio esistente
            Service existingService = DataStub.getServiceById(serviceId);
            if (existingService == null) {
                response.sendRedirect(request.getContextPath() + "/admin/services?error=service_not_found");
                return;
            }
            
            // Aggiorna i dati del servizio
            existingService.setTitle(title);
            existingService.setDescription(description);
            existingService.setPrice(price);
            existingService.setCategory(category);
            existingService.setDeliveryTime(deliveryTime);
            existingService.setStatus(status);
            
            // Aggiorna il servizio nel database
            boolean updated = DataStub.updateService(existingService);
            
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/services?success=service_updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/services?error=update_failed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/services?error=invalid_format");
        }
    }
}
