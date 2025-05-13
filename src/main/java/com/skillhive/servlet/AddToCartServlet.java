package com.skillhive.servlet;

import com.skillhive.model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        String serviceIdStr = request.getParameter("serviceId");
        String title = request.getParameter("title");
        String priceStr = request.getParameter("price");
        String sellerIdStr = request.getParameter("sellerId");

        // Validazione
        int serviceId;
        double price;
        int sellerId;
        try {
            serviceId = Integer.parseInt(serviceIdStr);
            price = Double.parseDouble(priceStr);
            sellerId = Integer.parseInt(sellerIdStr);
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Errore: Dati non validi.");
            response.sendRedirect("utente/dashboard.jsp");
            return;
        }

        if (title == null || title.trim().isEmpty()) {
            session.setAttribute("errorMessage", "Errore: Titolo non valido.");
            response.sendRedirect("utente/dashboard.jsp");
            return;
        }

        // Crea il servizio
        Service service = new Service();
        service.setId(serviceId);
        service.setTitle(title);
        service.setPrice(price);
        service.setSellerId(sellerId);
        // description e category non sono necessari per il carrello, lasciati null

        // Aggiungi al carrello
        List<Service> cart = (List<Service>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
        }
        cart.add(service);
        session.setAttribute("cart", cart);

        // Messaggio di successo
        session.setAttribute("successMessage", "Servizio aggiunto al carrello!");
        response.sendRedirect("utente/dashboard.jsp");
    }
}