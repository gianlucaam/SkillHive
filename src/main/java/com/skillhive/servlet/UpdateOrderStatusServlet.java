package com.skillhive.servlet;

import com.skillhive.dao.DataStub;
import com.skillhive.model.Order;
import com.skillhive.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/update-order-status")
public class UpdateOrderStatusServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Verifica che l'utente sia loggato
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Recupera i parametri dalla richiesta
        String orderIdStr = request.getParameter("orderId");
        String newStatus = request.getParameter("status");
        
        // Validazione parametri
        if (orderIdStr == null || orderIdStr.isEmpty() || newStatus == null || newStatus.isEmpty()) {
            session.setAttribute("errorMessage", "Parametri mancanti per l'aggiornamento dello stato dell'ordine");
            response.sendRedirect("utente/sales-dashboard.jsp");
            return;
        }
        
        try {
            long orderId = Long.parseLong(orderIdStr);
            Order order = DataStub.getOrderById(orderId);
            
            if (order == null) {
                session.setAttribute("errorMessage", "Ordine non trovato");
                response.sendRedirect("utente/sales-dashboard.jsp");
                return;
            }
            
            // Verifica che l'utente sia autorizzato a modificare l'ordine
            // (deve essere il venditore di almeno uno dei servizi nell'ordine)
            boolean isAuthorized = order.getServices().stream()
                    .anyMatch(service -> service.getSellerId() == user.getId());
            
            if (!isAuthorized) {
                session.setAttribute("errorMessage", "Non sei autorizzato a modificare questo ordine");
                response.sendRedirect("utente/sales-dashboard.jsp");
                return;
            }
            
            // Aggiorna lo stato dell'ordine
            if ("Accepted".equals(newStatus) || "Rejected".equals(newStatus) || "Completed".equals(newStatus)) {
                order.setStatus(newStatus);
                session.setAttribute("successMessage", "Stato dell'ordine aggiornato con successo");
            } else {
                session.setAttribute("errorMessage", "Stato dell'ordine non valido");
            }
            
            response.sendRedirect("utente/sales-dashboard.jsp");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID ordine non valido");
            response.sendRedirect("utente/sales-dashboard.jsp");
        }
    }
}
