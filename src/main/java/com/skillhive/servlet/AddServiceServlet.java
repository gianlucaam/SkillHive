package com.skillhive.servlet;

import com.skillhive.model.Service;
import com.skillhive.model.User;
import com.skillhive.dao.DataStub;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;

@WebServlet("/add-service")
@MultipartConfig
public class AddServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Metodo temporaneo per debug
        response.setContentType("text/plain");
        response.getWriter().write("AddServiceServlet is running!");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve form parameters from multipart request
        String title = getPartAsString(request.getPart("title"));
        String description = getPartAsString(request.getPart("description"));
        String priceStr = getPartAsString(request.getPart("price"));
        String category = getPartAsString(request.getPart("category"));

        // Validazione
        if (title == null || title.trim().isEmpty() || title.length() > 100) {
            request.setAttribute("errorMessage", "Errore: Titolo non valido o troppo lungo.");
            request.getRequestDispatcher("utente/add-service.jsp").forward(request, response);
            return;
        }
        if (description == null || description.trim().isEmpty() || description.length() > 500) {
            request.setAttribute("errorMessage", "Errore: Descrizione non valida o troppo lunga.");
            request.getRequestDispatcher("utente/add-service.jsp").forward(request, response);
            return;
        }
        double price;
        try {
            price = Double.parseDouble(priceStr);
            if (price < 0) {
                request.setAttribute("errorMessage", "Errore: Il prezzo non può essere negativo.");
                request.getRequestDispatcher("utente/add-service.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Errore: Prezzo non valido.");
            request.getRequestDispatcher("utente/add-service.jsp").forward(request, response);
            return;
        }
        if (category == null || category.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Errore: Seleziona una categoria valida.");
            request.getRequestDispatcher("utente/add-service.jsp").forward(request, response);
            return;
        }

        // Handle file upload (optional image)
        Part filePart = request.getPart("image");
        String imagePath = null;
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = filePart.getSubmittedFileName();
            // Simulate saving the file (replace with actual file storage logic)
            imagePath = "/images/services/" + fileName; // Example path, adjust as needed
            // In a real application, save the file to a server directory or storage
            // Example: filePart.write("/path/to/storage/" + fileName);
        }

        // Creazione del servizio
        Service service = new Service();
        service.setId(DataStub.getNextServiceId());
        service.setTitle(title);
        service.setDescription(description);
        service.setPrice(price);
        service.setSellerId(user.getId());
        service.setCategory(category);
        service.setImage(imagePath); // Set image path if uploaded

        // Salva il servizio
        DataStub.addService(service);
        System.out.println("Servizio aggiunto: " + service.getTitle() + ", ID: " + service.getId());
        System.out.println("Totale servizi in DataStub: " + DataStub.getServices().size());

        // Memorizza il servizio in sessione
        session.setAttribute("newService", service);
        session.setAttribute("successMessage", "Servizio aggiunto con successo!");
        response.sendRedirect("utente/dashboard.jsp");
    }

    // Utility method to convert Part to String
    private String getPartAsString(Part part) throws IOException {
        if (part == null) {
            return null;
        }
        try (InputStream inputStream = part.getInputStream()) {
            byte[] bytes = inputStream.readAllBytes();
            return new String(bytes, "UTF-8").trim();
        }
    }
}