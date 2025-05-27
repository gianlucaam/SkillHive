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
import java.util.List;

@WebServlet("/admin/services")
public class AdminServicesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Verifica che l'utente sia autenticato e sia admin
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        // Ottieni tutti i servizi e servizi in attesa di approvazione
        List<Service> allServices = DataStub.getServices();
        List<Service> pendingServices = DataStub.getPendingServices();
        
        request.setAttribute("allServices", allServices);
        request.setAttribute("pendingServices", pendingServices);
        
        request.getRequestDispatcher("/admin/services.jsp").forward(request, response);
    }
}
