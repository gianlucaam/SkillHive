package com.skillhive.servlet;

import com.skillhive.dao.DataStub;
import com.skillhive.model.Message;
import com.skillhive.model.SupportTicket;
import com.skillhive.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AdminReplyTicketServlet extends HttpServlet {
    
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
        String content = request.getParameter("content");
        
        if (ticketIdStr == null || content == null || content.trim().isEmpty()) {
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
            
            // Crea un nuovo messaggio
            Message message = new Message();
            message.setTicketId(ticketId);
            message.setSenderId(user.getId());
            message.setSenderType("admin");
            message.setContent(content);
            
            // Aggiungi il messaggio al ticket
            DataStub.addMessage(message);
            
            // Se il ticket è ancora aperto, aggiornalo a in_progress e assegnalo all'admin corrente
            if (ticket.isOpen()) {
                DataStub.assignTicketToAdmin(ticketId, user.getId());
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/support/ticket?id=" + ticketId + "&success=reply_sent");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/support?error=invalid_id");
        }
    }
}
