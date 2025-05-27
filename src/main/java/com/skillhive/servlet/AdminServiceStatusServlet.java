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

@WebServlet("/admin/service/status")
public class AdminServiceStatusServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Verifica che l'utente sia autenticato e sia admin
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        // Parametri dalla richiesta
        String serviceIdStr = request.getParameter("serviceId");
        String status = request.getParameter("status"); // "approved" o "rejected"
        
        if (serviceIdStr != null && status != null) {
            try {
                int serviceId = Integer.parseInt(serviceIdStr);
                
                // Aggiorna lo stato del servizio
                boolean updated = DataStub.updateServiceStatus(serviceId, status);
                
                if (updated) {
                    response.sendRedirect(request.getContextPath() + "/admin/services?success=status_updated");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/services?error=update_failed");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin/services?error=invalid_id");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/services?error=missing_params");
        }
    }
}
