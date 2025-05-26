package com.skillhive.servlet;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.skillhive.dao.DataStub;
import com.skillhive.model.Order;
import com.skillhive.model.Service;
import com.skillhive.model.User;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Ottieni la sessione
        HttpSession session = request.getSession();
        if (session == null) {
            System.out.println("⚠️ Nessuna sessione attiva!");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Verifica che l'utente sia loggato
        User user = (User) session.getAttribute("user");
        if (user == null) {
            System.out.println("⚠️ Utente non loggato!");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        // Ottieni il carrello dalla sessione
        List<Service> cart = (List<Service>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            System.out.println("⚠️ Carrello vuoto!");
            response.sendRedirect(request.getContextPath() + "/utente/cart.jsp");
            return;
        }
        
        // Ottieni i dati di spedizione e pagamento
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String city = request.getParameter("city");
        String zip = request.getParameter("zip");
        String country = request.getParameter("country");
        String cardname = request.getParameter("cardname");
        String cardnumber = request.getParameter("cardnumber");
        String expiry = request.getParameter("expiry");
        String cvv = request.getParameter("cvv");
        
        // Validazione dei dati
        if (fullname == null || fullname.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            address == null || address.trim().isEmpty() ||
            city == null || city.trim().isEmpty() ||
            zip == null || zip.trim().isEmpty() ||
            country == null || country.trim().isEmpty() ||
            cardname == null || cardname.trim().isEmpty() ||
            cardnumber == null || cardnumber.trim().isEmpty() ||
            expiry == null || expiry.trim().isEmpty() ||
            cvv == null || cvv.trim().isEmpty()) {
            
            request.setAttribute("errorMessage", "Tutti i campi sono obbligatori.");
            request.getRequestDispatcher("/utente/checkout.jsp").forward(request, response);
            return;
        }
        
        // Crea un nuovo ordine
        Order order = new Order();
        order.setUserId(user.getId());
        order.setServices(cart);
        
        // Calcola il totale
        double total = 0.0;
        for (Service service : cart) {
            total += service.getPrice();
        }
        order.setTotal(total);
        
        // Imposta l'indirizzo di spedizione
        String shippingAddress = address + ", " + city + ", " + zip + ", " + country;
        order.setShippingAddress(shippingAddress);
        
        // Imposta il metodo di pagamento (semplificato)
        String paymentMethod = "Credit Card **** " + cardnumber.replaceAll("\\s+", "").substring(Math.max(0, cardnumber.replaceAll("\\s+", "").length() - 4));
        order.setPaymentMethod(paymentMethod);
        
        // Salva l'ordine
        DataStub.addOrder(order);
        System.out.println("✅ Ordine salvato con ID: " + order.getId());

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
