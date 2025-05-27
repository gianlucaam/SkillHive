package com.skillhive.servlet;

import com.skillhive.dao.DataStub;
import com.skillhive.model.Message;
import com.skillhive.model.Order;
import com.skillhive.model.SupportTicket;
import com.skillhive.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminViewTicketServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        // Verifica che l'utente sia autenticato e sia admin
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }
        
        // Ottieni l'ID del ticket
        String ticketIdStr = request.getParameter("id");
        if (ticketIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/admin/support?error=missing_id");
            return;
        }
        
        try {
            long ticketId = Long.parseLong(ticketIdStr);
            SupportTicket ticket = DataStub.getTicketById(ticketId);
            
            if (ticket == null) {
                response.sendRedirect(request.getContextPath() + "/admin/support?error=ticket_not_found");
                return;
            }
            
            // Ottieni i messaggi del ticket
            List<Message> messages = ticket.getMessages();
            
            // Ottieni i dati dell'utente che ha aperto il ticket
            User ticketUser = DataStub.getUserById((int) ticket.getUserId());
            
            // Se è una disputa, ottieni i dati dell'ordine
            Order disputeOrder = null;
            User sellerUser = null;
            if (ticket.isDispute() && ticket.getDisputeOrderId() != null) {
                disputeOrder = DataStub.getOrderById(ticket.getDisputeOrderId());
                
                // Trova il venditore dalla lista di servizi dell'ordine
                if (disputeOrder != null && !disputeOrder.getServices().isEmpty()) {
                    int sellerId = disputeOrder.getServices().get(0).getSellerId();
                    sellerUser = DataStub.getUserById(sellerId);
                }
            }
            
            // Passa i dati alla JSP
            request.setAttribute("ticket", ticket);
            request.setAttribute("messages", messages);
            request.setAttribute("ticketUser", ticketUser);
            request.setAttribute("disputeOrder", disputeOrder);
            request.setAttribute("sellerUser", sellerUser);
            
            // Crea una mappa dei nomi utenti per ogni messaggio
            Map<Long, String> usernames = new HashMap<>();
            for (Message message : messages) {
                if (!usernames.containsKey(message.getSenderId())) {
                    User messageUser = DataStub.getUserById((int) message.getSenderId());
                    if (messageUser != null) {
                        usernames.put(message.getSenderId(), messageUser.getUsername());
                    } else if (message.isFromAdmin()) {
                        usernames.put(message.getSenderId(), "Admin");
                    } else {
                        usernames.put(message.getSenderId(), "Unknown User");
                    }
                }
            }
            request.setAttribute("usernames", usernames);
            
            request.getRequestDispatcher("/admin/view-ticket.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/support?error=invalid_id");
        }
    }
}
