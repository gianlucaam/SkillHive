package com.skillhive.servlet;

import com.skillhive.model.User;
import com.skillhive.dao.DataStub;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validazione
        if (username == null || username.trim().isEmpty() || username.length() > 50) {
            request.setAttribute("errorMessage", "Errore: Username non valido o troppo lungo.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (email == null || email.trim().isEmpty() || !email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) {
            request.setAttribute("errorMessage", "Errore: Email non valida.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        if (password == null || password.trim().isEmpty() || password.length() < 6) {
            request.setAttribute("errorMessage", "Errore: Password non valida o troppo corta.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Verifica unicità email
        if (!DataStub.isEmailUnique(email)) {
            request.setAttribute("errorMessage", "Errore: Email già registrata.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Crea nuovo utente
        User user = new User();
        user.setId(DataStub.getUsers().size() + 1); // ID semplice basato sulla dimensione della lista
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password); // Nota: In produzione, usa hash (es. BCrypt)

        // Aggiungi utente
        DataStub.addUser(user);

        // Crea sessione e autentica l'utente
        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("successMessage", "Registrazione completata! Benvenuto, " + user.getUsername() + "!");

        // Reindirizza alla dashboard
        response.sendRedirect("utente/dashboard.jsp");
    }
}