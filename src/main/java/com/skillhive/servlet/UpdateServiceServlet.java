package com.skillhive.servlet;

import java.io.IOException;
import java.io.InputStream;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import com.skillhive.dao.DataStub;
import com.skillhive.model.Service;
import com.skillhive.model.User;

@WebServlet("/update-service")
@MultipartConfig
public class UpdateServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Recupera i parametri dal form multipart
        String serviceIdStr = getPartAsString(request.getPart("serviceId"));
        String title = getPartAsString(request.getPart("title"));
        String description = getPartAsString(request.getPart("description"));
        String priceStr = getPartAsString(request.getPart("price"));
        String category = getPartAsString(request.getPart("category"));
        String deliveryTimeStr = getPartAsString(request.getPart("deliveryTime"));

        // Validazione
        int serviceId;
        try {
            serviceId = Integer.parseInt(serviceIdStr);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID servizio non valido.");
            request.getRequestDispatcher("utente/add-service.jsp").forward(request, response);
            return;
        }

        // Recupera il servizio esistente
        Service service = null;
        for (Service s : DataStub.getServices()) {
            if (s.getId() == serviceId && s.getSellerId() == user.getId()) {
                service = s;
                break;
            }
        }

        if (service == null) {
            request.setAttribute("errorMessage", "Servizio non trovato o non hai i permessi per modificarlo.");
            request.getRequestDispatcher("utente/add-service.jsp").forward(request, response);
            return;
        }

        // Validazione degli altri campi
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
        
        int deliveryTime;
        try {
            deliveryTime = Integer.parseInt(deliveryTimeStr);
            if (deliveryTime <= 0) {
                request.setAttribute("errorMessage", "Errore: I giorni di consegna devono essere un numero positivo.");
                request.getRequestDispatcher("utente/add-service.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Errore: Giorni di consegna non validi.");
            request.getRequestDispatcher("utente/add-service.jsp").forward(request, response);
            return;
        }
        
        if (category == null || category.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Errore: Seleziona una categoria valida.");
            request.getRequestDispatcher("utente/add-service.jsp").forward(request, response);
            return;
        }

        // Gestione upload immagine (se presente)
        Part filePart = request.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
            // Crea percorso per salvare l'immagine
            String uploadPath = getServletContext().getRealPath("") + "images/services/";
            
            // Assicura che la directory esista
            java.io.File uploadDir = new java.io.File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Salva il file
            filePart.write(uploadPath + fileName);
            
            // Aggiorna il percorso dell'immagine nel servizio
            service.setImage("images/services/" + fileName);
        }

        // Aggiorna i dati del servizio
        service.setTitle(title);
        service.setDescription(description);
        service.setPrice(price);
        service.setCategory(category);
        service.setDeliveryTime(deliveryTime);

        System.out.println("Servizio aggiornato: " + service.getTitle() + ", ID: " + service.getId());
        
        // Redirect alla dashboard con messaggio di successo
        session.setAttribute("successMessage", "Servizio aggiornato con successo!");
        response.sendRedirect("utente/sales-dashboard.jsp");
    }

    // Metodo utility per convertire Part in String
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
