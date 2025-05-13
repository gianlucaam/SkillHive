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
        int serviceId;
        try {
            serviceId = Integer.parseInt(serviceIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Errore: ID servizio non valido.");
            response.sendRedirect("utente/dashboard.jsp");
            return;
        }

        Service service = null;
        for (Service s : DataStub.getServices()) {
            if (s.getId() == serviceId && s.getSellerId() == user.getId()) {
                service = s;
                break;
            }
        }
        if (service == null) {
            session.setAttribute("errorMessage", "Errore: Servizio non trovato o non autorizzato.");
            response.sendRedirect("utente/dashboard.jsp");
            return;
        }

        // Rimuovi il servizio
        DataStub.getServices().remove(service);

        // Imposta messaggio di successo
        session.setAttribute("successMessage", "Servizio eliminato con successo!");
        response.sendRedirect("utente/dashboard.jsp");
    }
}