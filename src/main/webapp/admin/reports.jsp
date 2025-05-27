<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.skillhive.model.*" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    ReportData reportData = (ReportData) request.getAttribute("reportData");
    Set<String> categories = (Set<String>) request.getAttribute("categories");
    List<User> sellers = (List<User>) request.getAttribute("sellers");
    String startDate = (String) request.getAttribute("startDate");
    String endDate = (String) request.getAttribute("endDate");
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    String selectedSellerId = (String) request.getAttribute("selectedSellerId");
    String error = (String) request.getAttribute("error");
    
    // Format numbers
    DecimalFormat decimalFormat = new DecimalFormat("#,##0.00");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd");
    
    // Prepare data for charts
    Map<Date, Double> salesByDate = reportData != null ? reportData.getSalesByDate() : new HashMap<>();
    Map<String, Double> salesByCategory = reportData != null ? reportData.getSalesByCategory() : new HashMap<>();
    Map<Date, Integer> registrationsByDate = reportData != null ? reportData.getRegistrationsByDate() : new HashMap<>();
    Map<String, Integer> categoryCounts = reportData != null ? reportData.getCategoryCounts() : new HashMap<>();
    
    // Convert to JSON format for JavaScript
    StringBuilder salesByDateJson = new StringBuilder("{");
    StringBuilder salesByCategoryJson = new StringBuilder("{");
    StringBuilder registrationsByDateJson = new StringBuilder("{");
    StringBuilder categoryCountsJson = new StringBuilder("{");
    
    if (reportData != null) {
        // Sales by date
        int i = 0;
        for (Map.Entry<Date, Double> entry : salesByDate.entrySet()) {
            if (i > 0) salesByDateJson.append(",");
            salesByDateJson.append('"').append(dateFormat.format(entry.getKey())).append('"').append(":").append(entry.getValue());
            i++;
        }
        
        // Sales by category
        i = 0;
        for (Map.Entry<String, Double> entry : salesByCategory.entrySet()) {
            if (i > 0) salesByCategoryJson.append(",");
            salesByCategoryJson.append('"').append(entry.getKey()).append('"').append(":").append(entry.getValue());
            i++;
        }
        
        // Registrations by date
        i = 0;
        for (Map.Entry<Date, Integer> entry : registrationsByDate.entrySet()) {
            if (i > 0) registrationsByDateJson.append(",");
            registrationsByDateJson.append('"').append(dateFormat.format(entry.getKey())).append('"').append(":").append(entry.getValue());
            i++;
        }
        
        // Category counts
        i = 0;
        for (Map.Entry<String, Integer> entry : categoryCounts.entrySet()) {
            if (i > 0) categoryCountsJson.append(",");
            categoryCountsJson.append('"').append(entry.getKey()).append('"').append(":").append(entry.getValue());
            i++;
        }
    }
    
    salesByDateJson.append("}");
    salesByCategoryJson.append("}");
    registrationsByDateJson.append("}");
    categoryCountsJson.append("}");
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SkillHive Admin - Report e Analisi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .report-container {
            background-color: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }
        
        .dashboard-summary {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .summary-card {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 1.5rem;
            text-align: center;
        }
        
        .summary-card h3 {
            color: #7f8c8d;
            font-size: 1rem;
            margin-bottom: 0.5rem;
        }
        
        .summary-card .value {
            font-size: 2rem;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .chart-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(500px, 1fr));
            gap: 2rem;
        }
        
        .chart {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 1.5rem;
            min-height: 300px;
        }
        
        .chart-title {
            text-align: center;
            margin-bottom: 1rem;
            color: #2c3e50;
        }
        
        .chart-canvas {
            width: 100%;
            height: 250px;
            position: relative;
        }
        
        .chart-bar, .chart-pie-slice {
            position: absolute;
            bottom: 0;
            background-color: #3498db;
            border-top-left-radius: 4px;
            border-top-right-radius: 4px;
            transition: height 0.5s ease;
        }
        
        .chart-label {
            position: absolute;
            bottom: -25px;
            text-align: center;
            font-size: 0.8rem;
            color: #7f8c8d;
            transform: rotate(-45deg);
            transform-origin: top left;
            white-space: nowrap;
        }
        
        .chart-value {
            position: absolute;
            top: -20px;
            text-align: center;
            font-size: 0.8rem;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .filter-form {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 2rem;
            align-items: flex-end;
        }
        
        .filter-group {
            flex: 1;
            min-width: 200px;
        }
        
        .filter-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }
        
        .export-options {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1.5rem;
        }
        
        .data-table th {
            background-color: #f1f1f1;
            padding: 0.75rem;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #ddd;
        }
        
        .data-table td {
            padding: 0.75rem;
            border-bottom: 1px solid #ddd;
        }
        
        .data-table tr:hover {
            background-color: #f9f9f9;
        }
        
        .pie-chart {
            width: 250px;
            height: 250px;
            position: relative;
            border-radius: 50%;
            margin: 0 auto;
        }
        
        .pie-legend {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 1.5rem;
            justify-content: center;
        }
        
        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .legend-color {
            width: 15px;
            height: 15px;
            border-radius: 3px;
        }
    </style>
