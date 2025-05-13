package com.skillhive.servlet;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.skillhive.model.Service;

@WebServlet("/remove-from-cart")
public class RemoveFromCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Recupera l'ID del servizio da rimuovere
        int serviceId = Integer.parseInt(request.getParameter("serviceId"));

        // Recupera il carrello dalla sessione
        HttpSession session = request.getSession();
        List<Service> cart = (List<Service>) session.getAttribute("cart");

        if (cart != null) {
            // Rimuovi il servizio dal carrello
            cart.removeIf(service -> service.getId() == serviceId);
            session.setAttribute("cart", cart);
        }

        // Reindirizza alla pagina del carrello
        response.sendRedirect("utente/cart.jsp"); // Aggiornato il percorso
    }
}