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

public class AdminUpdateTicketServlet extends HttpServlet {
    
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
        String ticketIdStr = request.getParameter("ticketId");
        String action = request.getParameter("action"); // update-status, update-priority, assign
        
        if (ticketIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/admin/support?error=missing_params");
            return;
        }
        
        try {
            long ticketId = Long.parseLong(ticketIdStr);
            SupportTicket ticket = DataStub.getTicketById(ticketId);
            
            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/admin/support?error=ticket_not_found");
                return;
            }
            
            boolean updated = false;
            String redirectParam = "";
            
            switch (action) {
                case "update-status":
                    String status = request.getParameter("status");
                    if (status != null) {
                        updated = DataStub.updateTicketStatus(ticketId, status);
                        redirectParam = "status_updated";
                    }
                    break;
                    
                case "update-priority":
                    String priority = request.getParameter("priority");
                    if (priority != null) {
                        updated = DataStub.updateTicketPriority(ticketId, priority);
                        redirectParam = "priority_updated";
                    }
                    break;
                    
                case "assign":
                    // Assegna il ticket all'admin corrente
                    updated = DataStub.assignTicketToAdmin(ticketId, user.getId());
                    redirectParam = "ticket_assigned";
                    break;
            }
            
            if (updated) {
                response.sendRedirect(request.getContextPath() + "/admin/support/ticket?id=" + ticketId + "&success=" + redirectParam);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/support/ticket?id=" + ticketId + "&error=update_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/support?error=invalid_id");
        }
    }
}
