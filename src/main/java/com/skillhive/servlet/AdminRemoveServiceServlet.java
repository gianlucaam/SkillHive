package com.skillhive.servlet;

import com.skillhive.dao.DataStub;
import com.skillhive.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/service/remove")
public class AdminRemoveServiceServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Verifica che l'utente sia autenticato e sia admin
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        // Ottieni l'ID del servizio da rimuovere
        String serviceIdStr = request.getParameter("serviceId");
        
        if (serviceIdStr != null) {
            try {
                int serviceId = Integer.parseInt(serviceIdStr);
                
                // Rimuovi il servizio
                boolean removed = DataStub.adminRemoveService(serviceId);
                
                if (removed) {
                    response.sendRedirect(request.getContextPath() + "/admin/services?success=service_removed");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/services?error=remove_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/services?error=invalid_id");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/services?error=missing_id");
        }
    }
}
