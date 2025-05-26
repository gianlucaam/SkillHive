package com.skillhive.servlet;

import com.skillhive.model.Service;
import com.skillhive.model.User;
import com.skillhive.dao.DataStub;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/delete-service")
public class DeleteServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String serviceIdStr = request.getParameter("serviceId");
        
        // Debug: log del parametro ricevuto
        System.out.println("DeleteServiceServlet - ServiceID ricevuto: " + serviceIdStr);
        
        int serviceId;
        try {
            serviceId = Integer.parseInt(serviceIdStr);
        } catch (NumberFormatException e) {
            System.out.println("DeleteServiceServlet - Errore parsing ID: " + e.getMessage());
            session.setAttribute("errorMessage", "Errore: ID servizio non valido.");
            response.sendRedirect("utente/sales-dashboard.jsp");
            return;
        }

        // Utilizza il metodo centralizzato in DataStub per rimuovere il servizio
        boolean removed = DataStub.removeService(serviceId, user.getId());
        
        if (removed) {
            // Imposta messaggio di successo
            session.setAttribute("successMessage", "Servizio eliminato con successo!");
        } else {
            System.out.println("DeleteServiceServlet - Errore durante l'eliminazione del servizio.");
            session.setAttribute("errorMessage", "Errore durante l'eliminazione del servizio.");
        }
        
        response.sendRedirect("utente/sales-dashboard.jsp");
    }
}