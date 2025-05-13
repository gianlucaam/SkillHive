package com.skillhive.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Ottieni la sessione
        HttpSession session = request.getSession();
        if (session == null) {
            System.out.println("⚠️ Nessuna sessione attiva!");
        } else {
            System.out.println("✅ Sessione attiva: " + session.getId());
        }

        // Rimuovi il carrello
        session.removeAttribute("cart");
        System.out.println("🛒 Carrello rimosso dalla sessione.");

        // Path di redirect
        String contextPath = request.getContextPath();
        String redirectPath = contextPath + "/utente/checkout-success.jsp";
        System.out.println("➡️ Redirect verso: " + redirectPath);

        // Esegui il redirect
        response.sendRedirect(redirectPath);
    }
}
