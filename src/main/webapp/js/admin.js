/**
 * SkillHive Admin Panel JavaScript
 * Gestisce la responsività della sidebar e altre funzionalità del pannello admin
 */

document.addEventListener('DOMContentLoaded', function() {
    // Elementi DOM
    const sidebar = document.querySelector('.admin-sidebar');
    const sidebarToggle = document.querySelector('.admin-sidebar-toggle');
    const overlay = document.querySelector('.sidebar-overlay');
    
    // Funzione per espandere/comprimere la sidebar
    function toggleSidebar() {
        sidebar.classList.toggle('expanded');
        
        if (sidebar.classList.contains('expanded')) {
            overlay.classList.add('active');
            document.body.style.overflow = 'hidden'; // Impedisce lo scrolling della pagina quando la sidebar è aperta
        } else {
            overlay.classList.remove('active');
            document.body.style.overflow = '';
        }
    }
    
    // Aggiungi event listener per il pulsante di toggle
    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', toggleSidebar);
    }
    
    // Chiudi la sidebar quando si clicca fuori
    if (overlay) {
        overlay.addEventListener('click', function() {
            sidebar.classList.remove('expanded');
            overlay.classList.remove('active');
            document.body.style.overflow = '';
        });
    }
    
    // Gestisci il ridimensionamento della finestra
    window.addEventListener('resize', function() {
        if (window.innerWidth > 768 && sidebar.classList.contains('expanded')) {
            sidebar.classList.remove('expanded');
            if (overlay) overlay.classList.remove('active');
            document.body.style.overflow = '';
        }
    });
    
    // Funzione per gestire clic sulle righe della tabella
    const tableRows = document.querySelectorAll('.admin-table tbody tr');
    tableRows.forEach(row => {
        row.addEventListener('click', function(e) {
            // Non fare nulla se il clic è su un pulsante o un link
            if (e.target.tagName === 'BUTTON' || e.target.tagName === 'A' || 
                e.target.closest('button') || e.target.closest('a') ||
                e.target.closest('.action-cell')) {
                return;
            }
            
            // Altrimenti, se la riga ha un data-href, naviga a quell'URL
            const href = this.getAttribute('data-href');
            if (href) {
                window.location.href = href;
            }
        });
    });
});
