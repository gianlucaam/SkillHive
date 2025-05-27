package com.skillhive.servlet;

import com.skillhive.dao.DataStub;
import com.skillhive.model.SupportTicket;
import com.skillhive.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class AdminSupportTicketsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Verifica che l'utente sia autenticato e sia admin
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        // Ottieni filtro ticket (default: all)
        String filter = request.getParameter("filter");
        if (filter == null) {
            filter = "all";
        }
        
        // Ottieni tutti i ticket in base al filtro
        List<SupportTicket> tickets;
        
        switch (filter) {
            case "open":
                tickets = DataStub.getOpenTickets();
                break;
            case "dispute":
                tickets = DataStub.getTickets().stream()
                    .filter(SupportTicket::isDispute)
                    .toList();
                break;
            case "support":
                tickets = DataStub.getTickets().stream()
                    .filter(SupportTicket::isSupport)
                    .toList();
                break;
            default:
                tickets = DataStub.getTickets();
        }
        
        // Passa i dati alla JSP
        request.setAttribute("tickets", tickets);
        request.setAttribute("activeFilter", filter);
        
        // Carica i dati degli utenti per ogni ticket
        for (SupportTicket ticket : tickets) {
            User ticketUser = DataStub.getUserById((int) ticket.getUserId());
            request.setAttribute("user_" + ticket.getId(), ticketUser);
        }
        
        request.getRequestDispatcher("/admin/support.jsp").forward(request, response);
    }
}
