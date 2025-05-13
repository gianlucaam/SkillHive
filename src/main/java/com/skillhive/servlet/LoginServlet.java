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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Errore: Email o password non validi.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        User user = DataStub.getUserByEmail(email);

        if (user == null || !user.getPassword().equals(password)) {
            request.setAttribute("errorMessage", "Errore: Credenziali non valide.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", user);
        session.setAttribute("successMessage", "Login effettuato con successo! Benvenuto, " + user.getUsername() + "!");

        response.sendRedirect("utente/dashboard.jsp");
    }
}