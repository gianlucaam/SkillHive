package com.skillhive.servlet;

import com.skillhive.dao.DataStub;
import com.skillhive.model.ReportData;
import com.skillhive.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

/**
 * Servlet for exporting reports in PDF or CSV format
 */
public class AdminExportReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get filter parameters
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String category = request.getParameter("category");
        String sellerIdStr = request.getParameter("sellerId");
        String format = request.getParameter("format");
        
        Date startDate = null;
        Date endDate = null;
        Integer sellerId = null;
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat displayDateFormat = new SimpleDateFormat("dd/MM/yyyy");
        
        try {
            if (startDateStr != null && !startDateStr.isEmpty()) {
                startDate = dateFormat.parse(startDateStr);
            }
            
            if (endDateStr != null && !endDateStr.isEmpty()) {
                endDate = dateFormat.parse(endDateStr);
            }
            
            if (sellerIdStr != null && !sellerIdStr.isEmpty()) {
                sellerId = Integer.parseInt(sellerIdStr);
            }
        } catch (ParseException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("Formato data non valido");
            return;
        }
        
        // Generate report data
        ReportData reportData = DataStub.generateReportData(startDate, endDate, category, sellerId);
        
        // Export based on format
        if ("csv".equalsIgnoreCase(format)) {
            exportCsv(response, reportData, startDate, endDate, category, sellerId);
        } else if ("pdf".equalsIgnoreCase(format)) {
            // Since we can't use external libraries for PDF generation,
            // we'll create an HTML file that's formatted for printing
            exportPrintableHtml(response, reportData, startDate, endDate, category, sellerId);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("Formato non supportato");
        }
    }
    
    private void exportCsv(HttpServletResponse response, ReportData reportData, 
                           Date startDate, Date endDate, String category, Integer sellerId) throws IOException {
        
        response.setContentType("text/csv");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=skillhive_report.csv");
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        DecimalFormat decimalFormat = new DecimalFormat("#,##0.00");
        
        PrintWriter writer = response.getWriter();
        
        // Write header
        writer.println("Report SkillHive");
        writer.println("Data generazione," + dateFormat.format(new Date()));
        if (startDate != null) {
            writer.println("Data inizio," + dateFormat.format(startDate));
        }
        if (endDate != null) {
            writer.println("Data fine," + dateFormat.format(endDate));
        }
        if (category != null && !category.isEmpty()) {
            writer.println("Categoria," + category);
        }
        if (sellerId != null) {
            User seller = DataStub.getUserById(sellerId);
            if (seller != null) {
                writer.println("Venditore," + seller.getUsername());
            }
        }
        writer.println();
        
        // Summary data
        writer.println("Riepilogo");
        writer.println("Vendite totali,€ " + decimalFormat.format(reportData.getTotalSales()));
        writer.println("Utenti totali," + reportData.getTotalUsers());
        writer.println("Servizi totali," + reportData.getTotalServices());
        writer.println("Ordini totali," + reportData.getTotalOrders());
        writer.println();
        
        // Sales by category
        writer.println("Vendite per categoria");
        writer.println("Categoria,Numero ordini,Importo totale,% sul totale");
        
        double totalSales = reportData.getTotalSales();
        for (Map.Entry<String, Double> entry : reportData.getSalesByCategory().entrySet()) {
            String cat = entry.getKey();
            double amount = entry.getValue();
            int count = reportData.getCategoryCounts().getOrDefault(cat, 0);
            double percentage = totalSales > 0 ? (amount / totalSales) * 100 : 0;
            
            writer.println(cat + "," + count + ",€ " + decimalFormat.format(amount) + "," + String.format("%.2f", percentage) + "%");
        }
        writer.println();
        
        // Sales by date
        writer.println("Andamento vendite");
        writer.println("Data,Importo");
        for (Map.Entry<Date, Double> entry : reportData.getSalesByDate().entrySet()) {
            writer.println(dateFormat.format(entry.getKey()) + ",€ " + decimalFormat.format(entry.getValue()));
        }
        writer.println();
        
        // Registrations by date
        writer.println("Nuove registrazioni");
        writer.println("Data,Numero registrazioni");
        for (Map.Entry<Date, Integer> entry : reportData.getRegistrationsByDate().entrySet()) {
            writer.println(dateFormat.format(entry.getKey()) + "," + entry.getValue());
        }
        
        writer.flush();
    }
    
    private void exportPrintableHtml(HttpServletResponse response, ReportData reportData,
                                    Date startDate, Date endDate, String category, Integer sellerId) throws IOException {
        
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");
        
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        DecimalFormat decimalFormat = new DecimalFormat("#,##0.00");
        
        PrintWriter writer = response.getWriter();
        
        writer.println("<!DOCTYPE html>");
        writer.println("<html lang=\"it\">");
        writer.println("<head>");
        writer.println("<meta charset=\"UTF-8\">");
        writer.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        writer.println("<title>Report SkillHive</title>");
        writer.println("<style>");
        writer.println("body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 20px; }");
        writer.println("h1 { color: #2c3e50; border-bottom: 1px solid #eee; padding-bottom: 10px; }");
        writer.println("h2 { color: #3498db; margin-top: 30px; }");
        writer.println("table { width: 100%; border-collapse: collapse; margin: 20px 0; }");
        writer.println("th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }");
        writer.println("th { background-color: #f8f9fa; font-weight: bold; }");
        writer.println(".info-box { background-color: #f8f9fa; border-radius: 5px; padding: 15px; margin-bottom: 20px; }");
        writer.println(".summary-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; margin: 30px 0; }");
        writer.println(".summary-item { background-color: #fff; border: 1px solid #ddd; border-radius: 5px; padding: 15px; text-align: center; }");
        writer.println(".summary-item h3 { margin: 0; color: #7f8c8d; font-size: 14px; }");
        writer.println(".summary-item .value { font-size: 24px; font-weight: bold; color: #2c3e50; margin: 10px 0; }");
        writer.println(".print-button { display: block; margin: 20px 0; padding: 10px 20px; background-color: #3498db; color: white; border: none; border-radius: 5px; cursor: pointer; }");
        writer.println("@media print { .print-button { display: none; } }");
        writer.println("</style>");
        writer.println("</head>");
        writer.println("<body>");
        
        writer.println("<button class=\"print-button\" onclick=\"window.print()\">Stampa Report</button>");
        
        writer.println("<h1>Report SkillHive</h1>");
        
        writer.println("<div class=\"info-box\">");
        writer.println("<p><strong>Data generazione:</strong> " + dateFormat.format(new Date()) + "</p>");
        if (startDate != null) {
            writer.println("<p><strong>Data inizio:</strong> " + dateFormat.format(startDate) + "</p>");
        }
        if (endDate != null) {
            writer.println("<p><strong>Data fine:</strong> " + dateFormat.format(endDate) + "</p>");
        }
        if (category != null && !category.isEmpty()) {
            writer.println("<p><strong>Categoria:</strong> " + category + "</p>");
        }
        if (sellerId != null) {
            User seller = DataStub.getUserById(sellerId);
            if (seller != null) {
                writer.println("<p><strong>Venditore:</strong> " + seller.getUsername() + "</p>");
            }
        }
        writer.println("</div>");
        
        writer.println("<h2>Riepilogo</h2>");
        writer.println("<div class=\"summary-grid\">");
        writer.println("<div class=\"summary-item\">");
        writer.println("<h3>Vendite Totali</h3>");
        writer.println("<div class=\"value\">€ " + decimalFormat.format(reportData.getTotalSales()) + "</div>");
        writer.println("</div>");
        
        writer.println("<div class=\"summary-item\">");
        writer.println("<h3>Utenti Totali</h3>");
        writer.println("<div class=\"value\">" + reportData.getTotalUsers() + "</div>");
        writer.println("</div>");
        
        writer.println("<div class=\"summary-item\">");
        writer.println("<h3>Servizi Totali</h3>");
        writer.println("<div class=\"value\">" + reportData.getTotalServices() + "</div>");
        writer.println("</div>");
        
        writer.println("<div class=\"summary-item\">");
        writer.println("<h3>Ordini Totali</h3>");
        writer.println("<div class=\"value\">" + reportData.getTotalOrders() + "</div>");
        writer.println("</div>");
        writer.println("</div>");
        
        writer.println("<h2>Vendite per Categoria</h2>");
        writer.println("<table>");
        writer.println("<thead>");
        writer.println("<tr>");
        writer.println("<th>Categoria</th>");
        writer.println("<th>Numero Ordini</th>");
        writer.println("<th>Importo Totale</th>");
        writer.println("<th>% sul Totale</th>");
        writer.println("</tr>");
        writer.println("</thead>");
        writer.println("<tbody>");
        
        double totalSales = reportData.getTotalSales();
        for (Map.Entry<String, Double> entry : reportData.getSalesByCategory().entrySet()) {
            String cat = entry.getKey();
            double amount = entry.getValue();
            int count = reportData.getCategoryCounts().getOrDefault(cat, 0);
            double percentage = totalSales > 0 ? (amount / totalSales) * 100 : 0;
            
            writer.println("<tr>");
            writer.println("<td>" + cat + "</td>");
            writer.println("<td>" + count + "</td>");
            writer.println("<td>€ " + decimalFormat.format(amount) + "</td>");
            writer.println("<td>" + String.format("%.2f", percentage) + "%</td>");
            writer.println("</tr>");
        }
        
        writer.println("</tbody>");
        writer.println("</table>");
        
        writer.println("<h2>Andamento Vendite</h2>");
        writer.println("<table>");
        writer.println("<thead>");
        writer.println("<tr>");
        writer.println("<th>Data</th>");
        writer.println("<th>Importo</th>");
        writer.println("</tr>");
        writer.println("</thead>");
        writer.println("<tbody>");
        
        for (Map.Entry<Date, Double> entry : reportData.getSalesByDate().entrySet()) {
            writer.println("<tr>");
            writer.println("<td>" + dateFormat.format(entry.getKey()) + "</td>");
            writer.println("<td>€ " + decimalFormat.format(entry.getValue()) + "</td>");
            writer.println("</tr>");
        }
        
        writer.println("</tbody>");
        writer.println("</table>");
        
        writer.println("<h2>Nuove Registrazioni</h2>");
        writer.println("<table>");
        writer.println("<thead>");
        writer.println("<tr>");
        writer.println("<th>Data</th>");
        writer.println("<th>Numero Registrazioni</th>");
        writer.println("</tr>");
        writer.println("</thead>");
        writer.println("<tbody>");
        
        for (Map.Entry<Date, Integer> entry : reportData.getRegistrationsByDate().entrySet()) {
            writer.println("<tr>");
            writer.println("<td>" + dateFormat.format(entry.getKey()) + "</td>");
            writer.println("<td>" + entry.getValue() + "</td>");
            writer.println("</tr>");
        }
        
        writer.println("</tbody>");
        writer.println("</table>");
        
        writer.println("<script>");
        writer.println("document.addEventListener('DOMContentLoaded', function() {");
        writer.println("  const printButton = document.querySelector('.print-button');");
        writer.println("  printButton.addEventListener('click', function() {");
        writer.println("    window.print();");
        writer.println("  });");
        writer.println("});");
        writer.println("</script>");
        
        writer.println("</body>");
        writer.println("</html>");
        
        writer.flush();
    }
}