</head>
<body>
    <% 
    // Controllo autorizzazioni - l'utente deve essere admin
    User user = (User) session.getAttribute("user");
    if (user == null || !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=unauthorized");
        return;
    }
    %>
    
    <!-- Toggle per la sidebar mobile -->
    <button class="admin-sidebar-toggle" aria-label="Toggle menu">
        <i class="fas fa-bars"></i>
    </button>
    
    <!-- Overlay per chiudere la sidebar su mobile -->
    <div class="sidebar-overlay"></div>
    
    <div class="admin-container">
        <div class="admin-sidebar">
            <div class="admin-sidebar-header">
                <h2>SkillHive Admin</h2>
            </div>
            <nav class="admin-nav">
                <a href="${pageContext.request.contextPath}/admin/services">Gestione Servizi</a>
                <a href="${pageContext.request.contextPath}/admin/support">Gestione Assistenza</a>
                <a href="${pageContext.request.contextPath}/admin/reports" class="active">Report e Analisi</a>
                <!-- Altri link della sidebar -->
            </nav>
        </div>
        
        <div class="admin-content">
            <header class="admin-header">
                <h1>Report e Analisi Avanzate</h1>
                <div class="admin-user">
                    <span>Admin</span>
                    <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
                </div>
            </header>
            
            <% if (error != null) { %>
                <div class="alert alert-error">
                    <%= error %>
                </div>
            <% } %>
            
            <div class="report-container">
                <h2 class="mb-3">Filtri</h2>
                <form action="${pageContext.request.contextPath}/admin/reports" method="get" class="filter-form">
                    <div class="filter-group">
                        <label for="startDate">Data Inizio:</label>
                        <input type="date" id="startDate" name="startDate" class="form-control" value="<%= startDate != null ? startDate : "" %>">
                    </div>
                    
                    <div class="filter-group">
                        <label for="endDate">Data Fine:</label>
                        <input type="date" id="endDate" name="endDate" class="form-control" value="<%= endDate != null ? endDate : "" %>">
                    </div>
                    
                    <div class="filter-group">
                        <label for="category">Categoria:</label>
                        <select id="category" name="category" class="form-control">
                            <option value="">Tutte le categorie</option>
                            <% if (categories != null) {
                                for (String cat : categories) { %>
                                    <option value="<%= cat %>" <%= cat.equals(selectedCategory) ? "selected" : "" %>><%= cat %></option>
                                <% }
                            } %>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label for="sellerId">Venditore:</label>
                        <select id="sellerId" name="sellerId" class="form-control">
                            <option value="">Tutti i venditori</option>
                            <% if (sellers != null) {
                                for (User seller : sellers) { %>
                                    <option value="<%= seller.getId() %>" <%= String.valueOf(seller.getId()).equals(selectedSellerId) ? "selected" : "" %>><%= seller.getUsername() %></option>
                                <% }
                            } %>
                        </select>
                    </div>
                    
                    <div class="filter-group" style="flex: 0;">
                        <button type="submit" class="btn btn-primary">Applica Filtri</button>
                    </div>
                </form>
                
                <div class="export-options">
                    <h2 class="mb-0">Esporta Report</h2>
                    <a href="${pageContext.request.contextPath}/admin/reports/export?format=pdf<%= startDate != null ? "&startDate=" + startDate : "" %><%= endDate != null ? "&endDate=" + endDate : "" %><%= selectedCategory != null ? "&category=" + selectedCategory : "" %><%= selectedSellerId != null ? "&sellerId=" + selectedSellerId : "" %>" class="btn btn-secondary" target="_blank">Esporta PDF</a>
                    <a href="${pageContext.request.contextPath}/admin/reports/export?format=csv<%= startDate != null ? "&startDate=" + startDate : "" %><%= endDate != null ? "&endDate=" + endDate : "" %><%= selectedCategory != null ? "&category=" + selectedCategory : "" %><%= selectedSellerId != null ? "&sellerId=" + selectedSellerId : "" %>" class="btn btn-secondary" target="_blank">Esporta CSV</a>
                </div>
                
                <div class="dashboard-summary">
                    <div class="summary-card">
                        <h3>Vendite Totali</h3>
                        <div class="value">u20AC <%= reportData != null ? decimalFormat.format(reportData.getTotalSales()) : "0,00" %></div>
                    </div>
                    
                    <div class="summary-card">
                        <h3>Utenti Totali</h3>
                        <div class="value"><%= reportData != null ? reportData.getTotalUsers() : 0 %></div>
                    </div>
                    
                    <div class="summary-card">
                        <h3>Servizi Totali</h3>
                        <div class="value"><%= reportData != null ? reportData.getTotalServices() : 0 %></div>
                    </div>
                    
                    <div class="summary-card">
                        <h3>Ordini Totali</h3>
                        <div class="value"><%= reportData != null ? reportData.getTotalOrders() : 0 %></div>
                    </div>
                </div>
                
                <div class="chart-container">
                    <div class="chart">
                        <h3 class="chart-title">Andamento Vendite</h3>
                        <div id="salesChart" class="chart-canvas"></div>
                    </div>
                    
                    <div class="chart">
                        <h3 class="chart-title">Vendite per Categoria</h3>
                        <div id="categorySalesChart" class="chart-canvas">
                            <div class="pie-chart" id="categorySalesPie"></div>
                            <div class="pie-legend" id="categorySalesLegend"></div>
                        </div>
                    </div>
                    
                    <div class="chart">
                        <h3 class="chart-title">Nuove Registrazioni</h3>
                        <div id="registrationsChart" class="chart-canvas"></div>
                    </div>
                    
                    <div class="chart">
                        <h3 class="chart-title">Popolaritu00e0 Categorie</h3>
                        <div id="categoryPopularityChart" class="chart-canvas">
                            <div class="pie-chart" id="categoryPopularityPie"></div>
                            <div class="pie-legend" id="categoryPopularityLegend"></div>
                        </div>
                    </div>
                </div>
                
                <div class="table-container mt-3">
                    <h3 class="mb-2">Dettaglio Vendite per Categoria</h3>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Categoria</th>
                                <th>Numero Ordini</th>
                                <th>Importo Totale</th>
                                <th>% sul Totale</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            if (reportData != null && reportData.getSalesByCategory() != null) {
                                double totalSales = reportData.getTotalSales();
                                for (Map.Entry<String, Double> entry : reportData.getSalesByCategory().entrySet()) {
                                    String category = entry.getKey();
                                    double amount = entry.getValue();
                                    int count = reportData.getCategoryCounts().getOrDefault(category, 0);
                                    double percentage = totalSales > 0 ? (amount / totalSales) * 100 : 0;
                            %>
                                <tr>
                                    <td><%= category %></td>
                                    <td><%= count %></td>
                                    <td>u20AC <%= decimalFormat.format(amount) %></td>
                                    <td><%= String.format("%.2f", percentage) %>%</td>
                                </tr>
                            <% 
                                }
                            }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Sales by date chart
            const salesData = <%= salesByDateJson.toString() %>;
            createBarChart('salesChart', salesData, '#3498db', 'Vendite (u20AC)');
            
            // Sales by category pie chart
            const categorySalesData = <%= salesByCategoryJson.toString() %>;
            createPieChart('categorySalesPie', 'categorySalesLegend', categorySalesData);
            
            // Registrations chart
            const registrationsData = <%= registrationsByDateJson.toString() %>;
            createBarChart('registrationsChart', registrationsData, '#2ecc71', 'Utenti');
            
            // Category popularity pie chart
            const categoryPopularityData = <%= categoryCountsJson.toString() %>;
            createPieChart('categoryPopularityPie', 'categoryPopularityLegend', categoryPopularityData);
        });
        
        function createBarChart(containerId, data, barColor, valueLabel) {
            const container = document.getElementById(containerId);
            container.innerHTML = '';
            
            if (Object.keys(data).length === 0) {
                const noData = document.createElement('div');
                noData.style.textAlign = 'center';
                noData.style.padding = '2rem';
                noData.style.color = '#7f8c8d';
                noData.innerText = 'Nessun dato disponibile';
                container.appendChild(noData);
                return;
            }
            
            const values = Object.values(data);
            const maxValue = Math.max(...values);
            const containerWidth = container.clientWidth;
            const barWidth = Math.min(50, (containerWidth / (Object.keys(data).length + 1)));
            const spacing = Math.min(20, (containerWidth / (Object.keys(data).length * 2)));
            
            let i = 0;
            for (const [label, value] of Object.entries(data)) {
                const barHeight = (value / maxValue) * (container.clientHeight - 30);
                
                const bar = document.createElement('div');
                bar.className = 'chart-bar';
                bar.style.height = barHeight + 'px';
                bar.style.width = barWidth + 'px';
                bar.style.left = (i * (barWidth + spacing) + spacing) + 'px';
                bar.style.backgroundColor = barColor;
                container.appendChild(bar);
                
                const labelEl = document.createElement('div');
                labelEl.className = 'chart-label';
                labelEl.innerText = label;
                labelEl.style.width = barWidth + 'px';
                labelEl.style.left = (i * (barWidth + spacing) + spacing) + 'px';
                container.appendChild(labelEl);
                
                const valueEl = document.createElement('div');
                valueEl.className = 'chart-value';
                valueEl.innerText = valueLabel === 'Vendite (u20AC)' 
                    ? 'u20AC ' + value.toFixed(2) 
                    : value;
                valueEl.style.width = barWidth + 'px';
                valueEl.style.left = (i * (barWidth + spacing) + spacing) + 'px';
                container.appendChild(valueEl);
                
                i++;
            }
        }
        
        function createPieChart(pieId, legendId, data) {
            const pieContainer = document.getElementById(pieId);
            const legendContainer = document.getElementById(legendId);
            pieContainer.innerHTML = '';
            legendContainer.innerHTML = '';
            
            if (Object.keys(data).length === 0) {
                const noData = document.createElement('div');
                noData.style.textAlign = 'center';
                noData.style.padding = '2rem';
                noData.style.color = '#7f8c8d';
                noData.innerText = 'Nessun dato disponibile';
                pieContainer.appendChild(noData);
                return;
            }
            
            const colors = [
                '#3498db', '#2ecc71', '#e74c3c', '#f39c12', '#9b59b6', 
                '#1abc9c', '#d35400', '#c0392b', '#16a085', '#8e44ad'
            ];
            
            const total = Object.values(data).reduce((sum, value) => sum + value, 0);
            let startAngle = 0;
            
            let i = 0;
            for (const [label, value] of Object.entries(data)) {
                const percentage = (value / total) * 100;
                const sliceAngle = (value / total) * 360;
                const endAngle = startAngle + sliceAngle;
                const color = colors[i % colors.length];
                
                // Create pie slice
                const slice = document.createElement('div');
                slice.style.position = 'absolute';
                slice.style.width = '100%';
                slice.style.height = '100%';
                slice.style.top = '0';
                slice.style.left = '0';
                slice.style.clip = `rect(0, 250px, 250px, 125px)`;
                pieContainer.appendChild(slice);
                
                // Create inner slice (first half)
                const innerSlice1 = document.createElement('div');
                innerSlice1.style.position = 'absolute';
                innerSlice1.style.width = '100%';
                innerSlice1.style.height = '100%';
                innerSlice1.style.top = '0';
                innerSlice1.style.left = '0';
                innerSlice1.style.backgroundColor = color;
                innerSlice1.style.transformOrigin = 'center center';
                innerSlice1.style.transform = `rotate(${startAngle}deg)`;
                slice.appendChild(innerSlice1);
                
                // If slice is more than 180 degrees, add second half
                if (sliceAngle > 180) {
                    const slice2 = document.createElement('div');
                    slice2.style.position = 'absolute';
                    slice2.style.width = '100%';
                    slice2.style.height = '100%';
                    slice2.style.top = '0';
                    slice2.style.left = '0';
                    slice2.style.clip = `rect(0, 125px, 250px, 0)`;
                    pieContainer.appendChild(slice2);
                    
                    const innerSlice2 = document.createElement('div');
                    innerSlice2.style.position = 'absolute';
                    innerSlice2.style.width = '100%';
                    innerSlice2.style.height = '100%';
                    innerSlice2.style.top = '0';
                    innerSlice2.style.left = '0';
                    innerSlice2.style.backgroundColor = color;
                    innerSlice2.style.transformOrigin = 'center center';
                    innerSlice2.style.transform = `rotate(${startAngle + 180}deg)`;
                    slice2.appendChild(innerSlice2);
                }
                
                // Add legend item
                const legendItem = document.createElement('div');
                legendItem.className = 'legend-item';
                
                const legendColor = document.createElement('div');
                legendColor.className = 'legend-color';
                legendColor.style.backgroundColor = color;
                
                const legendLabel = document.createElement('span');
                legendLabel.innerText = `${label} (${percentage.toFixed(1)}%)`;
                
                legendItem.appendChild(legendColor);
                legendItem.appendChild(legendLabel);
                legendContainer.appendChild(legendItem);
                
                startAngle = endAngle;
                i++;
            }
        }
    </script>
    
    <!-- Script per la gestione della sidebar e delle funzionalitu00e0 responsive -->
    <script src="${pageContext.request.contextPath}/js/admin.js"></script>
</body>
</html>
